# Resource Edit and Delete Feature - Testing Guide

## Overview
This guide covers testing the new edit and delete functionality for student resources in the Uninest application.

## Features Implemented

### 1. Resource Editing
- **URL**: `/student/resources/edit?id={resourceId}`
- **Method**: GET (display form), POST (save changes)
- **Access Control**: Only resource owner can edit
- **Key Behaviors**:
  - Students can edit any of their uploaded resources
  - If a resource is already approved, editing it resets status to "pending"
  - Users can choose to keep existing file, upload new file, or use a new link
  - UI matches the upload resource form for consistency

### 2. Resource Deletion
- **URL**: `/student/resources/delete`
- **Method**: POST
- **Access Control**: Only resource owner can delete
- **Key Behaviors**:
  - Permanently removes resource from database
  - Confirmation dialog before deletion
  - Resource disappears from all listings after deletion

## Test Scenarios

### A. Edit Resource - Basic Flow

#### Test Case 1: Edit Pending Resource
1. **Setup**: Have a resource with status "pending"
2. **Steps**:
   - Go to "My Resources"
   - Click edit button on a pending resource
   - Modify title, description, or category
   - Click "Save Changes"
3. **Expected Result**:
   - Form displays with current resource data pre-filled
   - Changes are saved successfully
   - Status remains "pending"
   - Success message displays: "Resource updated successfully!"
   - User redirected to "My Resources"

#### Test Case 2: Edit Approved Resource
1. **Setup**: Have a resource with status "approved"
2. **Steps**:
   - Go to "My Resources"
   - Click edit button on an approved resource
   - Notice warning message about status reset
   - Modify any field
   - Click "Save Changes"
3. **Expected Result**:
   - Warning displays: "This resource is currently approved. Editing it will reset its status to 'pending'..."
   - Changes are saved successfully
   - Status changes from "approved" to "pending"
   - Visibility changes from "public" to "private"
   - Resource no longer appears in topic-specific public views
   - Success message displays

#### Test Case 3: Edit with File Replacement
1. **Setup**: Have an existing resource with a file
2. **Steps**:
   - Click edit button
   - Select "Upload new file" tab
   - Choose a new file
   - Click "Save Changes"
3. **Expected Result**:
   - Old file URL is replaced with new file URL
   - File type is updated accordingly
   - Other metadata remains unchanged

#### Test Case 4: Edit with Link Replacement
1. **Setup**: Have an existing resource with a file
2. **Steps**:
   - Click edit button
   - Select "Use new link" tab
   - Enter a valid URL
   - Click "Save Changes"
3. **Expected Result**:
   - File URL is replaced with link URL
   - File type changes to "link"
   - Other metadata remains unchanged

#### Test Case 5: Keep Existing File
1. **Setup**: Have an existing resource
2. **Steps**:
   - Click edit button
   - Keep "Keep existing file" tab selected (default)
   - Modify only title and description
   - Click "Save Changes"
3. **Expected Result**:
   - Title and description updated
   - File URL and type remain unchanged
   - Other metadata remains unchanged

### B. Delete Resource

#### Test Case 6: Delete from My Resources Table
1. **Setup**: Have multiple resources in "My Resources"
2. **Steps**:
   - Click delete button (trash icon) on a resource
   - See confirmation dialog
   - Click "OK" to confirm
3. **Expected Result**:
   - Confirmation prompt: "Are you sure you want to delete this resource? This action cannot be undone."
   - Resource is permanently deleted from database
   - Success message: "Resource deleted successfully."
   - Resource no longer appears in any listings
   - User redirected to "My Resources"

#### Test Case 7: Delete from Resource Detail Page
1. **Setup**: View a resource detail page that you own
2. **Steps**:
   - Click "Delete" button in action bar
   - See confirmation dialog
   - Click "OK" to confirm
3. **Expected Result**:
   - Confirmation prompt appears
   - Resource is deleted
   - User redirected to "My Resources" with success message

#### Test Case 8: Cancel Delete Operation
1. **Steps**:
   - Click delete button
   - See confirmation dialog
   - Click "Cancel"
3. **Expected Result**:
   - No changes made
   - Resource still exists
   - User remains on same page

### C. Access Control Tests

#### Test Case 9: Edit Another User's Resource
1. **Setup**: Try to access edit URL for a resource uploaded by another user
2. **Steps**:
   - Manually navigate to `/student/resources/edit?id={otherUserResourceId}`
3. **Expected Result**:
   - HTTP 403 Forbidden error
   - Error message: "You can only edit your own resources"

#### Test Case 10: Delete Another User's Resource
1. **Setup**: Try to delete a resource uploaded by another user
2. **Steps**:
   - Try to POST to `/student/resources/delete?id={otherUserResourceId}`
3. **Expected Result**:
   - HTTP 403 Forbidden error
   - Error message: "You can only delete your own resources"

### D. UI/UX Tests

#### Test Case 11: Edit Button Visibility
1. **Context**: My Resources view (topic == null)
2. **Expected**: Edit and Delete buttons visible for all owned resources
3. **Context**: Topic-specific view (topic != null)
4. **Expected**: Edit and Delete buttons NOT visible (only view/download)

#### Test Case 12: Resource Detail Page Buttons
1. **Context**: Viewing own resource
2. **Expected**: Edit and Delete buttons visible in action bar
3. **Context**: Viewing another user's resource
4. **Expected**: Edit and Delete buttons NOT visible

#### Test Case 13: Form Layout Consistency
1. **Compare**: Upload form vs Edit form
2. **Expected**:
   - Same styling and layout
   - Same field labels and placeholders
   - Same tabs for file upload methods
   - Same validation behavior

### E. Validation Tests

#### Test Case 14: Edit with Empty Required Fields
1. **Steps**:
   - Open edit form
   - Clear title field
   - Try to submit
3. **Expected Result**:
   - HTML5 validation prevents submission
   - Error message: "Title is required"

#### Test Case 15: Edit with Invalid Topic Selection
1. **Steps**:
   - Open edit form
   - Select a topic from a different community (if possible)
   - Try to submit
3. **Expected Result**:
   - Error handling prevents submission
   - User can only select topics from their community

### F. Edge Cases

#### Test Case 16: Edit Non-Existent Resource
1. **Steps**:
   - Navigate to `/student/resources/edit?id=999999`
3. **Expected Result**:
   - HTTP 404 Not Found error
   - Error message: "Resource not found"

#### Test Case 17: Delete Non-Existent Resource
1. **Steps**:
   - POST to `/student/resources/delete?id=999999`
3. **Expected Result**:
   - HTTP 404 Not Found error
   - Error message: "Resource not found"

#### Test Case 18: Edit Without Resource ID
1. **Steps**:
   - Navigate to `/student/resources/edit` (no id parameter)
3. **Expected Result**:
   - HTTP 400 Bad Request error
   - Error message: "Resource ID is required"

## Integration Tests

### Test Case 19: Complete Edit-Approve Workflow
1. Create a new resource (status: pending)
2. Edit the resource before approval
3. Coordinator approves the resource (status: approved)
4. Edit the resource again
5. **Expected**: Status resets to pending, requires re-approval

### Test Case 20: Delete After Approval
1. Upload a resource
2. Wait for coordinator approval
3. Delete the approved resource
4. **Expected**: Resource is deleted, no longer visible in topic views

## Performance Considerations

### Test Case 21: Large File Edit
1. Edit a resource with a large file (40+ MB)
2. Keep existing file
3. **Expected**: Edit completes quickly (no file re-upload)

### Test Case 22: Concurrent Edits
1. Two users edit their own resources simultaneously
2. **Expected**: Both operations succeed independently

## Browser Compatibility

Test all scenarios in:
- [ ] Chrome/Edge (Chromium)
- [ ] Firefox
- [ ] Safari
- [ ] Mobile browsers (Chrome Android, Safari iOS)

## Accessibility

- [ ] Keyboard navigation works for edit/delete buttons
- [ ] Screen readers announce edit/delete actions properly
- [ ] Confirmation dialog accessible via keyboard
- [ ] ARIA labels present on icon buttons

## Summary Checklist

Backend:
- [x] ResourceDAO.update() method implemented
- [x] EditResourceServlet authorization checks
- [x] DeleteResourceServlet authorization checks
- [x] Status reset logic for approved resources
- [x] File handling (keep/replace/link)

Frontend:
- [x] Edit form matches upload form styling
- [x] Edit/Delete buttons in My Resources table
- [x] Edit/Delete buttons in resource detail page
- [x] Delete confirmation dialog
- [x] Success/error messages
- [x] Proper button visibility based on context

Security:
- [x] Only resource owner can edit
- [x] Only resource owner can delete
- [x] Authorization checks on all endpoints
- [x] CSRF protection via POST method for delete

User Experience:
- [x] Warning message for editing approved resources
- [x] Confirmation before deletion
- [x] Clear success messages
- [x] Consistent UI across forms
