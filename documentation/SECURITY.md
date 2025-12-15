# Security Documentation

## Overview

UniNest implements multiple security layers to protect user data and ensure proper access control. This document covers authentication, authorization, password security, and other security measures.

## Authentication

### Session-Based Authentication

UniNest uses server-side sessions for authentication:

```java
// On successful login
req.getSession(true).setAttribute("authUser", user);

// On logout
req.getSession().invalidate();

// Checking authentication
HttpSession session = req.getSession(false);
User user = session == null ? null : (User) session.getAttribute("authUser");
```

### Login Flow

```
┌──────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Login Form   │────►│ LoginServlet    │────►│ UserDAO         │
│ (email, pwd) │     │ (POST /login)   │     │ (findByEmail)   │
└──────────────┘     └─────────────────┘     └─────────────────┘
                              │                       │
                              │                       ▼
                              │              ┌─────────────────┐
                              │              │ BCrypt.checkpw  │
                              │              │ (verify hash)   │
                              │              └─────────────────┘
                              │                       │
                              ▼                       │
                     ┌─────────────────┐             │
                     │ Create Session  │◄────────────┘
                     │ (authUser attr) │
                     └─────────────────┘
                              │
                              ▼
                     ┌─────────────────┐
                     │ Role-based      │
                     │ Redirect        │
                     └─────────────────┘
```

### Password Hashing

Passwords are hashed using BCrypt (jBCrypt library):

```java
// Hashing password
String hash = BCrypt.hashpw(password, BCrypt.gensalt());

// Verifying password
boolean valid = BCrypt.checkpw(password, storedHash);
```

**BCrypt Benefits:**
- Automatically salted (salt stored in hash)
- Adaptive work factor (configurable cost)
- Resistant to rainbow table attacks
- Industry standard for password storage

---

## Authorization

### AuthFilter

The `AuthFilter` intercepts all requests to protected paths and enforces role-based access:

**File:** `com/uninest/security/AuthFilter.java`

```java
public class AuthFilter implements Filter {
    
    private static final List<String> PUBLIC_PATHS = List.of("/login", "/", "/register");
    private static final List<String> STATIC_PREFIXES = List.of("/static/");
    
    private final Map<String, Set<String>> roleRules = Map.of(
        "/admin/", Set.of("admin"),
        "/moderator/", Set.of("admin", "moderator"),
        "/student/", Set.of("admin", "moderator", "student")
    );
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        // 1. Allow public paths
        // 2. Check authentication
        // 3. Check authorization based on path
        // 4. Special handling for subject coordinators
    }
}
```

### URL Protection (web.xml)

```xml
<filter>
    <filter-name>AuthFilter</filter-name>
    <filter-class>com.uninest.security.AuthFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>AuthFilter</filter-name>
    <url-pattern>/admin/*</url-pattern>
</filter-mapping>

<filter-mapping>
    <filter-name>AuthFilter</filter-name>
    <url-pattern>/moderator/*</url-pattern>
</filter-mapping>

<filter-mapping>
    <filter-name>AuthFilter</filter-name>
    <url-pattern>/student/*</url-pattern>
</filter-mapping>
```

### Protected Path Matrix

| Path Pattern | Required Role(s) |
|--------------|-----------------|
| `/login`, `/register`, `/` | Public |
| `/static/*` | Public |
| `/admin/*` | admin |
| `/moderator/*` | admin, moderator |
| `/student/*` | admin, moderator, student |
| `/subject-coordinator/*` | Subject coordinator (table check) |

---

## SQL Injection Prevention

All database queries use PreparedStatements with parameterized queries:

```java
// SAFE - Using PreparedStatement
String sql = "SELECT * FROM users WHERE email = ?";
try (PreparedStatement ps = con.prepareStatement(sql)) {
    ps.setString(1, email);
    ResultSet rs = ps.executeQuery();
}

// UNSAFE - Never do this!
// String sql = "SELECT * FROM users WHERE email = '" + email + "'";
```

**Best Practices Followed:**
- Never concatenate user input into SQL
- Use parameterized queries for all operations
- Validate input types before processing

---

## Password Reset Security

### Token Generation

```java
public String createResetToken(int userId, long ttlMinutes) {
    // Generate random UUID (32 hex characters)
    String token = UUID.randomUUID().toString().replaceAll("-", "");
    
    // Store with expiration
    String sql = "INSERT INTO password_reset_tokens(token, user_id, expires_at) " +
                 "VALUES(?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))";
    // ...
    return token;
}
```

### Token Validation

```java
public Optional<Integer> validateResetToken(String token) {
    String sql = "SELECT user_id FROM password_reset_tokens " +
                 "WHERE token = ? AND used = 0 AND expires_at > NOW()";
    // Returns user_id only if token is valid and not expired
}

public void markTokenUsed(String token) {
    String sql = "UPDATE password_reset_tokens SET used = 1 WHERE token = ?";
    // Prevents token reuse
}
```

**Security Measures:**
- Tokens are random UUIDs (unguessable)
- Tokens expire after configured time
- Tokens can only be used once
- Tokens are tied to specific user

---

## Community Isolation

Moderators can only access their own community's data:

```java
// Get moderator's community ID from session
Integer communityId = user.getCommunityId();

// Only query data for their community
List<JoinRequest> requests = joinRequestDAO.findByCommunityId(communityId);
List<User> students = userDAO.findByCommunityId(communityId);
```

**Security Checks:**
- Validate community ownership before operations
- Filter all queries by community ID
- Prevent cross-community data access

---

## Resource Access Control

### Resource Visibility

```java
// Only approved, public resources are visible
String sql = "SELECT * FROM resources " +
             "WHERE topic_id = ? AND status = 'approved' AND visibility = 'public'";
```

### Resource Ownership

```java
// Only owner can edit/delete
if (resource.getUploadedBy() != user.getId()) {
    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
    return;
}
```

### Coordinator Authorization

```java
// Verify coordinator has access to this subject
if (!coordinatorDAO.isCoordinatorForSubject(user.getId(), subjectId)) {
    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
    return;
}
```

---

## Input Validation

### Server-Side Validation

```java
// Null/empty checks
if (email == null || email.isEmpty()) {
    req.setAttribute("error", "Email is required");
    return;
}

// Type conversion with error handling
try {
    int id = Integer.parseInt(req.getParameter("id"));
} catch (NumberFormatException e) {
    resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
    return;
}
```

### Form Validation

```html
<!-- Client-side validation (not relied upon) -->
<input type="email" name="email" required>
<input type="password" name="password" minlength="8" required>
```

---

## XSS Prevention

### JSTL Output Escaping

JSTL's `${...}` syntax automatically escapes HTML by default:

```jsp
<!-- Safe - automatically escaped -->
<p>${user.name}</p>

<!-- For explicit escaping -->
<c:out value="${user.name}" escapeXml="true"/>
```

### Content Security

- User content is stored as-is but escaped on display
- File uploads are served with proper Content-Type headers
- No inline JavaScript execution of user data

---

## Session Security

### Session Configuration

Sessions should be configured in `web.xml` for production:

```xml
<session-config>
    <session-timeout>30</session-timeout>
    <cookie-config>
        <http-only>true</http-only>
        <secure>true</secure>
    </cookie-config>
</session-config>
```

### Session Invalidation

```java
// On logout
HttpSession session = req.getSession(false);
if (session != null) {
    session.invalidate();
}
resp.sendRedirect(ctx + "/login");
```

---

## Database Connection Security

### Environment Variables

Sensitive configuration is stored in environment variables:

```java
private static final String HOST = Env.get("DB_HOST");
private static final String USER = Env.get("DB_USER");
private static final String PASS = Env.get("DB_PASS");
```

### SSL/TLS for Database

```java
private static final String URL = String.format(
    "jdbc:mysql://%s:%s/%s?sslMode=%s&serverTimezone=UTC",
    HOST, PORT, DB, SSL_MODE
);
```

---

## Security Checklist

### Authentication ✓
- [x] BCrypt password hashing
- [x] Session-based authentication
- [x] Password reset with expiring tokens
- [x] Single-use reset tokens

### Authorization ✓
- [x] Role-based access control
- [x] Path-based filtering
- [x] Community isolation
- [x] Resource ownership checks

### Data Protection ✓
- [x] Prepared statements (SQL injection prevention)
- [x] HTML escaping (XSS prevention)
- [x] Input validation
- [x] SSL for database connections

### Session Security ✓
- [x] HTTP-only cookies
- [x] Session timeout
- [x] Proper session invalidation

---

## Security Recommendations

### For Production Deployment

1. **Enable HTTPS**: Configure SSL/TLS for all connections
2. **Set Secure Cookies**: Enable `Secure` flag on session cookies
3. **Implement CSRF Protection**: Add CSRF tokens to forms
4. **Rate Limiting**: Implement login attempt limiting
5. **Audit Logging**: Log security-relevant events
6. **Content Security Policy**: Add CSP headers
7. **Regular Updates**: Keep dependencies updated

### Code Review Checklist

- [ ] All SQL uses PreparedStatements
- [ ] User input is validated before use
- [ ] Authorization checked before sensitive operations
- [ ] Sensitive data not logged or exposed
- [ ] Error messages don't reveal internal details
