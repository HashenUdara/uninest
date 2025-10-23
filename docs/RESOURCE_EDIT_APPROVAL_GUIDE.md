# Resource Edit Approval Workflow - Implementation Guide

## Overview

This feature implements a comprehensive version tracking system for student-uploaded resources, allowing students to edit approved resources while maintaining the previous version visible until coordinators approve the new changes.

## Key Features

### 1. Student Capabilities

#### Upload Resources
- Students can upload new resources (files or links)
- Resources start with `pending` status
- Visible only to the uploader until approved

#### Edit Resources
- **Pending/Rejected Resources**: Can be edited in-place
- **Approved Resources**: Edits create a new version
  - Original remains visible and public
  - New version has `pending_edit` status
  - Upon approval, new version replaces the old one

#### Delete Resources
- Students can delete resources with status:
  - `pending` (new uploads awaiting approval)
  - `rejected` (rejected resources)
  - `pending_edit` (edit requests awaiting approval)
- Approved resources cannot be deleted directly

### 2. Coordinator Approval System

#### Two Approval Categories
1. **New Uploads Tab**
   - Shows resources with `status = 'pending'` and `edit_type = 'new'`
   - First-time submissions

2. **Edit Approvals Tab**
   - Shows resources with `status = 'pending_edit'` and `edit_type = 'edit'`
   - Edit requests for already-approved resources
   - Displays version number

#### Approval Actions
- **Approve**: Changes status to `approved`, makes resource public
  - For edits: Replaces old version (sets old to `replaced` status)
- **Reject**: Changes status to `rejected`, keeps resource private

### 3. Student Dashboard

Displays two organized sections for pending requests:

#### Pending New Uploads
- Table showing all uploads awaiting approval
- Shows resource details, subject, topic, category, upload date
- Quick view action

#### Pending Edit Approvals
- Table showing all edit requests awaiting approval
- Shows resource details, subject, topic, category, edit date, version
- Quick view action

## Database Schema

### New Columns in `resources` Table

```sql
parent_resource_id INT DEFAULT NULL         -- Links to original resource for edits
version INT DEFAULT 1                       -- Version number
edit_type ENUM('new', 'edit') DEFAULT 'new' -- Type of resource
```

### Extended Status Values

```sql
status ENUM('pending', 'approved', 'rejected', 'pending_edit', 'replaced')
```

- `pending`: New upload awaiting approval
- `approved`: Approved and publicly visible
- `rejected`: Rejected by coordinator
- `pending_edit`: Edit request awaiting approval
- `replaced`: Old version replaced by approved edit

## User Interface Components

### Student Pages

1. **Dashboard** (`/student/dashboard`)
   - Pending New Uploads section
   - Pending Edit Approvals section

2. **My Resources** (`/student/resources`)
   - Lists all user's resources with status badges
   - Filter by category
   - Grid/Table view toggle

3. **Resource Detail** (`/student/resources/{id}`)
   - View resource details
   - Edit button (for own resources)
   - Delete button (for pending/rejected/pending_edit)
   - Status badge

4. **Edit Resource** (`/student/resources/edit?resourceId={id}`)
   - Form to edit resource details
   - Info alert for approved resources explaining approval process
   - Option to keep or replace file/link

### Coordinator Pages

1. **Resource Approvals** (`/subject-coordinator/resource-approvals`)
   - Tab navigation:
     - New Uploads (default)
     - Edit Approvals
   - Table view with resource details
   - Approve/Reject actions
   - Version indicators for edits

### Navigation

Sidebar menu for coordinators includes expandable group:
```
Subject Coordinator
  └─ Resource Approvals
       ├─ New Uploads
       └─ Edit Approvals
```

## Workflow Examples

### Scenario 1: New Upload
1. Student uploads resource → `status = 'pending'`, `edit_type = 'new'`
2. Appears in coordinator's "New Uploads" tab
3. Coordinator approves → `status = 'approved'`, `visibility = 'public'`
4. Resource visible to all students

### Scenario 2: Edit Approved Resource
1. Student clicks "Edit" on approved resource
2. Makes changes and submits
3. System creates new record:
   - `parent_resource_id = {original_id}`
   - `version = {original_version + 1}`
   - `status = 'pending_edit'`
   - `edit_type = 'edit'`
4. Original resource remains `approved` and visible
5. New version appears in coordinator's "Edit Approvals" tab
6. Coordinator approves:
   - Old version → `status = 'replaced'`, `visibility = 'private'`
   - New version → `status = 'approved'`, `visibility = 'public'`
7. New version now visible to all students

### Scenario 3: Edit Pending Resource
1. Student clicks "Edit" on pending/rejected resource
2. Makes changes and submits
3. Same resource updated in-place (no new version created)
4. Remains in "New Uploads" tab

### Scenario 4: Delete Pending Request
1. Student clicks "Delete" on pending/rejected/pending_edit resource
2. Confirmation dialog appears
3. Resource permanently deleted from database

## API Endpoints

### Student Endpoints
- `GET /student/resources/upload` - Upload form
- `POST /student/resources/upload` - Create new resource
- `GET /student/resources/edit?resourceId={id}` - Edit form
- `POST /student/resources/edit` - Update resource
- `POST /student/resources/delete` - Delete resource
- `GET /student/resources/{id}` - View resource detail

### Coordinator Endpoints
- `GET /subject-coordinator/resource-approvals?tab={new|edits}` - Approval page
- `POST /subject-coordinator/resource-approvals/approve` - Approve resource
- `POST /subject-coordinator/resource-approvals/reject` - Reject resource

## Key DAO Methods

### ResourceDAO

```java
// Find pending new uploads for coordinator's subjects
List<Resource> findPendingNewUploadsBySubjectIds(List<Integer> subjectIds)

// Find pending edits for coordinator's subjects
List<Resource> findPendingEditsBySubjectIds(List<Integer> subjectIds)

// Approve edit (replaces old version)
boolean approveEdit(int resourceId, int approverId)

// Update resource in-place
boolean update(Resource resource)

// Find parent resource
Optional<Resource> findParentResource(int resourceId)
```

## Migration Guide

### For New Installations
Use the complete schema in `src/main/resources/db/migration/db.sql`

### For Existing Installations
Run the migration script:
```sql
source src/main/resources/db/migration/add_resource_versioning.sql
```

This will:
1. Add new columns to resources table
2. Add foreign key constraints
3. Update status enum
4. Set default values for existing records

## Testing Checklist

- [ ] Upload new resource as student
- [ ] Verify appears in coordinator's "New Uploads" tab
- [ ] Approve resource
- [ ] Verify resource is publicly visible
- [ ] Edit approved resource as student
- [ ] Verify old version still visible
- [ ] Verify new version in coordinator's "Edit Approvals" tab
- [ ] Approve edit
- [ ] Verify old version replaced
- [ ] Verify new version visible
- [ ] Edit pending resource
- [ ] Verify updates in-place
- [ ] Delete pending resource
- [ ] Verify deletion successful
- [ ] Check student dashboard shows pending requests
- [ ] Verify all status badges display correctly
- [ ] Test version numbering
- [ ] Test navigation between tabs

## Design Patterns

### UI Consistency
- Uses existing component library (c-table, c-tabs, c-badge, etc.)
- Maintains color scheme and spacing
- Consistent icon usage (lucide icons)
- Responsive design patterns

### Code Standards
- Servlet-based architecture
- DAO pattern for database access
- JSP/JSTL for views
- Transaction management for edit approvals
- Proper error handling and validation

## Security Considerations

1. **Authorization Checks**
   - Students can only edit/delete their own resources
   - Coordinators can only approve resources in their subjects

2. **Status Validation**
   - Enforce allowed status transitions
   - Prevent deletion of approved resources

3. **File Handling**
   - Files stored outside webapp directory
   - Proper file type validation
   - Size limits enforced

## Future Enhancements

Potential improvements:
1. View comparison between versions
2. Notification system for approval/rejection
3. Comments/feedback on rejected resources
4. Bulk approval capabilities
5. Resource analytics and usage tracking
6. Version history view
