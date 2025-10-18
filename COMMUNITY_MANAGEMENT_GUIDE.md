# Admin Organization Management Guide

## Overview

This implementation provides comprehensive organization management functionality for admins in the UniNest application.

## Features Implemented

### 1. Organization Status Management

- **Pending**: Organizations waiting for admin approval
- **Approved**: Organizations that have been approved by admin
- **Rejected**: Organizations that have been rejected by admin

### 2. Admin Capabilities

#### Create Organization

- Admins can create new organizations directly
- Admin-created organizations are automatically approved
- URL: `/admin/organizations/create`
- Fields: Title, Description

#### View Organizations by Status

- Three tabs to filter organizations: Pending, Approved, Rejected
- URL: `/admin/organizations?status=<pending|approved|rejected>`
- Displays organization list with avatar, title, description, and actions

#### Approve Organization

- Approves a pending or rejected organization
- Updates status to "approved" and sets approved flag
- Records admin ID and timestamp

#### Reject Organization

- Rejects a pending or approved organization
- Updates status to "rejected"
- Records admin ID and timestamp

#### Edit Organization

- Edit organization title and description
- Uses same form as create (reusable)
- URL: `/admin/organizations/edit?id=<org_id>`

#### Delete Organization

- Deletes organization with confirmation modal
- Confirmation dialog prevents accidental deletions
- URL: `/admin/organizations/delete` (POST)

### 3. Database Schema Updates

#### Organizations Table

```sql
CREATE TABLE `organizations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(150) NOT NULL,
  `description` VARCHAR(500) DEFAULT NULL,
  `created_by_user_id` INT NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',  -- NEW FIELD
  `approved` TINYINT(1) NOT NULL DEFAULT 0,
  `approved_at` TIMESTAMP NULL DEFAULT NULL,
  `approved_by_user_id` INT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_org_status` (`status`),  -- NEW INDEX
  INDEX `idx_org_approved` (`approved`),
  FOREIGN KEY (`created_by_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`approved_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

### 4. Backend Components

#### Model

- `Organization.java`: Added `status` field

#### DAO (Data Access Object)

- `OrganizationDAO.java`: Added methods:
  - `findByStatus(String status)`: Get organizations by status
  - `reject(int organizationId, int adminUserId)`: Reject an organization
  - `update(Organization org)`: Update organization details
  - `delete(int organizationId)`: Delete an organization

#### Servlets

- `OrganizationsServlet.java`: Display organizations with tab filtering
- `OrganizationCreateServlet.java`: Create new organization (GET/POST)
- `OrganizationEditServlet.java`: Edit organization (GET/POST)
- `ApproveOrganizationServlet.java`: Approve organization (POST)
- `RejectOrganizationServlet.java`: Reject organization (POST)
- `DeleteOrganizationServlet.java`: Delete organization (POST)

### 5. Frontend Components

#### JSP Pages

- `organizations.jsp`: Main page with tabs and organization table
- `organization-create.jsp`: Form to create new organization
- `organization-edit.jsp`: Form to edit organization

#### CSS Styles (in dashboard.css)

- `.c-comm-cell`: Organization display with avatar
- `.c-modal`: Confirmation modal dialog
- `.c-toast`: Toast notifications
- `.c-tabs`: Tab navigation
- Various button variants and utilities

#### JavaScript (in dashboard.js)

- `initOrgAvatars()`: Initialize organization avatars with colors
- `initOrgConfirm()`: Handle confirmation modals for actions

### 6. UI Features

#### Tab Navigation

- Three tabs at the top: Pending, Approved, Rejected
- Active tab is highlighted
- URL preserves tab state

#### Organization Table

- Colored avatar based on organization name
- Organization ID display
- Description with text clipping
- Action buttons based on status:
  - Pending: Approve, Reject, Edit, Delete
  - Approved: Reject, Edit, Delete
  - Rejected: Approve, Edit, Delete

#### Confirmation Modal

- Appears before approve, reject, or delete actions
- Dynamic title and message based on action
- Cancel and Confirm buttons
- Closes on Escape key

#### Form Pages

- Clean, card-based form layout
- Required field validation
- Cancel and Submit buttons
- Breadcrumb navigation

## Usage Flow

### For Admins Creating Organizations

1. Navigate to Organizations page
2. Click "Create Organization" button
3. Fill in Title and Description
4. Submit form
5. Organization is created with "approved" status
6. Redirected to Approved tab

### For Admins Managing Requests

1. Navigate to Organizations page (defaults to Pending tab)
2. Review pending organizations
3. Click "Approve" or "Reject" buttons
4. Confirm action in modal
5. Organization status updated
6. Redirected to appropriate tab

### For Editing Organizations

1. Click pencil icon next to organization
2. Edit Title and/or Description
3. Click "Update Organization"
4. Returns to the same status tab

### For Deleting Organizations

1. Click trash icon next to organization
2. Confirm deletion in modal
3. Organization is permanently deleted
4. Returns to the same status tab

## URL Patterns

| URL                                    | Method | Description                              |
| -------------------------------------- | ------ | ---------------------------------------- |
| `/admin/organizations`                 | GET    | List organizations (defaults to pending) |
| `/admin/organizations?status=pending`  | GET    | List pending organizations               |
| `/admin/organizations?status=approved` | GET    | List approved organizations              |
| `/admin/organizations?status=rejected` | GET    | List rejected organizations              |
| `/admin/organizations/create`          | GET    | Show create form                         |
| `/admin/organizations/create`          | POST   | Create organization                      |
| `/admin/organizations/edit?id=<id>`    | GET    | Show edit form                           |
| `/admin/organizations/edit`            | POST   | Update organization                      |
| `/admin/organizations/approve`         | POST   | Approve organization                     |
| `/admin/organizations/reject`          | POST   | Reject organization                      |
| `/admin/organizations/delete`          | POST   | Delete organization                      |

## Security Considerations

1. All admin organization URLs are protected by `AuthFilter`
2. Only users with admin role can access these endpoints
3. User session is validated before any operation
4. All actions record the admin user ID for audit trail

## Integration with Existing System

The implementation:

- Reuses the existing dashboard layout (`dashboard.tag`)
- Follows existing servlet patterns
- Uses existing authentication system
- Extends existing DAO pattern
- Maintains consistency with current UI components
- Preserves existing navigation structure

## Testing

To test the implementation:

1. Login as an admin user
2. Navigate to Organizations from the sidebar
3. Test creating a new organization
4. Test approving/rejecting organizations
5. Test editing organization details
6. Test deleting organizations with confirmation
7. Verify tab switching works correctly
8. Check that organization count updates correctly
