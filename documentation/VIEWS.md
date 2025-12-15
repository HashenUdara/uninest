# Views Documentation

## Overview

UniNest uses JSP (JavaServer Pages) with JSTL (JavaServer Pages Standard Tag Library) for the view layer. Views are organized by user role and feature.

## View Structure

```
src/main/webapp/
├── index.jsp                    # Landing page
├── WEB-INF/
│   ├── views/
│   │   ├── admin/              # Admin views
│   │   ├── auth/               # Authentication views
│   │   ├── moderator/          # Moderator views
│   │   ├── student/            # Student views
│   │   ├── subject-coordinator/ # Coordinator views
│   │   ├── error.jsp           # Error page
│   │   ├── add-student.jsp     # Shared student form
│   │   ├── student-detail.jsp  # Shared student detail
│   │   └── students.jsp        # Shared students list
│   └── tags/
│       ├── dashboard/          # Dashboard components
│       └── layouts/            # Page layouts
└── static/
    ├── app.css                 # Main styles
    ├── app.js                  # Main scripts
    ├── auth.css                # Auth-specific styles
    ├── auth.js                 # Auth-specific scripts
    ├── community.css           # Community styles
    ├── dashboard.css           # Dashboard styles
    ├── dashboard.js            # Dashboard scripts
    ├── style.css               # Additional styles
    └── vendor/                 # Third-party libraries
```

---

## Authentication Views

### login.jsp
**Path:** `/WEB-INF/views/auth/login.jsp`

Login form with email and password fields.

**Request Attributes:**
- `error` (String): Error message to display

### signup.jsp
**Path:** `/WEB-INF/views/auth/signup.jsp`

Registration form for new students.

**Request Attributes:**
- `error` (String): Error message
- `universities` (List<University>): Available universities

### forgot-password.jsp
**Path:** `/WEB-INF/views/auth/forgot-password.jsp`

Email input form for password reset.

### forgot-password-requested.jsp
**Path:** `/WEB-INF/views/auth/forgot-password-requested.jsp`

Confirmation page after reset email sent.

### reset-password.jsp
**Path:** `/WEB-INF/views/auth/reset-password.jsp`

New password entry form with token validation.

---

## Admin Views

### dashboard.jsp
**Path:** `/WEB-INF/views/admin/dashboard.jsp`

Admin dashboard with statistics overview.

**Request Attributes:**
- `studentCount` (int): Total students
- `moderatorCount` (int): Total moderators
- `communityCount` (int): Total communities
- `pendingCommunities` (int): Pending approval count

### students.jsp
**Path:** `/WEB-INF/views/admin/students.jsp`

List of all students with search and pagination.

**Request Attributes:**
- `students` (List<User>): Student list
- `searchTerm` (String): Current search query
- `success` (String): Success message

### add-student.jsp
**Path:** `/WEB-INF/views/admin/add-student.jsp`

Form to add new student.

**Request Attributes:**
- `universities` (List<University>): Available universities
- `communities` (List<Community>): Available communities
- `error` (String): Error message

### edit-student.jsp
**Path:** `/WEB-INF/views/admin/edit-student.jsp`

Form to edit student information.

**Request Attributes:**
- `student` (User): Student to edit
- `universities` (List<University>)
- `communities` (List<Community>)

### moderators.jsp
**Path:** `/WEB-INF/views/admin/moderators.jsp`

List of all moderators.

**Request Attributes:**
- `moderators` (List<User>): Moderator list

### add-moderator.jsp
**Path:** `/WEB-INF/views/admin/add-moderator.jsp`

Form to add new moderator.

### edit-moderator.jsp
**Path:** `/WEB-INF/views/admin/edit-moderator.jsp`

Form to edit moderator information.

### communities.jsp
**Path:** `/WEB-INF/views/admin/communities.jsp`

List of all communities with status filters.

**Request Attributes:**
- `communities` (List<Community>): Community list
- `filter` (String): Current filter (pending/approved/rejected)

### community-create.jsp
**Path:** `/WEB-INF/views/admin/community-create.jsp`

Form to create new community.

### community-edit.jsp
**Path:** `/WEB-INF/views/admin/community-edit.jsp`

Form to edit community.

### profile-settings.jsp
**Path:** `/WEB-INF/views/admin/profile-settings.jsp`

Admin profile settings page.

---

## Moderator Views

### dashboard.jsp
**Path:** `/WEB-INF/views/moderator/dashboard.jsp`

Moderator dashboard showing community statistics.

**Request Attributes:**
- `community` (Community): Moderator's community
- `studentCount` (int): Students in community
- `subjectCount` (int): Subjects in community
- `pendingRequests` (int): Pending join requests

### community-create.jsp
**Path:** `/WEB-INF/views/moderator/community-create.jsp`

Form for moderator to create their community.

### community-waiting.jsp
**Path:** `/WEB-INF/views/moderator/community-waiting.jsp`

Waiting page while community is pending approval.

### join-requests.jsp
**Path:** `/WEB-INF/views/moderator/join-requests.jsp`

List of pending join requests with approve/reject actions.

**Request Attributes:**
- `pendingRequests` (List<JoinRequest>): Pending requests
- `approvedRequests` (List<JoinRequest>): Approved requests
- `rejectedRequests` (List<JoinRequest>): Rejected requests

### students.jsp
**Path:** `/WEB-INF/views/moderator/students.jsp`

List of students in moderator's community.

**Request Attributes:**
- `students` (List<User>): Student list

### subjects-list.jsp
**Path:** `/WEB-INF/views/moderator/subjects-list.jsp`

List view of subjects.

### subjects-grid.jsp
**Path:** `/WEB-INF/views/moderator/subjects-grid.jsp`

Grid/card view of subjects.

### subject-form.jsp
**Path:** `/WEB-INF/views/moderator/subject-form.jsp`

Create/edit subject form.

**Request Attributes:**
- `subject` (Subject): Subject to edit (null for create)
- `isEdit` (boolean): Edit mode flag

### topics-list.jsp
**Path:** `/WEB-INF/views/moderator/topics-list.jsp`

List view of topics for a subject.

### topics-grid.jsp
**Path:** `/WEB-INF/views/moderator/topics-grid.jsp`

Grid/card view of topics.

### topic-form.jsp
**Path:** `/WEB-INF/views/moderator/topic-form.jsp`

Create/edit topic form.

### subject-coordinators.jsp
**Path:** `/WEB-INF/views/moderator/subject-coordinators.jsp`

List of subject coordinators.

### all-coordinators.jsp
**Path:** `/WEB-INF/views/moderator/all-coordinators.jsp`

All coordinators in community.

### select-subject-for-coordinator.jsp
**Path:** `/WEB-INF/views/moderator/select-subject-for-coordinator.jsp`

Subject selection for assigning coordinator.

### assign-coordinator.jsp
**Path:** `/WEB-INF/views/moderator/assign-coordinator.jsp`

Form to assign student as coordinator.

### edit-coordinator.jsp
**Path:** `/WEB-INF/views/moderator/edit-coordinator.jsp`

Form to edit coordinator assignment.

### profile-settings.jsp
**Path:** `/WEB-INF/views/moderator/profile-settings.jsp`

Moderator profile settings.

---

## Student Views

### dashboard.jsp
**Path:** `/WEB-INF/views/student/dashboard.jsp`

Student dashboard with learning progress.

**Request Attributes:**
- `user` (User): Current user
- `community` (Community): Student's community
- `overallProgress` (BigDecimal): Overall progress percentage

### join-community.jsp
**Path:** `/WEB-INF/views/student/join-community.jsp`

Community joining page.

**Request Attributes:**
- `communities` (List<Community>): Available communities
- `pendingRequest` (JoinRequest): Current pending request (if any)
- `error` (String): Error message
- `success` (String): Success message

### subjects-list.jsp / subjects-grid.jsp
**Path:** `/WEB-INF/views/student/subjects-list.jsp`

List of subjects for student's academic year.

**Request Attributes:**
- `subjects` (List<Subject>): Subject list

### topics-list.jsp / topics-grid.jsp
**Path:** `/WEB-INF/views/student/topics-list.jsp`

List of topics with progress tracking.

**Request Attributes:**
- `subject` (Subject): Current subject
- `topics` (List<Topic>): Topics with progress

### resources.jsp
**Path:** `/WEB-INF/views/student/resources.jsp`

List of resources for a topic.

**Request Attributes:**
- `topic` (Topic): Current topic
- `resources` (List<Resource>): Approved resources
- `categories` (List<ResourceCategory>): Categories

### resource-detail.jsp
**Path:** `/WEB-INF/views/student/resource-detail.jsp`

Detailed view of a resource.

**Request Attributes:**
- `resource` (Resource): Resource details

### upload-resource.jsp
**Path:** `/WEB-INF/views/student/upload-resource.jsp`

Resource upload form.

**Request Attributes:**
- `topic` (Topic): Target topic
- `categories` (List<ResourceCategory>)

### edit-resource.jsp
**Path:** `/WEB-INF/views/student/edit-resource.jsp`

Resource edit form.

**Request Attributes:**
- `resource` (Resource): Resource to edit

### profile-settings.jsp
**Path:** `/WEB-INF/views/student/profile-settings.jsp`

Student profile settings.

### quizzes.jsp
**Path:** `/WEB-INF/views/student/quizzes.jsp`

Quiz feature page (placeholder).

---

## Subject Coordinator Views

### resource-approvals.jsp
**Path:** `/WEB-INF/views/subject-coordinator/resource-approvals.jsp`

List of pending resources for approval.

**Request Attributes:**
- `pendingNewResources` (List<Resource>): New uploads pending
- `pendingEditResources` (List<Resource>): Edits pending

---

## Tag Files (Reusable Components)

### Dashboard Tags
**Path:** `/WEB-INF/tags/dashboard/`

Reusable dashboard components like sidebars, headers, cards.

### Layout Tags
**Path:** `/WEB-INF/tags/layouts/`

Page layout templates that provide consistent structure.

**Example usage in JSP:**
```jsp
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:moderator-dashboard pageTitle="Dashboard">
    <jsp:body>
        <!-- Page content here -->
    </jsp:body>
</layout:moderator-dashboard>
```

---

## Static Assets

### CSS Files

| File | Description |
|------|-------------|
| app.css | Main application styles |
| auth.css | Authentication page styles |
| dashboard.css | Dashboard layout styles |
| community.css | Community-specific styles |
| style.css | Additional global styles |

### JavaScript Files

| File | Description |
|------|-------------|
| app.js | Main application scripts |
| auth.js | Authentication scripts |
| dashboard.js | Dashboard interactivity |
| q.js | Utility scripts |

### Vendor Directory

Third-party libraries and assets.

---

## Common JSTL Usage

### Iteration
```jsp
<c:forEach var="student" items="${students}">
    <tr>
        <td>${student.name}</td>
        <td>${student.email}</td>
    </tr>
</c:forEach>
```

### Conditionals
```jsp
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:choose>
    <c:when test="${student.academicYear == 1}">First Year</c:when>
    <c:when test="${student.academicYear == 2}">Second Year</c:when>
    <c:otherwise>Upper Year</c:otherwise>
</c:choose>
```

### URL Building
```jsp
<a href="${pageContext.request.contextPath}/admin/students/edit?id=${student.id}">
    Edit
</a>
```

### Form Handling
```jsp
<form action="${pageContext.request.contextPath}/admin/students/add" method="POST">
    <input type="text" name="email" value="${student.email}" required>
    <button type="submit">Create</button>
</form>
```

---

## Error Handling

### error.jsp
**Path:** `/WEB-INF/views/error.jsp`

Generic error page displayed when errors occur.

**Request Attributes:**
- `error` (String): Error message
- `javax.servlet.error.status_code` (Integer): HTTP status code
- `javax.servlet.error.message` (String): Error details

---

## Responsive Design

Views use responsive CSS classes to adapt to different screen sizes:

- Grid views switch to list views on mobile
- Sidebars collapse to hamburger menus
- Forms stack vertically on small screens
- Tables become scrollable on narrow viewports
