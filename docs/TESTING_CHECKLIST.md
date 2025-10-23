# Subject & Topic Management - Testing Checklist

## Pre-Testing Setup

### Database Setup
- [ ] Run `db.sql` migration script to create tables
- [ ] Verify subjects table exists with 12 demo records
- [ ] Verify topics table exists with 20 demo records
- [ ] Verify foreign key constraints are in place

### Login Credentials
Use the following test credentials:
- **Moderator 1**: m1@abc.com / password123 (Community 1)
- **Moderator 2**: m2@abc.com / password123 (Community 1)
- **Moderator 3**: m3@abc.com / password123 (Community 2)

## Test Cases

### 1. Subject Management - Grid View

#### TC-SUB-001: View Subjects in Grid Mode
- [ ] Login as moderator (m1@abc.com)
- [ ] Navigate to `/moderator/subjects`
- [ ] Verify subjects are displayed as cards
- [ ] Verify subjects are grouped by semester
- [ ] Verify each card shows: code, name, status, academic year, semester
- [ ] Verify color-coded subject thumbnails display correctly
- [ ] Verify only subjects from moderator's community are shown

#### TC-SUB-002: Click on Subject Card
- [ ] Click on a subject card title
- [ ] Verify redirect to topics page with correct subjectId
- [ ] Verify topics for that subject are displayed

#### TC-SUB-003: View Switch to List
- [ ] From subjects grid view
- [ ] Click "List" button in view switcher
- [ ] Verify redirect to list view
- [ ] Verify same subjects are shown in table format

### 2. Subject Management - List View

#### TC-SUB-004: View Subjects in List Mode
- [ ] Navigate to `/moderator/subjects?view=list`
- [ ] Verify subjects are displayed in a table
- [ ] Verify table columns: Name, Description, Code, Year, Semester, Status, Actions
- [ ] Verify subject count is displayed correctly
- [ ] Verify "List" button is highlighted in view switcher

#### TC-SUB-005: Sort Subjects
- [ ] Click on "Name" column header
- [ ] Verify subjects sort in ascending order
- [ ] Click again to verify descending order
- [ ] Repeat for Code, Academic Year, Semester, Status columns
- [ ] Verify aria-sort attributes update correctly

#### TC-SUB-006: Click on Subject Row
- [ ] Click on a subject row
- [ ] Verify redirect to topics page with correct subjectId

#### TC-SUB-007: View Switch to Grid
- [ ] From subjects list view
- [ ] Click "Grid" button in view switcher
- [ ] Verify redirect to grid view
- [ ] Verify same subjects are shown in card format

### 3. Subject Creation

#### TC-SUB-008: Access Create Form
- [ ] From subjects page, click "+ Create Subject" button
- [ ] Verify redirect to `/moderator/subjects/create`
- [ ] Verify form displays with all required fields
- [ ] Verify breadcrumb shows: Moderator / Subjects / Create Subject

#### TC-SUB-009: Create Valid Subject
- [ ] Fill in subject details:
  - Name: "Software Engineering"
  - Code: "CS301"
  - Description: "SDLC and design patterns"
  - Academic Year: 3
  - Semester: 1
  - Status: upcoming
- [ ] Submit form
- [ ] Verify redirect to `/moderator/subjects?success=created`
- [ ] Verify success alert is displayed
- [ ] Verify new subject appears in the list

#### TC-SUB-010: Create Subject - Validation
- [ ] Access create form
- [ ] Leave Name field empty
- [ ] Submit form
- [ ] Verify validation error is shown
- [ ] Verify form is not submitted

#### TC-SUB-011: Cancel Subject Creation
- [ ] Access create form
- [ ] Fill in some fields
- [ ] Click "Cancel" button
- [ ] Verify redirect back to subjects page
- [ ] Verify no new subject was created

### 4. Subject Editing

#### TC-SUB-012: Access Edit Form
- [ ] From subjects page, click pencil icon on a subject
- [ ] Verify redirect to `/moderator/subjects/edit?id={id}`
- [ ] Verify form is pre-filled with current values
- [ ] Verify breadcrumb shows: Moderator / Subjects / Edit Subject

#### TC-SUB-013: Edit Subject Successfully
- [ ] Access edit form for a subject
- [ ] Change name to "Advanced Data Structures"
- [ ] Change status to "ongoing"
- [ ] Submit form
- [ ] Verify redirect to `/moderator/subjects?success=updated`
- [ ] Verify success alert is displayed
- [ ] Verify subject shows updated values

#### TC-SUB-014: Edit Subject - Validation
- [ ] Access edit form
- [ ] Clear the Name field
- [ ] Submit form
- [ ] Verify validation error is shown
- [ ] Verify subject is not updated

#### TC-SUB-015: Edit Another Community's Subject
- [ ] Try to access `/moderator/subjects/edit?id={other_community_subject_id}`
- [ ] Verify redirect with error
- [ ] Verify access is denied

### 5. Subject Deletion

#### TC-SUB-016: Delete Subject with Confirmation
- [ ] From subjects page, click trash icon on a subject
- [ ] Verify confirmation dialog appears
- [ ] Click "Cancel" in confirmation
- [ ] Verify subject is not deleted

#### TC-SUB-017: Delete Subject Successfully
- [ ] From subjects page, click trash icon on a subject
- [ ] Verify confirmation dialog appears
- [ ] Click "OK" to confirm
- [ ] Verify redirect to `/moderator/subjects?success=deleted`
- [ ] Verify success alert is displayed
- [ ] Verify subject no longer appears in list

#### TC-SUB-018: Verify Cascade Delete
- [ ] Create a subject with topics
- [ ] Delete the subject
- [ ] Verify all topics for that subject are also deleted
- [ ] Access `/moderator/topics?subjectId={deleted_id}`
- [ ] Verify redirect or error

### 6. Topic Management - Grid View

#### TC-TOP-001: View Topics in Grid Mode
- [ ] From subjects page, click on a subject
- [ ] Verify redirect to `/moderator/topics?subjectId={id}`
- [ ] Verify topics are displayed as cards
- [ ] Verify subject name is shown in header
- [ ] Verify breadcrumb shows: Moderator / Subjects / {SubjectName}

#### TC-TOP-002: Empty Topics List
- [ ] Access a subject with no topics
- [ ] Verify "No topics found" message is displayed
- [ ] Verify "+ Create Topic" button is visible

#### TC-TOP-003: View Switch to List
- [ ] From topics grid view
- [ ] Click "List" button in view switcher
- [ ] Verify redirect to list view with subjectId maintained
- [ ] Verify same topics are shown in table format

### 7. Topic Management - List View

#### TC-TOP-004: View Topics in List Mode
- [ ] Navigate to `/moderator/topics?subjectId={id}&view=list`
- [ ] Verify topics are displayed in a table
- [ ] Verify table columns: Title, Description, Actions
- [ ] Verify topic count is displayed correctly
- [ ] Verify subjectId is maintained in URL

#### TC-TOP-005: Sort Topics
- [ ] Click on "Title" column header
- [ ] Verify topics sort in ascending order
- [ ] Click again to verify descending order

#### TC-TOP-006: View Switch to Grid
- [ ] From topics list view
- [ ] Click "Grid" button in view switcher
- [ ] Verify redirect to grid view
- [ ] Verify subjectId is maintained

### 8. Topic Creation

#### TC-TOP-007: Access Create Form
- [ ] From topics page, click "+ Create Topic" button
- [ ] Verify redirect to `/moderator/topics/create?subjectId={id}`
- [ ] Verify form displays with required fields
- [ ] Verify subject name is shown in breadcrumb

#### TC-TOP-008: Create Valid Topic
- [ ] Fill in topic details:
  - Title: "Binary Search Trees"
  - Description: "Implementation and operations"
- [ ] Submit form
- [ ] Verify redirect to `/moderator/topics?subjectId={id}&success=created`
- [ ] Verify success alert is displayed
- [ ] Verify new topic appears in the list

#### TC-TOP-009: Create Topic - Validation
- [ ] Access create form
- [ ] Leave Title field empty
- [ ] Submit form
- [ ] Verify validation error is shown

#### TC-TOP-010: Cancel Topic Creation
- [ ] Access create form
- [ ] Fill in some fields
- [ ] Click "Cancel" button
- [ ] Verify redirect back to topics page with subjectId
- [ ] Verify no new topic was created

### 9. Topic Editing

#### TC-TOP-011: Access Edit Form
- [ ] From topics page, click pencil icon on a topic
- [ ] Verify redirect to `/moderator/topics/edit?id={tid}&subjectId={sid}`
- [ ] Verify form is pre-filled with current values
- [ ] Verify breadcrumb includes subject name

#### TC-TOP-012: Edit Topic Successfully
- [ ] Access edit form for a topic
- [ ] Change title to "Advanced Binary Search Trees"
- [ ] Update description
- [ ] Submit form
- [ ] Verify redirect to topics page with success message
- [ ] Verify topic shows updated values

#### TC-TOP-013: Edit Topic - Validation
- [ ] Access edit form
- [ ] Clear the Title field
- [ ] Submit form
- [ ] Verify validation error is shown

### 10. Topic Deletion

#### TC-TOP-014: Delete Topic with Confirmation
- [ ] From topics page, click trash icon on a topic
- [ ] Verify confirmation dialog appears
- [ ] Click "Cancel" in confirmation
- [ ] Verify topic is not deleted

#### TC-TOP-015: Delete Topic Successfully
- [ ] From topics page, click trash icon on a topic
- [ ] Verify confirmation dialog appears
- [ ] Click "OK" to confirm
- [ ] Verify redirect with success message
- [ ] Verify subjectId is maintained in redirect
- [ ] Verify topic no longer appears in list

### 11. Navigation & UI

#### TC-NAV-001: Sidebar Navigation
- [ ] From moderator dashboard
- [ ] Verify "Subjects" link is present in sidebar
- [ ] Click "Subjects" link
- [ ] Verify navigation to subjects page
- [ ] Verify "Subjects" is highlighted in sidebar

#### TC-NAV-002: Breadcrumb Navigation
- [ ] Navigate to topics page
- [ ] Click "Subjects" in breadcrumb
- [ ] Verify return to subjects page
- [ ] Click "Moderator" in breadcrumb
- [ ] Verify return to dashboard

#### TC-NAV-003: Back Button Navigation
- [ ] Navigate through: Subjects → Topics → Create Topic
- [ ] Use browser back button
- [ ] Verify navigation works correctly
- [ ] Verify subjectId is maintained where needed

#### TC-NAV-004: View Switcher State
- [ ] Navigate to subjects list view
- [ ] Verify "List" button is active
- [ ] Navigate to grid view
- [ ] Verify "Grid" button is active
- [ ] Repeat for topics views

### 12. Authorization & Security

#### TC-SEC-001: Moderator Without Community
- [ ] Login as a moderator without community_id
- [ ] Try to access `/moderator/subjects`
- [ ] Verify redirect to dashboard
- [ ] Verify access is denied

#### TC-SEC-002: Cross-Community Access - Subjects
- [ ] Login as moderator from Community 1
- [ ] Try to edit a subject from Community 2
- [ ] Verify access is denied
- [ ] Verify redirect with error

#### TC-SEC-003: Cross-Community Access - Topics
- [ ] Login as moderator from Community 1
- [ ] Try to access topics for subject in Community 2
- [ ] Verify access is denied
- [ ] Verify redirect with error

#### TC-SEC-004: Non-Moderator Access
- [ ] Login as a student (s1@abc.com)
- [ ] Try to access `/moderator/subjects`
- [ ] Verify access is denied
- [ ] Verify appropriate redirect

#### TC-SEC-005: Unauthenticated Access
- [ ] Logout
- [ ] Try to access `/moderator/subjects`
- [ ] Verify redirect to login page

### 13. Error Handling

#### TC-ERR-001: Invalid Subject ID
- [ ] Try to access `/moderator/subjects/edit?id=99999`
- [ ] Verify error handling
- [ ] Verify redirect with error message

#### TC-ERR-002: Invalid Topic ID
- [ ] Try to access `/moderator/topics/edit?id=99999&subjectId=1`
- [ ] Verify error handling
- [ ] Verify redirect with error message

#### TC-ERR-003: Missing Required Parameters
- [ ] Try to access `/moderator/topics` (no subjectId)
- [ ] Verify redirect to subjects page
- [ ] Try to access `/moderator/topics/create` (no subjectId)
- [ ] Verify redirect to subjects page

### 14. Data Integrity

#### TC-DATA-001: Verify Demo Data
- [ ] Login as moderator for Community 1
- [ ] Verify 3 subjects are visible (CS204, CS205, CS301)
- [ ] Navigate to CS204 topics
- [ ] Verify 4 topics are visible

#### TC-DATA-002: Community Isolation
- [ ] Login as moderator for Community 1
- [ ] Count subjects visible
- [ ] Login as moderator for Community 2
- [ ] Count subjects visible
- [ ] Verify counts are different
- [ ] Verify no overlap in subjects

### 15. Visual/UI Testing

#### TC-UI-001: Responsive Design
- [ ] Resize browser window
- [ ] Verify layouts adjust appropriately
- [ ] Test on mobile viewport
- [ ] Verify forms are usable

#### TC-UI-002: Status Badges
- [ ] Verify "upcoming" status shows in blue
- [ ] Verify "ongoing" status shows in green
- [ ] Verify "completed" status shows in gray

#### TC-UI-003: Subject Thumbnails
- [ ] In grid view, verify each subject card has colored thumbnail
- [ ] Verify subject code is displayed in thumbnail
- [ ] Verify colors are consistent for same subject code

#### TC-UI-004: Icons Rendering
- [ ] Verify all Lucide icons render correctly
- [ ] Check: plus, pencil, trash, folder, grid, list icons
- [ ] Verify icons in buttons and navigation

#### TC-UI-005: Alert Messages
- [ ] Trigger success alert (create subject)
- [ ] Verify green success alert displays
- [ ] Verify check-circle icon is present
- [ ] Trigger error (access denied)
- [ ] Verify red error alert displays

### 16. Performance Testing

#### TC-PERF-001: Large Dataset
- [ ] Create 50+ subjects in a community
- [ ] Verify grid view loads in reasonable time
- [ ] Verify list view loads in reasonable time
- [ ] Verify sorting works correctly

#### TC-PERF-002: Topic Loading
- [ ] Create 100+ topics for a subject
- [ ] Verify topics page loads in reasonable time
- [ ] Verify both views perform acceptably

## Test Environment Requirements

- [ ] Java 8 or higher installed
- [ ] Apache Tomcat 11 or compatible
- [ ] MySQL database running
- [ ] Database schema migrated (db.sql)
- [ ] Application deployed (uninest.war)

## Test Data Setup

### Subjects to Create for Testing
1. Name: "Machine Learning", Code: "CS401", Year: 4, Semester: 1, Status: upcoming
2. Name: "Web Development", Code: "CS302", Year: 3, Semester: 2, Status: ongoing
3. Name: "Mobile Apps", Code: "CS303", Year: 3, Semester: 2, Status: completed

### Topics to Create for Testing
For each subject above, create 3-5 topics with varied descriptions.

## Bug Tracking

For each failed test case, document:
- Test Case ID
- Expected Result
- Actual Result
- Steps to Reproduce
- Screenshots (if applicable)
- Severity (Critical/High/Medium/Low)

## Sign-off

- [ ] All test cases passed
- [ ] No critical bugs found
- [ ] Performance is acceptable
- [ ] UI is consistent across browsers
- [ ] Documentation is accurate

**Tester Name**: _________________
**Date**: _________________
**Sign-off**: _________________
