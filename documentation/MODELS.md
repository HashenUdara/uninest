# Models Documentation

## Overview

Models in UniNest are Plain Old Java Objects (POJOs) that represent the domain entities. They are located in the `com.uninest.model` package.

## Model Classes

### 1. User

**File:** `com/uninest/model/User.java`

Represents a system user (admin, moderator, or student).

```java
public class User {
    private int id;
    private String email;
    private String name;
    private String passwordHash;
    private String roleName;
    private Integer communityId;
    private String communityName;
    private Integer academicYear;
    private Integer universityId;
    private String universityName;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Unique user identifier |
| email | String | User's email address (unique) |
| name | String | User's full name |
| passwordHash | String | BCrypt hashed password |
| roleName | String | Role name (student, moderator, admin) |
| communityId | Integer | Assigned community (nullable) |
| communityName | String | Community title (display only) |
| academicYear | Integer | Academic year 1-4 (nullable) |
| universityId | Integer | University reference (nullable) |
| universityName | String | University name (display only) |

**Key Methods:**
```java
// Role checking
public boolean isStudent();      // Returns true if role is "student"
public boolean isModerator();    // Returns true if role is "moderator"
public boolean isAdmin();        // Returns true if role is "admin"
public boolean hasRole(String r); // Generic role check

// Note: Subject coordinator is NOT a role
@Deprecated
public boolean isSubjectCoordinator(); // Always returns false
// Use SubjectCoordinatorDAO.isCoordinator(userId) instead
```

---

### 2. Role

**File:** `com/uninest/model/Role.java`

Represents a user role with optional inheritance.

```java
public class Role {
    private int id;
    private String name;
    private String description;
    private Integer inheritsFrom;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Unique role identifier |
| name | String | Role name (student, moderator, admin) |
| description | String | Role description |
| inheritsFrom | Integer | Parent role ID for inheritance (nullable) |

**Default Roles:**
- **student** (id=1): Basic privileges
- **moderator** (id=2): Inherits from student, can manage communities
- **admin** (id=3): Inherits from student, full system access

---

### 3. Community

**File:** `com/uninest/model/Community.java`

Represents an academic community.

```java
public class Community {
    private int id;
    private String title;
    private String description;
    private int createdByUserId;
    private String status;
    private boolean approved;
    private Timestamp approvedAt;
    private Integer approvedByUserId;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Unique community identifier |
| title | String | Community name |
| description | String | Community description |
| createdByUserId | int | Creator's user ID (moderator) |
| status | String | Status: pending, approved, rejected |
| approved | boolean | Approval flag |
| approvedAt | Timestamp | When approved |
| approvedByUserId | Integer | Admin who approved (nullable) |

---

### 4. Subject

**File:** `com/uninest/model/Subject.java`

Represents a course/subject within a community.

```java
public class Subject {
    private int subjectId;
    private int communityId;
    private String name;
    private String description;
    private String code;
    private int academicYear;
    private int semester;
    private String status;
    private Timestamp createdAt;
}
```

| Property | Type | Description |
|----------|------|-------------|
| subjectId | int | Unique subject identifier |
| communityId | int | Parent community ID |
| name | String | Subject name (e.g., "Data Structures") |
| description | String | Subject description |
| code | String | Subject code (e.g., "CS204") |
| academicYear | int | Target academic year (1-4) |
| semester | int | Semester number (1-2) |
| status | String | Status: upcoming, ongoing, completed |
| createdAt | Timestamp | Creation timestamp |

---

### 5. Topic

**File:** `com/uninest/model/Topic.java`

Represents a learning unit within a subject.

```java
public class Topic {
    private int topicId;
    private int subjectId;
    private String title;
    private String description;
    private Timestamp createdAt;
    private BigDecimal progressPercent;
}
```

| Property | Type | Description |
|----------|------|-------------|
| topicId | int | Unique topic identifier |
| subjectId | int | Parent subject ID |
| title | String | Topic title |
| description | String | Topic description |
| createdAt | Timestamp | Creation timestamp |
| progressPercent | BigDecimal | User's progress (calculated field) |

---

### 6. Resource

**File:** `com/uninest/model/Resource.java`

Represents an educational material/file.

```java
public class Resource {
    private int resourceId;
    private int topicId;
    private int uploadedBy;
    private int categoryId;
    private String title;
    private String description;
    private String fileUrl;
    private String fileType;
    private Timestamp uploadDate;
    private String status;
    private String visibility;
    private Integer approvedBy;
    private Timestamp approvalDate;
    private Integer parentResourceId;
    private int version;
    private String editType;
    
    // Display fields (joined from other tables)
    private String uploaderName;
    private String uploaderEmail;
    private String topicName;
    private String subjectName;
    private String subjectCode;
    private String categoryName;
    private String approverName;
}
```

| Property | Type | Description |
|----------|------|-------------|
| resourceId | int | Unique resource identifier |
| topicId | int | Parent topic ID |
| uploadedBy | int | Uploader's user ID |
| categoryId | int | Category ID |
| title | String | Resource title |
| description | String | Resource description |
| fileUrl | String | File storage path |
| fileType | String | MIME type |
| uploadDate | Timestamp | Upload timestamp |
| status | String | pending/approved/rejected/pending_edit/replaced |
| visibility | String | private/public |
| approvedBy | Integer | Approver's user ID (nullable) |
| approvalDate | Timestamp | Approval timestamp (nullable) |
| parentResourceId | Integer | For versioning (nullable) |
| version | int | Version number |
| editType | String | new/edit |

---

### 7. ResourceCategory

**File:** `com/uninest/model/ResourceCategory.java`

Represents a category for resources.

```java
public class ResourceCategory {
    private int categoryId;
    private String categoryName;
    private String description;
}
```

| Property | Type | Description |
|----------|------|-------------|
| categoryId | int | Unique category identifier |
| categoryName | String | Category name |
| description | String | Category description |

---

### 8. JoinRequest

**File:** `com/uninest/model/JoinRequest.java`

Represents a student's request to join a community.

```java
public class JoinRequest {
    private int id;
    private int userId;
    private String userName;
    private String userEmail;
    private Integer userAcademicYear;
    private String universityName;
    private int communityId;
    private String communityTitle;
    private String status;
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private Integer processedByUserId;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Unique request identifier |
| userId | int | Requesting user's ID |
| userName | String | User's name (joined) |
| userEmail | String | User's email (joined) |
| userAcademicYear | Integer | User's academic year |
| universityName | String | User's university name |
| communityId | int | Target community ID |
| communityTitle | String | Community name (joined) |
| status | String | pending/approved/rejected |
| requestedAt | Timestamp | Request timestamp |
| processedAt | Timestamp | Processing timestamp (nullable) |
| processedByUserId | Integer | Processor's user ID (nullable) |

---

### 9. SubjectCoordinator

**File:** `com/uninest/model/SubjectCoordinator.java`

Represents a student assigned as subject coordinator.

```java
public class SubjectCoordinator {
    private int coordinatorId;
    private int userId;
    private int subjectId;
    private Timestamp assignedAt;
    
    // Display fields (joined from other tables)
    private String userName;
    private String userEmail;
    private String subjectName;
    private String subjectCode;
    private Integer academicYear;
    private String universityName;
}
```

| Property | Type | Description |
|----------|------|-------------|
| coordinatorId | int | Unique coordinator record ID |
| userId | int | Student's user ID |
| subjectId | int | Assigned subject ID |
| assignedAt | Timestamp | Assignment timestamp |
| userName | String | Student's name (joined) |
| userEmail | String | Student's email (joined) |
| subjectName | String | Subject name (joined) |
| subjectCode | String | Subject code (joined) |
| academicYear | Integer | Student's academic year |
| universityName | String | Student's university |

---

### 10. TopicProgress

**File:** `com/uninest/model/TopicProgress.java`

Tracks a student's learning progress for a topic.

```java
public class TopicProgress {
    private int progressId;
    private int topicId;
    private int userId;
    private BigDecimal progressPercent;
    private Timestamp lastAccessed;
}
```

| Property | Type | Description |
|----------|------|-------------|
| progressId | int | Unique progress record ID |
| topicId | int | Topic ID |
| userId | int | Student's user ID |
| progressPercent | BigDecimal | Progress 0-100% |
| lastAccessed | Timestamp | Last access timestamp |

---

### 11. University

**File:** `com/uninest/model/University.java`

Represents a university.

```java
public class University {
    private int id;
    private String name;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Unique university identifier |
| name | String | University name |

---

### 12. Student

**File:** `com/uninest/model/Student.java`

A simplified student view model.

```java
public class Student {
    private int id;
    private String name;
    private String email;
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | int | Student's user ID |
| name | String | Student's name |
| email | String | Student's email |

---

## Model Relationships Diagram

```
              ┌──────────┐
              │   Role   │
              └────┬─────┘
                   │
                   │ roleName
                   ▼
┌──────────┐     ┌──────────────────────┐     ┌──────────────┐
│University│◄────│         User         │────►│  Community   │
└──────────┘     └──────────────────────┘     └──────────────┘
                           │                         │
                           │                         │
              ┌────────────┼────────────┐           │
              │            │            │           │
              ▼            ▼            ▼           ▼
       ┌────────────┐  ┌────────────┐  ┌────────────────┐
       │JoinRequest │  │   Topic    │  │    Subject     │
       │            │  │  Progress  │  │                │
       └────────────┘  └────────────┘  └────────┬───────┘
                                                │
                                                ▼
                             ┌────────────────────────────────┐
                             │             Topic              │
                             └─────────────────┬──────────────┘
                                               │
                        ┌──────────────────────┼──────────────────────┐
                        │                      │                      │
                        ▼                      ▼                      ▼
              ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
              │SubjectCoordinator│    │    Resource     │    │  TopicProgress  │
              └─────────────────┘    └────────┬────────┘    └─────────────────┘
                                              │
                                              ▼
                                    ┌─────────────────┐
                                    │ResourceCategory │
                                    └─────────────────┘
```

## Usage Examples

### Creating a User
```java
User user = new User();
user.setEmail("student@example.com");
user.setName("John Doe");
user.setPasswordHash(BCrypt.hashpw("password", BCrypt.gensalt()));
user.setRole("student");
user.setAcademicYear(2);
user.setUniversityId(1);
```

### Checking User Role
```java
User user = session.getAttribute("authUser");
if (user.isAdmin()) {
    // Admin-specific logic
} else if (user.isModerator()) {
    // Moderator-specific logic
} else if (user.isStudent()) {
    // Student-specific logic
}
```

### Creating a Resource
```java
Resource resource = new Resource();
resource.setTopicId(1);
resource.setUploadedBy(userId);
resource.setCategoryId(1);
resource.setTitle("Lecture Notes - Week 1");
resource.setDescription("Introduction to data structures");
resource.setFileUrl("/uploads/resources/file.pdf");
resource.setFileType("application/pdf");
resource.setStatus("pending");
resource.setVisibility("private");
resource.setVersion(1);
resource.setEditType("new");
```
