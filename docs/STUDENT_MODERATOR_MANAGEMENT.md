# Student and Moderator Management Implementation

## Overview
This implementation adds comprehensive CRUD (Create, Read, Update, Delete) functionality for managing students and moderators in the UniNest admin dashboard.

## Key Features

### Students Management
- **List Students**: View all students in a paginated, sortable table at `/admin/students`
- **Add Student**: Create new student accounts with email, password, academic year, university, and community assignment at `/admin/students/add`
- **Edit Student**: Update student information at `/admin/students/edit?id={id}`
- **Delete Student**: Remove student accounts at `/admin/students/delete` (POST)
- **Search Students**: Search students by email or university using the search bar

### Moderators Management
- **List Moderators**: View all moderators in a paginated, sortable table at `/admin/moderators`
- **Add Moderator**: Create new moderator accounts with email, password, university, and community assignment at `/admin/moderators/add`
- **Edit Moderator**: Update moderator information at `/admin/moderators/edit?id={id}`
- **Delete Moderator**: Remove moderator accounts at `/admin/moderators/delete` (POST)
- **Search Moderators**: Search moderators by email or university using the search bar

## Technical Implementation

### Database Schema
The implementation uses the existing `users` table with role-based filtering:
- Students have `role_id` corresponding to the 'student' role
- Moderators have `role_id` corresponding to the 'moderator' role
- Users can be optionally assigned to communities via `community_id`
- Students have additional fields: `academic_year` (1-4) and `university`

### Backend Components

#### DAO Layer Extensions (`UserDAO.java`)
New methods added to support user management:
- `findByRole(String roleName)`: Get all users with a specific role
- `searchUsers(String roleName, String searchTerm)`: Search users by email or university
- `findById(int id)`: Get a single user by ID
- `update(User user)`: Update user information
- `deleteUser(int userId)`: Delete a user

#### Servlets
**Students Management:**
- `StudentsServlet`: Lists all students with search support
- `AddStudentServlet`: Handles student creation
- `EditStudentServlet`: Handles student updates
- `DeleteStudentServlet`: Handles student deletion

**Moderators Management:**
- `ModeratorsServlet`: Lists all moderators with search support
- `AddModeratorServlet`: Handles moderator creation
- `EditModeratorServlet`: Handles moderator updates
- `DeleteModeratorServlet`: Handles moderator deletion

### Frontend Components

#### JSP Views
**Students:**
- `/WEB-INF/views/admin/students.jsp`: Main listing page with search and table
- `/WEB-INF/views/admin/add-student.jsp`: Student creation form
- `/WEB-INF/views/admin/edit-student.jsp`: Student edit form

**Moderators:**
- `/WEB-INF/views/admin/moderators.jsp`: Main listing page with search and table
- `/WEB-INF/views/admin/add-moderator.jsp`: Moderator creation form
- `/WEB-INF/views/admin/edit-moderator.jsp`: Moderator edit form

#### UI Components
- Uses the reusable `admin-dashboard` layout tag
- Consistent styling with existing community management pages
- Modal dialogs for delete confirmations
- Alert messages for success/error feedback
- Responsive datatable with sortable columns

#### Styling
Added to `/static/dashboard.css`:
- `.c-alert` component with success, danger, and info variants
- Utility classes: `.u-text-center`, `.u-text-right`, `.u-clamp-2`

### Navigation
Updated `/WEB-INF/tags/layouts/admin-dashboard.tag` to include:
- Students link at `/admin/students`
- Moderators link at `/admin/moderators`

## User Workflows

### Adding a Student
1. Navigate to Admin Dashboard → Students
2. Click "Add Student" button
3. Fill in required fields (email, password)
4. Optionally select academic year, university, and community
5. Submit form
6. Redirected back to students list with success message

### Editing a Student
1. Navigate to Students list
2. Click pencil icon next to student
3. Update information
4. Submit form
5. Redirected back to students list with success message

### Deleting a Student
1. Navigate to Students list
2. Click trash icon next to student
3. Confirm deletion in modal dialog
4. Student is deleted and list refreshes with success message

### Searching Students
1. Navigate to Students list
2. Enter search term in search box
3. Click Search button
4. Results are filtered by email and university
5. Click Clear to reset search

## Security Considerations
- Password hashing using BCrypt for new users
- Role-based access control (admin only)
- CSRF protection via POST requests for mutations
- SQL injection prevention via PreparedStatements

## Future Enhancements
- Bulk operations (select multiple users for deletion)
- Export functionality (CSV, PDF)
- Advanced filters (by community, academic year, etc.)
- Pagination for large datasets
- User activity logs
- Email notifications for account creation
- Password reset functionality from admin panel

## Notes
- The old `/students` endpoints (using the `Student` model) remain for backward compatibility
- New implementation uses the `User` model with role-based filtering
- Community names are shown by ID; could be enhanced with JOIN to show actual names
- Delete operations cascade appropriately based on foreign key constraints
