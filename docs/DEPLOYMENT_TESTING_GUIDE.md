# Deployment and Testing Guide

## Files Modified/Created

### Java Backend Files
**New Controller Files (8):**
- `src/main/java/com/uninest/controller/admin/StudentsServlet.java`
- `src/main/java/com/uninest/controller/admin/AddStudentServlet.java`
- `src/main/java/com/uninest/controller/admin/EditStudentServlet.java`
- `src/main/java/com/uninest/controller/admin/DeleteStudentServlet.java`
- `src/main/java/com/uninest/controller/admin/ModeratorsServlet.java`
- `src/main/java/com/uninest/controller/admin/AddModeratorServlet.java`
- `src/main/java/com/uninest/controller/admin/EditModeratorServlet.java`
- `src/main/java/com/uninest/controller/admin/DeleteModeratorServlet.java`

**Modified DAO Files (1):**
- `src/main/java/com/uninest/model/dao/UserDAO.java`
  - Added `findByRole()` method
  - Added `searchUsers()` method
  - Added `findById()` method
  - Added `update()` method
  - Added `deleteUser()` method
  - Enhanced all queries with LEFT JOIN for community names

**Modified Model Files (1):**
- `src/main/java/com/uninest/model/User.java`
  - Added `communityName` field for display

### Frontend Files
**New JSP View Files (6):**
- `src/main/webapp/WEB-INF/views/admin/students.jsp`
- `src/main/webapp/WEB-INF/views/admin/add-student.jsp`
- `src/main/webapp/WEB-INF/views/admin/edit-student.jsp`
- `src/main/webapp/WEB-INF/views/admin/moderators.jsp`
- `src/main/webapp/WEB-INF/views/admin/add-moderator.jsp`
- `src/main/webapp/WEB-INF/views/admin/edit-moderator.jsp`

**Modified Layout/Style Files (2):**
- `src/main/webapp/WEB-INF/tags/layouts/admin-dashboard.tag`
  - Updated navigation to include Students and Moderators links
- `src/main/webapp/static/dashboard.css`
  - Added `.c-alert` component styles
  - Added utility classes (`.u-text-center`, `.u-text-right`, `.u-clamp-2`)

### Documentation Files (2)
- `STUDENT_MODERATOR_MANAGEMENT.md` - Implementation documentation
- `DEPLOYMENT_TESTING_GUIDE.md` - This file

## Build Instructions

```bash
cd /path/to/uninest
mvn clean package
```

The WAR file will be created at: `target/uninest-1.0-SNAPSHOT.war`

## Deployment Steps

### Option 1: Tomcat Deployment
1. Build the WAR file using Maven
2. Copy `target/uninest-1.0-SNAPSHOT.war` to Tomcat's webapps directory
3. Restart Tomcat
4. Access the application at `http://localhost:8080/uninest-1.0-SNAPSHOT/`

### Option 2: Deploy to Existing Server
If already deployed, simply:
1. Build the project: `mvn clean package`
2. Replace the existing WAR on the server
3. Restart the application server

## Testing Checklist

### Prerequisites
- Login as an admin user
- Ensure database has the `users`, `roles`, and `communities` tables
- Verify admin role has access to admin dashboard

### Students Management Testing

#### 1. View Students List
- [ ] Navigate to Admin Dashboard → Students
- [ ] Verify students table displays with columns: Student, Email, Academic Year, University, Community, Actions
- [ ] Verify student count displays correctly
- [ ] Verify empty state shows "No students found" if no data

#### 2. Add New Student
- [ ] Click "Add Student" button
- [ ] Fill in required fields: email, password
- [ ] Optionally select academic year (1-4)
- [ ] Optionally enter university name
- [ ] Optionally select community
- [ ] Click "Add Student"
- [ ] Verify redirect to students list with success message
- [ ] Verify new student appears in the table

#### 3. Edit Student
- [ ] Click pencil icon next to a student
- [ ] Verify form pre-populates with student data
- [ ] Modify email, academic year, university, or community
- [ ] Click "Update Student"
- [ ] Verify redirect to students list with success message
- [ ] Verify changes are reflected in the table

#### 4. Delete Student
- [ ] Click trash icon next to a student
- [ ] Verify confirmation modal appears
- [ ] Click "Cancel" - modal should close, student should remain
- [ ] Click trash icon again
- [ ] Click "Delete" in modal
- [ ] Verify redirect to students list with success message
- [ ] Verify student is removed from the table

#### 5. Search Students
- [ ] Enter search term in search box (e.g., "university" or "email")
- [ ] Click "Search" button
- [ ] Verify filtered results display
- [ ] Click "Clear" button
- [ ] Verify all students display again

### Moderators Management Testing

#### 1. View Moderators List
- [ ] Navigate to Admin Dashboard → Moderators
- [ ] Verify moderators table displays with columns: Moderator, Email, University, Community, Actions
- [ ] Verify moderator count displays correctly
- [ ] Verify empty state shows "No moderators found" if no data

#### 2. Add New Moderator
- [ ] Click "Add Moderator" button
- [ ] Fill in required fields: email, password
- [ ] Optionally enter university name
- [ ] Optionally select community
- [ ] Click "Add Moderator"
- [ ] Verify redirect to moderators list with success message
- [ ] Verify new moderator appears in the table

#### 3. Edit Moderator
- [ ] Click pencil icon next to a moderator
- [ ] Verify form pre-populates with moderator data
- [ ] Modify email, university, or community
- [ ] Click "Update Moderator"
- [ ] Verify redirect to moderators list with success message
- [ ] Verify changes are reflected in the table

#### 4. Delete Moderator
- [ ] Click trash icon next to a moderator
- [ ] Verify confirmation modal appears
- [ ] Click "Cancel" - modal should close, moderator should remain
- [ ] Click trash icon again
- [ ] Click "Delete" in modal
- [ ] Verify redirect to moderators list with success message
- [ ] Verify moderator is removed from the table

#### 5. Search Moderators
- [ ] Enter search term in search box (e.g., "university" or "email")
- [ ] Click "Search" button
- [ ] Verify filtered results display
- [ ] Click "Clear" button
- [ ] Verify all moderators display again

### UI/UX Testing

#### Navigation
- [ ] Verify "Students" link appears in admin sidebar
- [ ] Verify "Moderators" link appears in admin sidebar
- [ ] Verify both links are styled consistently with other nav items
- [ ] Verify active state highlights correctly when on each page

#### Layout and Styling
- [ ] Verify breadcrumbs display correctly on all pages
- [ ] Verify page titles and subtitles are appropriate
- [ ] Verify buttons use consistent styling (primary, secondary, ghost, danger)
- [ ] Verify forms have proper spacing and alignment
- [ ] Verify tables are responsive and scrollable on smaller screens
- [ ] Verify modal dialogs center correctly
- [ ] Verify alert messages display with appropriate colors

#### Accessibility
- [ ] Verify all form fields have associated labels
- [ ] Verify buttons have appropriate aria-labels
- [ ] Verify keyboard navigation works for forms and modals
- [ ] Verify screen reader announcements for success/error messages

### Error Handling Testing

#### Form Validation
- [ ] Try submitting add student form with empty email - should show browser validation
- [ ] Try submitting add student form with empty password - should show browser validation
- [ ] Try submitting with invalid email format - should show browser validation

#### Edge Cases
- [ ] Try editing a non-existent user ID - should redirect safely
- [ ] Try deleting a non-existent user ID - should handle gracefully
- [ ] Try searching with special characters - should not break
- [ ] Try accessing pages without admin privileges - should be blocked by AuthFilter

### Database Verification

After performing CRUD operations, verify database state:

```sql
-- Check students
SELECT u.id, u.email, u.academic_year, u.university, c.title as community_name
FROM users u
LEFT JOIN roles r ON u.role_id = r.id
LEFT JOIN communities c ON u.community_id = c.id
WHERE r.name = 'student'
ORDER BY u.id DESC;

-- Check moderators
SELECT u.id, u.email, u.university, c.title as community_name
FROM users u
LEFT JOIN roles r ON u.role_id = r.id
LEFT JOIN communities c ON u.community_id = c.id
WHERE r.name = 'moderator'
ORDER BY u.id DESC;
```

## Known Limitations

1. **No Pagination**: Large datasets will load all records at once. Consider adding pagination for production use.
2. **No Bulk Operations**: Users must be deleted one at a time.
3. **Password Change**: Editing a user does not allow changing their password. This is intentional - use a separate password reset flow.
4. **Community Display**: Communities are shown by name but could be enhanced with more details.
5. **No Email Validation**: Email uniqueness is enforced at database level but not pre-checked in forms.

## Troubleshooting

### Build Fails
- Ensure Java 8+ is installed
- Ensure Maven 3.6+ is installed
- Run `mvn clean` before building

### Cannot Access Pages
- Verify you're logged in as an admin user
- Check that AuthFilter is configured correctly
- Verify servlet mappings in web.xml or annotations

### Database Connection Issues
- Verify database credentials in application.properties
- Ensure database server is running and accessible
- Check that SSL mode matches database requirements

### Styling Issues
- Clear browser cache
- Verify dashboard.css is loaded
- Check browser console for CSS errors

## Post-Deployment Verification

After deploying, perform a quick smoke test:
1. Login as admin
2. Navigate to Students page - should load without errors
3. Navigate to Moderators page - should load without errors
4. Add one test student
5. Edit the test student
6. Delete the test student
7. Repeat for moderators

## Performance Considerations

- Current implementation loads all users of a role at once
- For large datasets (1000+ users), consider:
  - Implementing pagination
  - Adding database indexes on email, university fields
  - Caching frequently accessed data
  - Using AJAX for search instead of full page reload

## Security Notes

- Passwords are hashed using BCrypt (cost factor 10)
- SQL injection prevented via PreparedStatements
- Role-based access control via AuthFilter
- CSRF protection should be added for production
- Consider rate limiting for add/edit operations
- Audit logging should be implemented for user management actions
