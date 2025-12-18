# Data Access Layer Documentation

## Overview

The Data Access Object (DAO) pattern is used to abstract database operations from the business logic. All DAOs are located in the `com.uninest.model.dao` package.

## Database Connection

### DBConnection Class

**File:** `com/uninest/util/DBConnection.java`

Manages database connections using environment variables.

```java
public class DBConnection {
    // Configuration from environment variables
    private static final String HOST = Env.get("DB_HOST");
    private static final String PORT = Env.get("DB_PORT");
    private static final String DB = Env.get("DB_NAME");
    private static final String SSL_MODE = Env.get("DB_SSL_MODE");
    private static final String USER = Env.get("DB_USER");
    private static final String PASS = Env.get("DB_PASS");
    
    public static Connection getConnection() throws SQLException {
        // Returns a new database connection
    }
}
```

**Environment Variables Required:**
| Variable | Description | Example |
|----------|-------------|---------|
| DB_HOST | Database host | localhost |
| DB_PORT | Database port | 3306 |
| DB_NAME | Database name | uninest |
| DB_USER | Database username | root |
| DB_PASS | Database password | password |
| DB_SSL_MODE | SSL mode | REQUIRED |

---

## DAO Classes

### 1. UserDAO

**File:** `com/uninest/model/dao/UserDAO.java`

Manages user-related database operations.

**Key Methods:**

```java
// Find user by email (for login)
Optional<User> findByEmail(String email)

// Find user by ID
Optional<User> findById(int id)

// Create new user
void create(User user)

// Update user profile
void update(User user)

// Delete user
boolean deleteUser(int userId)

// Update password
boolean updatePassword(int userId, String newHash)

// Assign user to community
boolean assignCommunity(int userId, int communityId)

// Remove user from community
boolean removeCommunity(int userId)

// Find all users by role
List<User> findByRole(String roleName)

// Search users by role and term
List<User> searchUsers(String roleName, String searchTerm)

// Find users in a community
List<User> findByCommunityId(int communityId)

// Password reset token operations
String createResetToken(int userId, long ttlMinutes)
Optional<Integer> validateResetToken(String token)
void markTokenUsed(String token)
```

**Example Usage:**
```java
UserDAO userDAO = new UserDAO();

// Login
Optional<User> user = userDAO.findByEmail("student@example.com");
if (user.isPresent() && BCrypt.checkpw(password, user.get().getPasswordHash())) {
    // Login successful
}

// Create user
User newUser = new User();
newUser.setEmail("new@example.com");
newUser.setPasswordHash(BCrypt.hashpw("password", BCrypt.gensalt()));
newUser.setRole("student");
userDAO.create(newUser);
```

---

### 2. CommunityDAO

**File:** `com/uninest/model/dao/CommunityDAO.java`

Manages community-related database operations.

**Key Methods:**

```java
// Find community by ID
Optional<Community> findById(int id)

// Find all communities
List<Community> findAll()

// Find approved communities
List<Community> findApproved()

// Find pending communities (for admin)
List<Community> findPending()

// Create community
void create(Community community)

// Update community
void update(Community community)

// Delete community
boolean delete(int communityId)

// Approve community
boolean approve(int communityId, int approverId)

// Reject community
boolean reject(int communityId)
```

---

### 3. SubjectDAO

**File:** `com/uninest/model/dao/SubjectDAO.java`

Manages subject-related database operations.

**Key Methods:**

```java
// Find subject by ID
Optional<Subject> findById(int subjectId)

// Find subjects by community
List<Subject> findByCommunityId(int communityId)

// Find subjects for specific academic year
List<Subject> findByCommunityIdAndYear(int communityId, int academicYear)

// Create subject
int create(Subject subject)

// Update subject
boolean update(Subject subject)

// Delete subject
boolean delete(int subjectId)

// Update subject status
boolean updateStatus(int subjectId, String status)
```

---

### 4. TopicDAO

**File:** `com/uninest/model/dao/TopicDAO.java`

Manages topic-related database operations.

**Key Methods:**

```java
// Find topic by ID
Optional<Topic> findById(int topicId)

// Find topics by subject
List<Topic> findBySubjectId(int subjectId)

// Find topics with user progress
List<Topic> findBySubjectIdWithProgress(int subjectId, int userId)

// Create topic
int create(Topic topic)

// Update topic
boolean update(Topic topic)

// Delete topic
boolean delete(int topicId)
```

---

### 5. ResourceDAO

**File:** `com/uninest/model/dao/ResourceDAO.java`

Manages resource-related database operations.

**Key Methods:**

```java
// Find resource by ID
Optional<Resource> findById(int resourceId)

// Find resources by topic (approved only)
List<Resource> findByTopicId(int topicId)

// Find resources by topic and category
List<Resource> findByTopicIdAndCategory(int topicId, int categoryId)

// Find resources uploaded by user
List<Resource> findByUserId(int userId)

// Find pending resources for subjects
List<Resource> findPendingBySubjectIds(List<Integer> subjectIds)

// Find pending new uploads
List<Resource> findPendingNewUploadsBySubjectIds(List<Integer> subjectIds)

// Find pending edits
List<Resource> findPendingEditsBySubjectIds(List<Integer> subjectIds)

// Create resource
int create(Resource resource)

// Update resource
boolean update(Resource resource)

// Delete resource
boolean delete(int resourceId)

// Approve resource
boolean approve(int resourceId, int approverId)

// Reject resource
boolean reject(int resourceId, int approverId)

// Approve edit (with versioning)
boolean approveEdit(int resourceId, int approverId)

// Find parent resource (for versioning)
Optional<Resource> findParentResource(int resourceId)
```

---

### 6. ResourceCategoryDAO

**File:** `com/uninest/model/dao/ResourceCategoryDAO.java`

Manages resource category operations.

**Key Methods:**

```java
// Find category by ID
Optional<ResourceCategory> findById(int categoryId)

// Find all categories
List<ResourceCategory> findAll()
```

---

### 7. JoinRequestDAO

**File:** `com/uninest/model/dao/JoinRequestDAO.java`

Manages community join request operations.

**Key Methods:**

```java
// Find request by ID
Optional<JoinRequest> findById(int requestId)

// Find pending requests for community
List<JoinRequest> findPendingByCommunityId(int communityId)

// Find all requests for community
List<JoinRequest> findByCommunityId(int communityId)

// Find requests by user
List<JoinRequest> findByUserId(int userId)

// Check if user has pending request
boolean hasPendingRequest(int userId, int communityId)

// Create join request
int create(JoinRequest request)

// Approve request
boolean approve(int requestId, int processedByUserId)

// Reject request
boolean reject(int requestId, int processedByUserId)

// Cancel request (by student)
boolean cancel(int requestId, int userId)
```

---

### 8. SubjectCoordinatorDAO

**File:** `com/uninest/model/dao/SubjectCoordinatorDAO.java`

Manages subject coordinator assignments.

**Key Methods:**

```java
// Check if user is a coordinator
boolean isCoordinator(int userId)

// Check if user is coordinator for specific subject
boolean isCoordinatorForSubject(int userId, int subjectId)

// Get coordinator for subject
Optional<SubjectCoordinator> findBySubjectId(int subjectId)

// Get subjects coordinated by user
List<SubjectCoordinator> findByUserId(int userId)

// Get all coordinators for community
List<SubjectCoordinator> findByCommunityId(int communityId)

// Assign coordinator
int assign(int userId, int subjectId)

// Unassign coordinator
boolean unassign(int coordinatorId)

// Get subject IDs coordinated by user
List<Integer> getSubjectIdsByUserId(int userId)
```

---

### 9. TopicProgressDAO

**File:** `com/uninest/model/dao/TopicProgressDAO.java`

Manages student learning progress.

**Key Methods:**

```java
// Get progress for topic
Optional<TopicProgress> findByUserAndTopic(int userId, int topicId)

// Get all progress for user
List<TopicProgress> findByUserId(int userId)

// Update or create progress
boolean upsertProgress(int userId, int topicId, BigDecimal progressPercent)

// Get average progress for subject
BigDecimal getAverageProgressForSubject(int userId, int subjectId)
```

---

### 10. UniversityDAO

**File:** `com/uninest/model/dao/UniversityDAO.java`

Manages university data.

**Key Methods:**

```java
// Find university by ID
Optional<University> findById(int id)

// Find all universities
List<University> findAll()
```

---

## Common Patterns

### 1. Using PreparedStatements

All DAOs use PreparedStatements to prevent SQL injection:

```java
String sql = "SELECT * FROM users WHERE email = ?";
try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement(sql)) {
    ps.setString(1, email);
    try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return Optional.of(mapRow(rs));
        }
    }
}
```

### 2. Result Set Mapping

Each DAO has a private `map()` method to convert ResultSet rows to objects:

```java
private User map(ResultSet rs) throws SQLException {
    User u = new User(
        rs.getInt("id"),
        rs.getString("email"),
        rs.getString("password_hash"),
        rs.getString("role_name")
    );
    u.setName(rs.getString("name"));
    // ... more mappings
    return u;
}
```

### 3. Handling Nullable Columns

```java
int commId = rs.getInt("community_id");
u.setCommunityId(rs.wasNull() ? null : commId);
```

### 4. Transaction Management

For operations that require multiple statements:

```java
Connection con = null;
try {
    con = DBConnection.getConnection();
    con.setAutoCommit(false);
    
    // Execute multiple statements
    
    con.commit();
} catch (SQLException e) {
    if (con != null) {
        con.rollback();
    }
    throw new RuntimeException(e);
} finally {
    if (con != null) {
        con.setAutoCommit(true);
        con.close();
    }
}
```

### 5. Dynamic IN Clause

For queries with variable-length IN clauses:

```java
StringBuilder sql = new StringBuilder();
sql.append("SELECT * FROM resources WHERE subject_id IN (");
for (int i = 0; i < subjectIds.size(); i++) {
    sql.append("?");
    if (i < subjectIds.size() - 1) {
        sql.append(",");
    }
}
sql.append(")");

try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
    for (int i = 0; i < subjectIds.size(); i++) {
        ps.setInt(i + 1, subjectIds.get(i));
    }
    // Execute query
}
```

---

## Error Handling

All DAO methods wrap SQLException in RuntimeException:

```java
try {
    // Database operations
} catch (SQLException e) {
    throw new RuntimeException("Error fetching user", e);
}
```

This allows calling code to handle exceptions as unchecked exceptions while preserving the original cause.

---

## Best Practices

1. **Always use try-with-resources** for Connection, PreparedStatement, and ResultSet
2. **Use PreparedStatements** to prevent SQL injection
3. **Handle null values** properly using `rs.wasNull()`
4. **Close resources** in finally blocks or use try-with-resources
5. **Use transactions** for multiple related operations
6. **Keep DAO methods focused** on single operations
7. **Return Optional** for single-row queries that might not find results
8. **Return empty List** instead of null for multi-row queries
