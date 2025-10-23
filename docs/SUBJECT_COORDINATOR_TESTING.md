# Subject Coordinator Feature - Testing Guide

## Prerequisites

1. Database with the updated schema (subject_coordinators table)
2. Running Tomcat server with the deployed application
3. Moderator account with an assigned community
4. At least 2-3 student accounts in the same community
5. At least 1-2 subjects created in the community

## Test Scenarios

### Scenario 1: View Empty Coordinator List for a Subject

**Steps:**
1. Log in as a moderator
2. Navigate to Subjects page (Grid or List view)
3. Click the "user-plus" icon on any subject card/row
4. Verify you see the empty state message
5. Verify the "Assign First Coordinator" button is visible and centered

**Expected Results:**
- Empty state with icon and message displayed
- "Assign First Coordinator" button visible
- Subject code and name displayed in the page header
- Breadcrumb navigation shows: Moderator / Subjects / Coordinators

### Scenario 2: Assign a Single Coordinator

**Steps:**
1. From the empty coordinator page, click "Assign First Coordinator" (or "Assign New Coordinator")
2. Verify the list of available students is displayed
3. Select one student checkbox
4. Verify the "Assign Selected" button is enabled
5. Click "Assign Selected"
6. Verify redirect back to coordinator list with success message

**Expected Results:**
- Available students displayed in a table with avatars
- Only students who are NOT already coordinators are shown
- Success message: "Coordinator(s) assigned successfully!"
- Selected student now appears in the coordinator list
- Assigned timestamp is displayed

### Scenario 3: Assign Multiple Coordinators

**Steps:**
1. Navigate to a subject's coordinator page
2. Click "Assign New Coordinator"
3. Select multiple students using checkboxes
4. Click "Assign Selected"
5. Verify all selected students are now coordinators

**Expected Results:**
- Multiple students can be selected at once
- All selected students appear in the coordinator list after assignment
- Each has their own row with complete information

### Scenario 4: Use Select All Functionality

**Steps:**
1. Navigate to assign coordinator page
2. Click the "Select all" checkbox in the table header
3. Verify all student checkboxes are checked
4. Uncheck "Select all"
5. Verify all checkboxes are unchecked

**Expected Results:**
- "Select all" checkbox toggles all student checkboxes
- Submit button state updates correctly

### Scenario 5: Prevent Duplicate Coordinator Assignment

**Steps:**
1. Assign a student as coordinator for Subject A
2. Navigate to Subject B's coordinator assignment page
3. Verify the previously assigned student does NOT appear in the available list

**Expected Results:**
- Student assigned to Subject A is filtered out from Subject B's available students
- Only students who are not coordinators for any subject are shown

### Scenario 6: Unassign a Coordinator

**Steps:**
1. Navigate to a subject's coordinator page with existing coordinators
2. Click "Remove" button next to a coordinator
3. Confirm the action in the dialog
4. Verify redirect with success message

**Expected Results:**
- Confirmation dialog appears before removal
- Success message: "Coordinator removed successfully!"
- Coordinator is removed from the list
- Student can now be assigned to another subject

### Scenario 7: View Global Coordinators List

**Steps:**
1. Click "Subject Coordinators" in the moderator sidebar
2. Verify all coordinators across all subjects are displayed

**Expected Results:**
- Table shows all coordinators in the community
- Each row includes subject name and code
- Subject links are clickable and navigate to subject-specific coordinator page
- Academic year and university information displayed

### Scenario 8: Navigate Between Views

**Steps:**
1. From Subjects page, click "user-plus" on Subject A
2. Verify you're on Subject A's coordinator page
3. Click "Subject Coordinators" in sidebar
4. Verify you're on the global coordinator view
5. Click a subject link in the table
6. Verify you're back to that subject's coordinator page

**Expected Results:**
- Navigation between views works correctly
- Breadcrumb navigation updates appropriately
- Active sidebar item highlights correctly

### Scenario 9: Empty Global View

**Steps:**
1. Ensure no coordinators are assigned to any subject
2. Navigate to "Subject Coordinators" from sidebar
3. Verify empty state is displayed

**Expected Results:**
- Empty state message displayed
- "Go to Subjects" button visible
- Clicking button navigates to subjects page

### Scenario 10: UI Consistency Check

**Steps:**
1. Compare coordinator tables with the students page
2. Verify similar styling and layout
3. Check avatar placeholders are present
4. Verify table responsiveness

**Expected Results:**
- Coordinator tables match students table styling
- User avatars displayed consistently
- Academic year and university fields formatted the same way
- Tables have proper spacing and alignment

### Scenario 11: Cancel Assignment

**Steps:**
1. Navigate to assign coordinator page
2. Select one or more students
3. Click "Cancel" button
4. Verify redirect back to coordinator page without changes

**Expected Results:**
- Cancel button navigates back without making changes
- No coordinators are assigned

### Scenario 12: Validation - No Selection

**Steps:**
1. Navigate to assign coordinator page
2. Don't select any students
3. Verify "Assign Selected" button is disabled

**Expected Results:**
- Submit button disabled when no students selected
- Button enables only when at least one student is selected

### Scenario 13: Subject Icons in Grid and List Views

**Steps:**
1. Navigate to Subjects page in Grid view
2. Verify "user-plus" icon appears for each subject
3. Switch to List view
4. Verify "user-plus" icon appears in the actions column

**Expected Results:**
- Icon visible and properly positioned in both views
- Icon tooltip shows "Assign coordinators"
- Icon button works correctly

### Scenario 14: Security - Community Isolation

**Steps:**
1. Create subjects in Community A and Community B
2. Assign coordinators in Community A
3. Log in as moderator of Community B
4. Try to access Community A's coordinator URLs directly

**Expected Results:**
- Moderator can only view/manage coordinators in their own community
- Attempt to access other community's data redirects appropriately

### Scenario 15: Breadcrumb Navigation

**Steps:**
1. Navigate through various coordinator pages
2. Click each breadcrumb link

**Expected Results:**
- Breadcrumbs show correct path at each level
- All breadcrumb links are clickable and navigate correctly
- Current page shown as non-clickable in breadcrumb

## UI Elements to Verify

### Icons
- ✓ `user-plus` icon in subject cards/rows
- ✓ `user-check` icon in sidebar menu
- ✓ `user-minus` icon in remove buttons
- ✓ `users` icon in empty states
- ✓ `arrow-left` icon in back buttons
- ✓ `arrow-right` icon in CTA buttons
- ✓ `eye` icon in view subject buttons

### Colors and Styling
- ✓ Primary button color for assign actions
- ✓ Danger button color for remove actions
- ✓ Ghost button color for cancel/back actions
- ✓ Success alert color (green)
- ✓ Muted text color for metadata

### Responsive Behavior
- ✓ Tables scroll horizontally on small screens
- ✓ Buttons stack appropriately on mobile
- ✓ Cards in grid view adapt to screen size

## Browser Compatibility

Test in the following browsers:
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Edge

## Performance Checks

- [ ] Coordinator list loads quickly (< 1 second)
- [ ] Assignment action completes promptly
- [ ] No console errors in browser
- [ ] No SQL errors in server logs

## Accessibility Checks

- [ ] All buttons have aria-label attributes
- [ ] Tables have proper aria-label
- [ ] Form inputs have proper labels
- [ ] Keyboard navigation works
- [ ] Screen reader compatible

## Known Limitations

1. No search/filter functionality in coordinator lists (planned for future enhancement)
2. No bulk unassign capability (planned for future enhancement)
3. Coordinator role permissions not yet implemented (future enhancement)

## Bug Report Template

If you find issues, report them with:
- **Title**: Brief description
- **Steps to Reproduce**: Numbered steps
- **Expected Result**: What should happen
- **Actual Result**: What actually happened
- **Browser/Environment**: Browser version, OS
- **Screenshots**: If applicable
- **Console Errors**: Any JavaScript/Java errors
