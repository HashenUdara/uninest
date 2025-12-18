# Controllers Documentation

## Overview

Controllers in UniNest are implemented as Java Servlets that handle HTTP requests. They follow the Jakarta Servlet 6.0 specification and are located in the `com.uninest.controller` package.

## Controller Organization

```
com.uninest.controller/
├── admin/                    # Admin management
├── api/                      # REST-like API endpoints
├── auth/                     # Authentication
├── moderator/                # Moderator functionality
├── student/                  # Student functionality
├── students/                 # Student CRUD (admin)
├── subjectcoordinator/       # Subject coordinator
├── DebugUserServlet.java     # Debug utility
├── DemoServlet.java          # Demo servlet
└── FileServlet.java          # File handling
```

---

## Authentication Controllers

### LoginServlet
**URL Pattern:** `/login`  
**File:** `auth/LoginServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display login form |
| POST | Process login, validate credentials, create session |

**Login Flow:**
1. Validate email and password parameters
2. Find user by email using UserDAO
3. Verify password with BCrypt
4. Create session with authUser attribute
5. Redirect based on role:
   - Admin → `/admin/dashboard`
   - Moderator (no community) → `/moderator/community/create`
   - Moderator (pending community) → `/moderator/community/waiting`
   - Moderator (approved) → `/moderator/dashboard`
   - Student (no community) → `/student/join-community`
   - Student (approved) → `/student/dashboard`

### LogoutServlet
**URL Pattern:** `/logout`  
**File:** `auth/LogoutServlet.java`

| Method | Description |
|--------|-------------|
| GET | Invalidate session and redirect to login |
| POST | Same as GET |

### SignUpServlet
**URL Pattern:** `/register`  
**File:** `auth/SignUpServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display registration form |
| POST | Create new student account |

### ForgotPasswordRequestServlet
**URL Pattern:** `/forgot-password`  
**File:** `auth/ForgotPasswordRequestServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display forgot password form |
| POST | Generate reset token and send email |

### ResetPasswordServlet
**URL Pattern:** `/reset-password`  
**File:** `auth/ResetPasswordServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display reset password form with token |
| POST | Validate token and update password |

---

## Admin Controllers

### AdminDashboardServlet
**URL Pattern:** `/admin/dashboard`  
**File:** `admin/AdminDashboardServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display admin dashboard with statistics |

### StudentsServlet (Admin)
**URL Pattern:** `/admin/students`  
**File:** `admin/StudentsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List all students with search/filter |

### AddStudentServlet (Admin)
**URL Pattern:** `/admin/students/add`  
**File:** `admin/AddStudentServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display add student form |
| POST | Create new student account |

### EditStudentServlet
**URL Pattern:** `/admin/students/edit`  
**File:** `admin/EditStudentServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit student form |
| POST | Update student information |

### DeleteStudentServlet
**URL Pattern:** `/admin/students/delete`  
**File:** `admin/DeleteStudentServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete student account |

### ModeratorsServlet
**URL Pattern:** `/admin/moderators`  
**File:** `admin/ModeratorsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List all moderators |

### AddModeratorServlet
**URL Pattern:** `/admin/moderators/add`  
**File:** `admin/AddModeratorServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display add moderator form |
| POST | Create new moderator account |

### EditModeratorServlet
**URL Pattern:** `/admin/moderators/edit`  
**File:** `admin/EditModeratorServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit moderator form |
| POST | Update moderator information |

### DeleteModeratorServlet
**URL Pattern:** `/admin/moderators/delete`  
**File:** `admin/DeleteModeratorServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete moderator account |

### CommunitiesServlet
**URL Pattern:** `/admin/communities`  
**File:** `admin/CommunitiesServlet.java`

| Method | Description |
|--------|-------------|
| GET | List all communities with filters |

### CommunityCreateServlet (Admin)
**URL Pattern:** `/admin/communities/create`  
**File:** `admin/CommunityCreateServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display create community form |
| POST | Create new community |

### CommunityEditServlet
**URL Pattern:** `/admin/communities/edit`  
**File:** `admin/CommunityEditServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit community form |
| POST | Update community information |

### ApproveCommunityServlet
**URL Pattern:** `/admin/communities/approve`  
**File:** `admin/ApproveCommunityServlet.java`

| Method | Description |
|--------|-------------|
| POST | Approve pending community |

### RejectCommunityServlet
**URL Pattern:** `/admin/communities/reject`  
**File:** `admin/RejectCommunityServlet.java`

| Method | Description |
|--------|-------------|
| POST | Reject pending community |

### DeleteCommunityServlet
**URL Pattern:** `/admin/communities/delete`  
**File:** `admin/DeleteCommunityServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete community |

---

## Moderator Controllers

### ModeratorDashboardServlet
**URL Pattern:** `/moderator/dashboard`  
**File:** `moderator/ModeratorDashboardServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display moderator dashboard |

### CommunityCreateServlet (Moderator)
**URL Pattern:** `/moderator/community/create`  
**File:** `moderator/CommunityCreateServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display create community form |
| POST | Create community for moderator |

### CommunityWaitingServlet
**URL Pattern:** `/moderator/community/waiting`  
**File:** `moderator/CommunityWaitingServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display waiting for approval page |

### JoinRequestsServlet
**URL Pattern:** `/moderator/join-requests`  
**File:** `moderator/JoinRequestsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List pending join requests for community |

### ApproveJoinRequestServlet
**URL Pattern:** `/moderator/join-requests/approve`  
**File:** `moderator/ApproveJoinRequestServlet.java`

| Method | Description |
|--------|-------------|
| POST | Approve student join request |

### RejectJoinRequestServlet
**URL Pattern:** `/moderator/join-requests/reject`  
**File:** `moderator/RejectJoinRequestServlet.java`

| Method | Description |
|--------|-------------|
| POST | Reject student join request |

### ModeratorStudentsServlet
**URL Pattern:** `/moderator/students`  
**File:** `moderator/ModeratorStudentsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List students in moderator's community |

### RemoveStudentServlet
**URL Pattern:** `/moderator/students/remove`  
**File:** `moderator/RemoveStudentServlet.java`

| Method | Description |
|--------|-------------|
| POST | Remove student from community |

### ModeratorSubjectsServlet
**URL Pattern:** `/moderator/subjects`  
**File:** `moderator/ModeratorSubjectsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List subjects in community |

### SubjectCreateServlet
**URL Pattern:** `/moderator/subjects/create`  
**File:** `moderator/SubjectCreateServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display create subject form |
| POST | Create new subject |

### SubjectEditServlet
**URL Pattern:** `/moderator/subjects/edit`  
**File:** `moderator/SubjectEditServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit subject form |
| POST | Update subject information |

### SubjectDeleteServlet
**URL Pattern:** `/moderator/subjects/delete`  
**File:** `moderator/SubjectDeleteServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete subject |

### ModeratorTopicsServlet
**URL Pattern:** `/moderator/topics`  
**File:** `moderator/ModeratorTopicsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List topics for a subject |

### TopicCreateServlet
**URL Pattern:** `/moderator/topics/create`  
**File:** `moderator/TopicCreateServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display create topic form |
| POST | Create new topic |

### TopicEditServlet
**URL Pattern:** `/moderator/topics/edit`  
**File:** `moderator/TopicEditServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit topic form |
| POST | Update topic information |

### TopicDeleteServlet
**URL Pattern:** `/moderator/topics/delete`  
**File:** `moderator/TopicDeleteServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete topic |

### SubjectCoordinatorsServlet
**URL Pattern:** `/moderator/subject-coordinators`  
**File:** `moderator/SubjectCoordinatorsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List subject coordinators |

### AllCoordinatorsServlet
**URL Pattern:** `/moderator/coordinators/all`  
**File:** `moderator/AllCoordinatorsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List all coordinators in community |

### SelectSubjectForCoordinatorServlet
**URL Pattern:** `/moderator/coordinators/select-subject`  
**File:** `moderator/SelectSubjectForCoordinatorServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display subject selection for coordinator |

### AssignCoordinatorServlet
**URL Pattern:** `/moderator/coordinators/assign`  
**File:** `moderator/AssignCoordinatorServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display assign coordinator form |
| POST | Assign student as subject coordinator |

### EditCoordinatorServlet
**URL Pattern:** `/moderator/coordinators/edit`  
**File:** `moderator/EditCoordinatorServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit coordinator form |
| POST | Update coordinator assignment |

### UnassignCoordinatorServlet
**URL Pattern:** `/moderator/coordinators/unassign`  
**File:** `moderator/UnassignCoordinatorServlet.java`

| Method | Description |
|--------|-------------|
| POST | Remove coordinator assignment |

---

## Student Controllers

### StudentDashboardServlet
**URL Pattern:** `/student/dashboard`  
**File:** `student/StudentDashboardServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display student dashboard |

### JoinCommunityServlet
**URL Pattern:** `/student/join-community`  
**File:** `student/JoinCommunityServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display join community form |
| POST | Submit join request |

### CancelJoinRequestServlet
**URL Pattern:** `/student/join-request/cancel`  
**File:** `student/CancelJoinRequestServlet.java`

| Method | Description |
|--------|-------------|
| POST | Cancel pending join request |

### StudentSubjectsServlet
**URL Pattern:** `/student/subjects`  
**File:** `student/StudentSubjectsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List subjects for student's academic year |

### StudentTopicsServlet
**URL Pattern:** `/student/topics`  
**File:** `student/StudentTopicsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List topics for a subject |

### StudentResourcesServlet
**URL Pattern:** `/student/resources`  
**File:** `student/StudentResourcesServlet.java`

| Method | Description |
|--------|-------------|
| GET | List resources for a topic |

### ResourceDetailServlet
**URL Pattern:** `/student/resource`  
**File:** `student/ResourceDetailServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display resource details |

### UploadResourceServlet
**URL Pattern:** `/student/resources/upload`  
**File:** `student/UploadResourceServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display upload resource form |
| POST | Upload new resource |

### EditResourceServlet
**URL Pattern:** `/student/resources/edit`  
**File:** `student/EditResourceServlet.java`

| Method | Description |
|--------|-------------|
| GET | Display edit resource form |
| POST | Submit resource edit |

### DeleteResourceServlet
**URL Pattern:** `/student/resources/delete`  
**File:** `student/DeleteResourceServlet.java`

| Method | Description |
|--------|-------------|
| POST | Delete resource |

---

## Subject Coordinator Controllers

### ResourceApprovalsServlet
**URL Pattern:** `/subject-coordinator/resource-approvals`  
**File:** `subjectcoordinator/ResourceApprovalsServlet.java`

| Method | Description |
|--------|-------------|
| GET | List pending resource approvals |

### ApproveResourceServlet
**URL Pattern:** `/subject-coordinator/resources/approve`  
**File:** `subjectcoordinator/ApproveResourceServlet.java`

| Method | Description |
|--------|-------------|
| POST | Approve pending resource |

### RejectResourceServlet
**URL Pattern:** `/subject-coordinator/resources/reject`  
**File:** `subjectcoordinator/RejectResourceServlet.java`

| Method | Description |
|--------|-------------|
| POST | Reject pending resource |

---

## API Controllers

### SubjectTopicsApiServlet
**URL Pattern:** `/api/subjects/{id}/topics`  
**File:** `api/SubjectTopicsApiServlet.java`

| Method | Description |
|--------|-------------|
| GET | Get topics for subject (JSON) |

---

## Utility Controllers

### FileServlet
**URL Pattern:** `/files/*`  
**File:** `FileServlet.java`

| Method | Description |
|--------|-------------|
| GET | Serve uploaded files |

---

## Common Patterns

### 1. Session Access
```java
HttpSession session = req.getSession(false);
User user = session == null ? null : (User) session.getAttribute("authUser");
```

### 2. Request Attribute Setting
```java
req.setAttribute("subjects", subjectDAO.findByCommunityId(communityId));
req.getRequestDispatcher("/WEB-INF/views/moderator/subjects-list.jsp").forward(req, resp);
```

### 3. Redirect After POST
```java
resp.sendRedirect(req.getContextPath() + "/admin/students?success=created");
```

### 4. Error Handling
```java
if (subject == null) {
    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    return;
}
```

### 5. Parameter Validation
```java
String idParam = req.getParameter("id");
if (idParam == null || idParam.isEmpty()) {
    req.setAttribute("error", "ID is required");
    req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
    return;
}
int id = Integer.parseInt(idParam);
```

---

## URL Pattern Summary

| Pattern | Role | Description |
|---------|------|-------------|
| `/login`, `/logout`, `/register` | Public | Authentication |
| `/forgot-password`, `/reset-password` | Public | Password reset |
| `/admin/*` | Admin | Administration |
| `/moderator/*` | Moderator | Community management |
| `/student/*` | Student | Learning features |
| `/subject-coordinator/*` | Coordinator | Resource approval |
| `/api/*` | Authenticated | REST endpoints |
| `/files/*` | Authenticated | File serving |
