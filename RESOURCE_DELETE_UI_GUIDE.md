# Resource Deletion Feature - UI Changes

## Overview
This document describes the UI changes made to implement resource deletion functionality across the application.

## UI Components Added

### 1. Delete Button Styling
- **Icon:** `trash-2` from Lucide icon set
- **Style:** 
  - On detail page: `c-btn c-btn--sm c-btn--danger` (red danger button)
  - On table views: `c-btn c-btn--sm c-btn--ghost` (subtle ghost button)
- **Label:** "Delete" text shown on detail page, icon-only on table views
- **Confirmation:** JavaScript confirmation dialog with message: "Are you sure you want to delete this resource? This action cannot be undone."

### 2. My Resources Page (resources.jsp)

#### Table View - Actions Column
**Before:**
```
Actions:
- [Eye icon] View
- [Download icon] Download (if approved)
```

**After:**
```
Actions:
- [Eye icon] View
- [Download icon] Download (if approved)
- [Trash icon] Delete (if user owns resource)
```

**Location:** Right-aligned actions column in the table
**Visibility:** Delete button only shows for resources uploaded by the current user

### 3. Topic-Specific Resource Page (resources.jsp with topicId parameter)

#### Table View - Actions Column
**Before:**
```
Actions:
- [Eye icon] View
- [Download icon] Download
```

**After:**
```
Actions:
- [Eye icon] View
- [Download icon] Download
- [Trash icon] Delete (if user owns resource OR user is coordinator)
```

**Location:** Right-aligned actions column in the table
**Visibility:** 
- Shows for resource owner
- Also shows for subject coordinators (even if they don't own the resource)

### 4. Resource Detail Page (resource-detail.jsp)

#### Action Buttons Section
**Before:**
```
Left side:
- [Edit icon] Edit (if pending/rejected/approved, only for owner)
- [Delete icon] Delete (if pending/rejected/pending_edit, only for owner)

Right side:
- [Download/Open icon] Download/Open Resource
```

**After:**
```
Left side:
- [Edit icon] Edit (if pending/rejected/approved, only for owner)
- [Delete icon] Delete (for all statuses, owner OR coordinator)

Right side:
- [Download/Open icon] Download/Open Resource
```

**Changes:**
- Delete button now shows for ALL resource statuses (not just pending/rejected/pending_edit)
- Separate delete button shows for coordinators (red danger button)
- Button text: "Delete" with trash-2 icon

### 5. Subject Coordinator Dashboard (resource-approvals.jsp)

#### Navigation Tabs
**Before:**
```
Tabs:
- New Uploads
- Edit Approvals
```

**After:**
```
Tabs:
- [Clock icon] Requests
- [Check-circle icon] Approved
- [X-circle icon] Rejected
- [Edit icon] Edit Approvals
```

**Default Tab:** "Requests" (was "New Uploads")

#### Table View - Actions Column

**On "Requests" and "Edit Approvals" tabs:**
```
Actions:
- [Eye icon] Preview / [External-link icon] Open Link
- [Check icon] Approve (green button)
- [X icon] Reject (red button)
- [Trash icon] Delete (ghost button)
```

**On "Approved" and "Rejected" tabs:**
```
Actions:
- [Eye icon] Preview / [External-link icon] Open Link
- [Trash icon] Delete (ghost button)
```

#### Table Columns

**Requests/Edit Approvals tabs:**
- Resource
- Subject
- Topic
- Category
- Uploaded By
- Upload Date
- Version (Edit Approvals only)
- Actions

**Approved/Rejected tabs:**
- Resource
- Subject
- Topic
- Category
- Uploaded By
- Approval Date (NEW)
- Approved By (NEW)
- Actions

#### Status Messages

**New Success Message:**
```
[Success Alert]
Resource deleted successfully!
```

**New Error Messages:**
```
[Danger Alert]
- You are not authorized to perform this action.
- Resource not found.
- Invalid request.
```

#### Empty States

**Requests tab:**
```
[Check-circle icon]
All caught up!
No pending requests to review at the moment.
```

**Approved tab:**
```
[Check-circle icon]
No approved resources
No resources have been approved yet.
```

**Rejected tab:**
```
[Check-circle icon]
No rejected resources
No resources have been rejected yet.
```

**Edit Approvals tab:**
```
[Check-circle icon]
All caught up!
No pending edits to review at the moment.
```

## User Experience Flow

### Student Deleting Own Resource

1. Navigate to My Resources or Topic view
2. Locate resource in table
3. Click trash icon in Actions column
4. Confirm deletion in dialog: "Are you sure you want to delete this resource? This action cannot be undone."
5. Resource deleted, page reloads with success message: "Resource deleted successfully."

### Coordinator Deleting Resource

1. Navigate to Topic view or Resource Detail page
2. See delete button (trash icon or Delete button)
3. Click delete button
4. Confirm deletion in dialog: "Are you sure you want to delete this resource? This action cannot be undone."
5. Resource deleted, redirected with success message

### Coordinator Dashboard

1. Navigate to Subject Coordinator > Resource Approvals
2. Use tabs to switch between Requests, Approved, Rejected, Edit Approvals
3. View resources with appropriate columns for each tab
4. Delete button available on all tabs
5. Approve/Reject buttons only on Requests and Edit Approvals tabs

## Visual Consistency

### Button Patterns
- **View/Preview:** Ghost button with eye icon
- **Download/Open:** Ghost button with download/external-link icon
- **Edit:** Ghost button with edit icon
- **Approve:** Small success button (green) with check icon
- **Reject:** Small danger button (red) with X icon
- **Delete:** 
  - Table views: Ghost button with trash-2 icon
  - Detail page: Small danger button (red) with trash-2 icon and "Delete" text

### Color Scheme
- **Success:** Green (approve actions, success messages)
- **Danger:** Red (reject and delete actions, error messages)
- **Info:** Blue (badges, information)
- **Warning:** Yellow/Orange (pending status badges)
- **Ghost:** Subtle gray (most action buttons)

### Icon Usage (Lucide Icons)
- `trash-2`: Delete action
- `eye`: View/Preview action
- `download`: Download action
- `external-link`: Open external link
- `edit`: Edit action
- `check`: Approve action
- `x`: Reject action
- `clock`: Requests tab
- `check-circle`: Approved tab, empty states
- `x-circle`: Rejected tab
- `file-text`: Resource file icon

## Accessibility
- All buttons have `aria-label` attributes
- Confirmation dialogs for destructive actions
- Clear visual hierarchy
- Consistent button sizing and spacing
- Icon + text labels on primary actions

## Responsive Behavior
- Buttons maintain appropriate size on mobile
- Actions column scrolls horizontally if needed
- Confirmation dialogs are mobile-friendly
- Tab navigation works on small screens
