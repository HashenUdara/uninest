# Workflow Diagrams

## Moderator Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                      MODERATOR JOURNEY                           │
└─────────────────────────────────────────────────────────────────┘

Step 1: Signup
┌──────────────┐
│ /signup      │  Moderator selects "Moderator" role
│              │  Fills email, password
└──────┬───────┘
       │
       ▼
Step 2: Create Organization
┌──────────────────────────────┐
│ /moderator/create-organization│  Enters organization title
│                               │  Provides description
└──────┬────────────────────────┘
       │
       ▼
Step 3: Wait for Approval
┌───────────────────────────────┐
│ /moderator/organization-pending│  Displays "Pending Approval" message
│                                │  ⏳ Cannot proceed further
│                                │  If logs in again → same page
└──────┬─────────────────────────┘
       │
       │  [Admin Approves Organization]
       │
       ▼
Step 4: Dashboard Access
┌──────────────────────────┐
│ /moderator/dashboard     │  ✅ Organization approved
│                          │  📋 Organization ID displayed
│                          │  Can share ID with students
└──────────────────────────┘
```

## Student Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                       STUDENT JOURNEY                            │
└─────────────────────────────────────────────────────────────────┘

Step 1: Signup with Details
┌──────────────┐
│ /signup      │  Student selects "Student" role
│              │  Fills email, password
│              │  📚 Selects Academic Year (1-4)
│              │  🏫 Selects University
└──────┬───────┘
       │
       ▼
Step 2: Join Organization
┌──────────────────────────┐
│ /student/join-organization│  Enters Organization ID
│                           │  (Provided by moderator)
│                           │  System validates:
│                           │    - Org exists
│                           │    - Org is approved
└──────┬────────────────────┘
       │
       ▼
Step 3: Dashboard Access
┌──────────────────────┐
│ /student/dashboard   │  ✅ Joined organization
│                      │  Can access learning materials
└──────────────────────┘
```

## Admin Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                       ADMIN JOURNEY                              │
└─────────────────────────────────────────────────────────────────┘

Step 1: Login
┌──────────────┐
│ /login       │  Admin credentials
└──────┬───────┘
       │
       ▼
Step 2: Dashboard
┌──────────────────┐
│ /admin/dashboard │  Click "Manage Organizations"
└──────┬───────────┘
       │
       ▼
Step 3: Manage Organizations
┌──────────────────────────┐
│ /admin/organizations     │  View all organizations
│                          │  Filter by status:
│                          │    ⏳ Pending
│                          │    ✅ Approved
│                          │    ❌ Rejected
│                          │
│  Actions:                │
│  [Approve] [Reject]      │
└──────────────────────────┘
```

## Database Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                      ENTITY RELATIONSHIPS                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────┐              ┌──────────────────┐
│   roles     │              │  organizations   │
├─────────────┤              ├──────────────────┤
│ id (PK)     │              │ id (PK)          │
│ name        │              │ title            │
│ description │              │ description      │
└─────┬───────┘              │ moderator_id (FK)│
      │                      │ status           │
      │                      │ created_at       │
      │                      │ updated_at       │
      │                      └────────┬─────────┘
      │                               │
      │    ┌──────────────────────────┘
      │    │
      ▼    ▼
┌─────────────────────┐
│      users          │
├─────────────────────┤
│ id (PK)             │
│ email               │
│ password_hash       │
│ role_id (FK)        │───► Refers to roles.id
│ organization_id (FK)│───► Refers to organizations.id
│ academic_year       │
│ university          │
│ created_at          │
└─────────────────────┘
        │
        └────► moderator_id in organizations
               creates circular FK relationship
```

## Status Flow for Organizations

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORGANIZATION STATUS FLOW                      │
└─────────────────────────────────────────────────────────────────┘

       [Moderator Creates Org]
                │
                ▼
        ┌───────────────┐
        │   PENDING     │◄─── Initial state
        │   ⏳          │     (default)
        └───────┬───────┘
                │
        [Admin Reviews]
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
┌──────────────┐  ┌──────────────┐
│  APPROVED    │  │   REJECTED   │
│  ✅          │  │   ❌         │
└──────┬───────┘  └──────┬───────┘
       │                 │
       │                 │
       ▼                 ▼
[Moderator can]   [Moderator sees]
[access dash]     [rejection msg]
                  [stays on pending]
                  [page]
```

## Form Field Visibility Logic

```
┌─────────────────────────────────────────────────────────────────┐
│                    SIGNUP FORM FIELDS                            │
└─────────────────────────────────────────────────────────────────┘

All Roles:
├── Full Name        (always visible)
├── Email            (always visible)
├── Password         (always visible)
├── Confirm Password (always visible)
└── Role Selection   (always visible)
    ├─► Student
    │   └─► Shows additional fields:
    │       ├── Academic Year (dropdown: 1,2,3,4)
    │       └── University (dropdown: 15 options)
    │
    └─► Moderator
        └─► Hides academic year and university
            (not applicable for moderators)

JavaScript toggles field visibility based on selected role.
```

## Validation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    VALIDATION CHECKS                             │
└─────────────────────────────────────────────────────────────────┘

Student Signup:
├── Email format valid? ────────► YES ──┐
├── Password length >= 6? ──────► YES ──┤
├── Passwords match? ───────────► YES ──┤
├── Academic year selected? ────► YES ──┤
├── University selected? ───────► YES ──┤
│                                        │
└────────────────────────────────────────┼──► CREATE USER
                                         │
                                         └──► Redirect to join-organization

Student Join Organization:
├── Org ID provided? ───────────► YES ──┐
├── Org exists? ────────────────► YES ──┤
├── Org status = approved? ─────► YES ──┤
│                                        │
└────────────────────────────────────────┼──► JOIN ORG
                                         │
                                         └──► Redirect to dashboard

Moderator Create Organization:
├── Title provided? ────────────► YES ──┐
├── Description provided? ──────► YES ──┤
│                                        │
└────────────────────────────────────────┼──► CREATE ORG
                                         │
                                         └──► Redirect to pending page
```

## Technology Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                      TECH STACK                                  │
└─────────────────────────────────────────────────────────────────┘

Backend:
├── Java 8
├── Jakarta Servlet API 6.0
├── Maven 3.x
└── BCrypt (password hashing)

Frontend:
├── JSP (JavaServer Pages)
├── JSTL (JSP Standard Tag Library)
├── Custom JSP Tags (layouts)
└── JavaScript (form validation)

Database:
├── MySQL
├── InnoDB Engine
└── UTF8MB4 Character Set

Build/Deploy:
├── Maven
├── Tomcat 11
└── WAR packaging
```
