# User Roles and Permissions

## Overview

UniNest implements a role-based access control (RBAC) system with three main roles and one special privilege. Roles are stored in the `roles` table and assigned to users via the `role_id` foreign key.

## Role Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                           ADMIN                                  │
│         Full system access, manages all entities                 │
├─────────────────────────────────────────────────────────────────┤
│                         MODERATOR                                │
│      Community management, inherits student access               │
├─────────────────────────────────────────────────────────────────┤
│                          STUDENT                                 │
│          Base access for learning features                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                  SUBJECT COORDINATOR                             │
│    Special privilege (not a role) for resource approval          │
│    Granted to students via subject_coordinators table            │
└─────────────────────────────────────────────────────────────────┘
```

## Roles

### 1. Student (role_id = 1)

The base user role for learners.

**Permissions:**
- View available communities
- Submit join requests to communities
- Browse subjects in their community
- Browse topics within subjects
- View approved resources
- Upload resources (pending approval)
- Edit own resources
- Delete own resources
- Track learning progress
- View own profile

**Path Access:** `/student/*`

**Dashboard Features:**
- Community information
- Subject list (filtered by academic year)
- Learning progress overview
- My Resources management
- Profile settings

### 2. Moderator (role_id = 2)

Community managers who oversee a specific community.

**Inherits From:** Student

**Permissions:**
- All student permissions
- Create community (one per moderator)
- Manage community details
- View and manage join requests
- Approve/reject student requests
- Remove students from community
- Create, edit, delete subjects
- Create, edit, delete topics
- Assign subject coordinators
- View community statistics

**Path Access:** `/moderator/*`

**Dashboard Features:**
- Community overview and statistics
- Join request management
- Student management
- Subject management
- Topic management
- Subject coordinator management
- Profile settings

**Special Flows:**
1. **New Moderator**: Must create a community first
2. **Pending Community**: Waits for admin approval
3. **Approved Community**: Full access to dashboard

### 3. Admin (role_id = 3)

System administrators with full access.

**Inherits From:** Student

**Permissions:**
- All student permissions
- View all users
- Create, edit, delete students
- Create, edit, delete moderators
- View all communities
- Create, edit, delete communities
- Approve/reject communities
- Access system statistics
- Override any restrictions

**Path Access:** `/admin/*`

**Dashboard Features:**
- System-wide statistics
- User management (students & moderators)
- Community management
- Profile settings

---

## Subject Coordinator (Special Privilege)

Subject coordinators are **students with additional privileges** for specific subjects. This is NOT a role but a special assignment tracked in the `subject_coordinators` table.

**Important:** A student can only be a coordinator for ONE subject at a time (enforced by UNIQUE constraint on `user_id`).

**How It Works:**
1. Moderator assigns a student as coordinator for a subject
2. Entry is created in `subject_coordinators` table
3. Student gains access to `/subject-coordinator/*` paths
4. Can approve/reject resources for their assigned subject

**Permissions:**
- All student permissions
- View pending resources for assigned subject
- Approve pending resources
- Reject pending resources
- View resource details before approval

**Path Access:** `/subject-coordinator/*`

**Checking Coordinator Status:**
```java
// In AuthFilter
SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
if (coordinatorDAO.isCoordinator(userId)) {
    // User is a subject coordinator
}

// For specific subject
if (coordinatorDAO.isCoordinatorForSubject(userId, subjectId)) {
    // User is coordinator for this subject
}
```

---

## Permission Matrix

| Action | Student | Moderator | Admin | Coordinator |
|--------|---------|-----------|-------|-------------|
| View login page | ✓ | ✓ | ✓ | ✓ |
| Register account | ✓ | - | - | - |
| View own dashboard | ✓ | ✓ | ✓ | ✓ |
| View subjects | ✓ | ✓ | ✓ | ✓ |
| View topics | ✓ | ✓ | ✓ | ✓ |
| View resources | ✓ | ✓ | ✓ | ✓ |
| Upload resources | ✓ | ✓ | ✓ | ✓ |
| Edit own resources | ✓ | ✓ | ✓ | ✓ |
| Delete own resources | ✓ | ✓ | ✓ | ✓ |
| Track progress | ✓ | ✓ | ✓ | ✓ |
| Create community | - | ✓ | ✓ | - |
| Manage join requests | - | ✓ | ✓ | - |
| Manage students | - | ✓ | ✓ | - |
| Manage subjects | - | ✓ | ✓ | - |
| Manage topics | - | ✓ | ✓ | - |
| Assign coordinators | - | ✓ | ✓ | - |
| Approve resources | - | - | - | ✓ |
| Reject resources | - | - | - | ✓ |
| View all users | - | - | ✓ | - |
| Manage moderators | - | - | ✓ | - |
| Approve communities | - | - | ✓ | - |
| Delete communities | - | - | ✓ | - |

---

## Role Checking in Code

### Servlet Pattern

```java
@WebServlet("/moderator/dashboard")
public class ModeratorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");
        
        // AuthFilter already handles this, but for safety:
        if (user == null || !user.isModerator()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Process request
    }
}
```

### JSP Pattern

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${authUser.admin}">
    <a href="${ctx}/admin/dashboard">Admin Panel</a>
</c:if>

<c:if test="${authUser.moderator}">
    <a href="${ctx}/moderator/dashboard">Moderator Panel</a>
</c:if>

<c:choose>
    <c:when test="${authUser.student}">
        <span>Student View</span>
    </c:when>
</c:choose>
```

### AuthFilter Implementation

```java
public class AuthFilter implements Filter {
    
    private final Map<String, Set<String>> roleRules = Map.of(
        "/admin/", Set.of("admin"),
        "/moderator/", Set.of("admin", "moderator"),
        "/student/", Set.of("admin", "moderator", "student")
    );
    
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // Get user from session
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");
        
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        // Special handling for subject coordinator paths
        if (path.startsWith("/subject-coordinator/")) {
            if (user.hasRole("admin")) {
                chain.doFilter(request, response);
                return;
            }
            if (!coordinatorDAO.isCoordinator(user.getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            chain.doFilter(request, response);
            return;
        }
        
        // Check role rules for other paths
        for (Map.Entry<String, Set<String>> entry : roleRules.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                if (entry.getValue().stream().noneMatch(user::hasRole)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            }
        }
        
        chain.doFilter(request, response);
    }
}
```

---

## Role Assignment

### During Registration

Students are automatically assigned the `student` role:

```java
User newUser = new User();
newUser.setEmail(email);
newUser.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
newUser.setRole("student");  // Always student for registration
userDAO.create(newUser);
```

### Creating Moderators (Admin Only)

```java
User moderator = new User();
moderator.setEmail(email);
moderator.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
moderator.setRole("moderator");
userDAO.create(moderator);
```

### Assigning Subject Coordinators

```java
SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

// Assign student (userId) as coordinator for subject (subjectId)
coordinatorDAO.assign(userId, subjectId);

// Check if user is a coordinator
boolean isCoordinator = coordinatorDAO.isCoordinator(userId);

// Unassign coordinator
coordinatorDAO.unassign(coordinatorId);
```

---

## Community-Based Access

In addition to role-based access, many features are scoped to the user's community:

### Moderator Community Isolation
- Moderators can only see students in their community
- Moderators can only manage subjects/topics in their community
- Join requests are scoped to their community

### Student Community Access
- Students can only view subjects in their community
- Students can only view topics in their community
- Resources are scoped to community through subject hierarchy

### Code Example
```java
// Get moderator's community
Integer communityId = user.getCommunityId();
if (communityId == null) {
    resp.sendRedirect(ctx + "/moderator/community/create");
    return;
}

// Only show students in this community
List<User> students = userDAO.findByCommunityId(communityId);
```

---

## Default Test Users

| Role | Email | Password | Community |
|------|-------|----------|-----------|
| Admin | a1@abc.com | password123 | None |
| Moderator | m1@abc.com | password123 | Community 1 |
| Moderator | m2@abc.com | password123 | Community 1 |
| Student | s1@abc.com | password123 | Community 1 |
| Student | s2@abc.com | password123 | Community 1 |

(100 students and 20 moderators are seeded by default)
