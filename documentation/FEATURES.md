# Features Documentation

## Overview

UniNest is a comprehensive university community management system that enables students to collaborate, share resources, and track their learning progress within academic communities.

---

## Core Features

### 1. User Authentication

**Login System**
- Email/password authentication
- BCrypt password hashing
- Session-based authentication
- Role-based redirect after login

**Registration**
- Student self-registration
- University and academic year selection
- Email validation

**Password Reset**
- Email-based password reset
- Secure token generation
- Token expiration handling

---

### 2. Community Management

**Community Creation**
- Moderators can create one community
- Title and description
- Requires admin approval

**Community Approval Workflow**
- Admin reviews pending communities
- Approve or reject with status tracking
- Moderator notified via dashboard status

**Community Structure**
```
Community
├── Subjects (organized by academic year/semester)
│   ├── Topics
│   │   └── Resources
│   └── Subject Coordinators
└── Members (Students)
```

---

### 3. Join Request System

**Student Flow**
1. Student browses available communities
2. Submits join request
3. Waits for moderator approval
4. Gets access after approval

**Moderator Flow**
1. Views pending requests
2. Reviews student information (name, email, year, university)
3. Approves or rejects request
4. Student is assigned to community on approval

**Features**
- Pending/Approved/Rejected tabs
- Confirmation dialogs
- Request cancellation by student
- Community isolation (moderators see only their requests)

---

### 4. Subject Management

**Subject Properties**
- Name and code (e.g., "Data Structures", "CS204")
- Description
- Academic year (1-4)
- Semester (1-2)
- Status (upcoming, ongoing, completed)

**Subject Actions**
- Create new subjects
- Edit existing subjects
- Delete subjects (cascades to topics/resources)
- Filter by academic year

**View Options**
- List view
- Grid/card view

---

### 5. Topic Management

**Topic Structure**
- Topics belong to subjects
- Title and description
- Created timestamp

**Topic Actions**
- Create topics under a subject
- Edit topic details
- Delete topics (cascades to resources)

**Progress Tracking**
- Per-topic progress percentage
- Last accessed timestamp
- Visual progress indicators

---

### 6. Resource Management

**Resource Types**
- Lecture Notes
- Short Notes
- Past Papers
- Tutorials
- Assignments
- Lab Sheets
- Video Tutorials
- Project Reports
- Reference Materials
- Model Answers

**Upload Workflow**
1. Student uploads resource with metadata
2. Resource status: "pending"
3. Subject coordinator reviews
4. Approved resources become visible

**Resource Properties**
- Title and description
- Category
- File (URL or upload)
- Visibility (private/public)
- Status (pending/approved/rejected)
- Versioning support

**Edit Workflow**
1. Student edits approved resource
2. Creates new version (pending_edit)
3. Coordinator approves edit
4. Old version marked as "replaced"

---

### 7. Subject Coordinator System

**Role Definition**
- Students with special privileges
- Can approve/reject resources for assigned subject
- One coordinator per subject
- One subject per coordinator

**Assignment Workflow**
1. Moderator selects subject
2. Chooses student from community
3. Student gains coordinator access
4. Access to `/subject-coordinator/*` paths

**Coordinator Actions**
- View pending resources
- Preview resource details
- Approve resources (makes them public)
- Reject resources

---

### 8. Progress Tracking

**Student Progress**
- Per-topic progress percentage (0-100%)
- Last accessed timestamp
- Overall subject progress
- Dashboard progress overview

**Progress Features**
- Visual progress bars
- Topic-level tracking
- Subject-level aggregation

---

### 9. Admin Dashboard

**System Overview**
- Total students count
- Total moderators count
- Total communities count
- Pending communities count

**User Management**
- List all students
- Add/Edit/Delete students
- Search by name, email, university
- Assign to communities

**Moderator Management**
- List all moderators
- Add/Edit/Delete moderators
- View assigned communities

**Community Management**
- List all communities (pending/approved/rejected)
- Approve pending communities
- Reject communities
- Edit community details
- Delete communities

---

### 10. Moderator Dashboard

**Community Overview**
- Community statistics
- Student count
- Subject count
- Pending join requests

**Student Management**
- View students in community
- Remove students from community

**Subject & Topic Management**
- Create/Edit/Delete subjects
- Create/Edit/Delete topics
- View subject details

**Coordinator Management**
- Assign subject coordinators
- View all coordinators
- Edit coordinator assignments
- Remove coordinators

**Join Request Management**
- View pending requests
- Approve/reject with one click
- Request history (approved/rejected tabs)

---

### 11. Student Dashboard

**Personal Overview**
- Community information
- Learning progress summary
- Quick access to subjects

**Subject Browsing**
- Subjects filtered by academic year
- Subject status indicators
- Grid and list views

**Topic Navigation**
- Topics with progress indicators
- Resource counts per topic

**Resource Access**
- Browse approved resources
- Filter by category
- View resource details
- Download resources

**Resource Upload**
- Upload new resources
- Select category and topic
- Add title and description
- Track upload status

**My Resources**
- View uploaded resources
- Edit pending/approved resources
- Delete own resources
- Track approval status

---

## Feature Workflows

### Student Registration to Learning

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Register   │────►│   Join       │────►│   Browse     │
│   Account    │     │   Community  │     │   Subjects   │
└──────────────┘     └──────────────┘     └──────────────┘
                                                  │
                                                  ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Download   │◄────│   View       │◄────│   Select     │
│   Resources  │     │   Topic      │     │   Topic      │
└──────────────┘     └──────────────┘     └──────────────┘
```

### Resource Upload to Publication

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Upload     │────►│   Pending    │────►│  Coordinator │
│   Resource   │     │   Status     │     │   Review     │
└──────────────┘     └──────────────┘     └──────────────┘
                                                  │
                     ┌────────────────────────────┼────────┐
                     │                            │        │
                     ▼                            ▼        ▼
              ┌──────────────┐           ┌──────────────┐
              │   Approved   │           │   Rejected   │
              │   (Public)   │           │   (Private)  │
              └──────────────┘           └──────────────┘
```

### Community Approval Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Moderator   │────►│   Pending    │────►│    Admin     │
│   Creates    │     │   Community  │     │   Reviews    │
└──────────────┘     └──────────────┘     └──────────────┘
                                                  │
                     ┌────────────────────────────┼────────┐
                     │                            │        │
                     ▼                            ▼        
              ┌──────────────┐           ┌──────────────┐
              │   Approved   │           │   Rejected   │
              │   Community  │           │   Community  │
              └──────────────┘           └──────────────┘
                     │
                     ▼
              ┌──────────────┐
              │  Moderator   │
              │   Access     │
              └──────────────┘
```

---

## Future Features (Planned)

Based on the codebase structure and existing docs:

### Quizzes
- `/student/quizzes.jsp` exists as placeholder
- Quiz creation and taking functionality

### Kuppi Sessions
- `/student/kuppi-sessions/` directory exists
- Study group/tutoring session management

### Progress Analysis
- `/student/progress-analysis/` directory exists
- Detailed learning analytics

### Email Notifications
- MailUtil exists for email sending
- Password reset emails implemented
- Could extend to:
  - Join request notifications
  - Resource approval notifications
  - Community approval notifications

---

## Feature Access Matrix

| Feature | Admin | Moderator | Student | Coordinator |
|---------|-------|-----------|---------|-------------|
| Login/Logout | ✓ | ✓ | ✓ | ✓ |
| View Dashboard | ✓ | ✓ | ✓ | ✓ |
| Manage Students | ✓ | ✓¹ | - | - |
| Manage Moderators | ✓ | - | - | - |
| Manage Communities | ✓ | ✓² | - | - |
| Approve Communities | ✓ | - | - | - |
| Manage Subjects | - | ✓ | - | - |
| Manage Topics | - | ✓ | - | - |
| Assign Coordinators | - | ✓ | - | - |
| Handle Join Requests | - | ✓ | - | - |
| Browse Subjects | ✓ | ✓ | ✓ | ✓ |
| Browse Topics | ✓ | ✓ | ✓ | ✓ |
| View Resources | ✓ | ✓ | ✓ | ✓ |
| Upload Resources | ✓ | ✓ | ✓ | ✓ |
| Edit Own Resources | ✓ | ✓ | ✓ | ✓ |
| Approve Resources | - | - | - | ✓ |
| Track Progress | ✓ | ✓ | ✓ | ✓ |
| Submit Join Request | - | - | ✓ | ✓ |

¹ Only in their community  
² Only their own community
