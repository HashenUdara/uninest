# Moderator Student Removal Feature

## Overview
This implementation adds the ability for moderators to remove students from their community and introduces a collapsible sidebar navigation system for better organization of dashboard items.

## Features

### 1. Collapsible Sidebar Navigation
The sidebar now supports accordion-style collapsible menu items, allowing for better organization of related dashboard sections.

**Implementation:**
- Created `nav-group.tag` - A new tag component for collapsible menu groups
- Created `nav-subitem.tag` - A new tag component for nested navigation items
- Added CSS styling for smooth expand/collapse animations
- Added JavaScript event handlers for interactive accordion behavior
- Updated `moderator-dashboard.tag` to use the new navigation structure

**Structure:**
```
Overview (single item)
Student Management ▼ (collapsible group)
  ├─ Join Requests (sub-item)
  └─ Students (sub-item)
Content Review (single item)
Reported Content (single item)
Activity Logs (single item)
Settings (single item)
```

### 2. Student Management Page
A new page at `/moderator/students` allows moderators to view and manage students in their community.

**Features:**
- Lists all students assigned to the moderator's community
- Displays student information: name, email, academic year, university
- Each student has a "Remove" action button
- Confirmation modal prevents accidental removals
- Success message displays after successful removal

**User Flow:**
1. Moderator navigates to Dashboard → Student Management → Students
2. View list of all students in their community
3. Click "Remove" button next to a student
4. Confirmation modal appears with warning
5. Click "Confirm" to proceed
6. Student is removed from community
7. Success message displays
8. Page refreshes with updated list

### 3. Student Removal Functionality
When a student is removed from a community:
- The student's `community_id` is set to NULL in the users table
- All join requests associated with that student are deleted from the `community_join_requests` table
- The student can submit a new join request to rejoin the community

## Technical Implementation

### New Servlets
1. **ModeratorStudentsServlet** (`/moderator/students`)
   - Handles GET requests to display students list
   - Filters students by moderator's community
   - Requires moderator to have a community assigned

2. **RemoveStudentServlet** (`/moderator/students/remove`)
   - Handles POST requests to remove students
   - Verifies student belongs to moderator's community
   - Executes removal in transaction (delete join requests + nullify community)

### DAO Methods Added

**UserDAO.java:**
- `removeCommunity(int userId)` - Sets community_id to NULL
- `findByCommunityId(int communityId)` - Returns all students in a community

**JoinRequestDAO.java:**
- `deleteByUserId(int userId)` - Deletes all join requests for a user

### Frontend Components

**Tag Files:**
- `/WEB-INF/tags/dashboard/nav-group.tag` - Collapsible navigation group
- `/WEB-INF/tags/dashboard/nav-subitem.tag` - Sub-navigation item

**Views:**
- `/WEB-INF/views/moderator/students.jsp` - Student management page

**CSS (dashboard.css):**
```css
.c-nav-group - Container for collapsible nav groups
.c-nav-group__trigger - Clickable button to toggle group
.c-nav-group__icon - Chevron icon that rotates on toggle
.c-nav-group__content - Container for sub-items
.c-nav__subitem - Individual sub-navigation links
```

**JavaScript (dashboard.js):**
- `initNavGroups()` - Initializes click handlers for collapsible groups
- `initStudentConfirm()` - Handles confirmation modal for student removal

## Security & Data Integrity

### Security Measures
- ✅ Session-based authentication required
- ✅ Verification that student belongs to moderator's community
- ✅ POST requests for mutations (CSRF protection)
- ✅ SQL injection prevention via PreparedStatements

### Data Consistency
- All join requests are deleted before removing community assignment
- Transactional integrity maintained through proper error handling
- Student record remains in database (only community assignment is removed)

## UI Consistency
The implementation maintains consistency with existing dashboard pages:
- ✅ Reuses dashboard layout components
- ✅ Matches table styling from other pages
- ✅ Uses existing alert component for feedback
- ✅ Follows confirmation modal pattern
- ✅ Auto-generated user avatars with color coding

## Files Modified

### New Files
- `src/main/java/com/uninest/controller/moderator/ModeratorStudentsServlet.java`
- `src/main/java/com/uninest/controller/moderator/RemoveStudentServlet.java`
- `src/main/webapp/WEB-INF/tags/dashboard/nav-group.tag`
- `src/main/webapp/WEB-INF/tags/dashboard/nav-subitem.tag`
- `src/main/webapp/WEB-INF/views/moderator/students.jsp`

### Modified Files
- `src/main/java/com/uninest/model/dao/UserDAO.java`
- `src/main/java/com/uninest/model/dao/JoinRequestDAO.java`
- `src/main/webapp/WEB-INF/tags/layouts/moderator-dashboard.tag`
- `src/main/webapp/static/dashboard.css`
- `src/main/webapp/static/dashboard.js`

## Testing

### Manual Testing Steps
1. **Test Collapsible Navigation:**
   - Navigate to moderator dashboard
   - Click "Student Management" in sidebar
   - Verify sub-items expand/collapse
   - Verify chevron icon rotates

2. **Test Student List:**
   - Navigate to Students page
   - Verify all students in community are displayed
   - Verify table shows correct information

3. **Test Student Removal:**
   - Click "Remove" button for a student
   - Verify confirmation modal appears
   - Click "Confirm"
   - Verify success message displays
   - Verify student no longer appears in list
   - Verify student's community_id is NULL in database
   - Verify join requests are deleted

### Edge Cases Covered
- ✅ Moderator without community assignment (redirects to dashboard)
- ✅ Attempt to remove student from different community (denied)
- ✅ Invalid student ID (safe redirect)
- ✅ Empty student list (displays properly)

## Future Enhancements
- Add search/filter functionality for student list
- Add pagination for large student lists
- Add bulk removal functionality
- Add student details view
- Add activity log for removal actions
- Add email notification to removed students

## Accessibility
- ARIA attributes for screen readers (`aria-expanded`, `aria-label`)
- Keyboard navigation support
- Focus management in modals
- Semantic HTML structure

## Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- CSS uses standard properties
- JavaScript uses ES5-compatible syntax
- Graceful degradation for older browsers
