# Role System Migration

## Summary
This migration replaces the old enum-based role system (ADMIN, MANAGER, STAFF) with a new database-backed hierarchical role system that supports role inheritance.

## New Roles
1. **student** - Basic student privileges for accessing platform resources
2. **subject_coordinator** - Can manage subjects, topics, and upload resources (inherits from student)
3. **moderator** - Can review, edit, or remove inappropriate resources (inherits from student)
4. **admin** - Full system privileges including user and content management (inherits from student)

## Changes Made

### Database Migration
- **V4__new_hierarchical_roles.sql**: New migration that drops the old roles table and creates a new one with inheritance support
  - Added `inherits_from` column to support role hierarchy
  - Inserted new roles with hierarchical structure

### Model Changes
- **Role.java**: Changed from enum to entity class
  - Now represents database-backed roles with id, name, description, and inheritsFrom fields
  
- **User.java**: Updated to work with string-based role names
  - Changed from `Role role` (enum) to `String roleName`
  - Updated helper methods: `isStudent()`, `isSubjectCoordinator()`, `isModerator()`, `isAdmin()`
  - Removed old methods: `isManager()`, `isStaff()`

### DAO Changes
- **UserDAO.java**: Updated `create()` method to use string role name instead of enum

### Security Changes
- **AuthFilter.java**: Updated to use string-based roles
  - Changed role rules from `Map<String, Set<Role>>` to `Map<String, Set<String>>`
  - Updated path mappings:
    - `/admin/` → admin only
    - `/moderator/` → admin, moderator
    - `/coordinator/` → admin, subject_coordinator
    - `/student/` → admin, subject_coordinator, moderator, student

### Controller Changes
- **LoginServlet.java**: Updated redirect logic for new roles
  - admin → /admin/dashboard
  - subject_coordinator → /coordinator/dashboard
  - moderator → /moderator/dashboard
  - student → /student/dashboard

#### New Controllers Created
- **StudentDashboardServlet.java**: Dashboard for student role
- **CoordinatorDashboardServlet.java**: Dashboard for subject coordinator role
- **ModeratorDashboardServlet.java**: Dashboard for moderator role

#### Removed Controllers
- **ManagerDashboardServlet.java**: Removed (replaced by CoordinatorDashboardServlet)
- **StaffDashboardServlet.java**: Removed (replaced by StudentDashboardServlet)

### View Changes

#### New Views Created
- **/student/dashboard.jsp**: Student dashboard
- **/coordinator/dashboard.jsp**: Subject coordinator dashboard with management capabilities
- **/moderator/dashboard.jsp**: Moderator dashboard with review capabilities

#### Updated Views
- **/admin/dashboard.jsp**: Updated description to reflect full system privileges

#### Removed Views
- **/manager/dashboard.jsp**: Removed
- **/staff/dashboard.jsp**: Removed

## Migration Steps

To apply this migration to an existing database:

1. Run the application - Flyway will automatically execute V4__new_hierarchical_roles.sql
2. The migration will:
   - Drop the existing roles table
   - Create a new roles table with inheritance support
   - Insert the new roles with hierarchical relationships
3. Existing users in the database will need to be manually reassigned to the new roles

## Role Mapping (for existing users)

Old Role → New Role suggestions:
- ADMIN → admin
- MANAGER → subject_coordinator
- STAFF → student

Note: Administrators should update user roles in the database after running the migration.
