# Subject Coordinator Role Removal - Implementation Summary

## Overview
This document summarizes the changes made to remove the `subject_coordinator` role from the roles table and properly implement subject coordinator as a privilege granted to students via the `subject_coordinators` table.

## Problem Statement
Previously, subject coordinator was defined as a role in the `roles` table, which was inconsistent with the application design where coordinators are students with special privileges. This change aligns the codebase with the correct design principle.

## Changes Made

### 1. Database Schema Changes
**File:** `src/main/resources/db/migration/db.sql`

- **Removed:** `subject_coordinator` role (previously id=2)
- **Updated:** Role IDs to maintain sequential order:
  - `student` remains id=1
  - `moderator` changed from id=3 to id=2
  - `admin` changed from id=4 to id=3
- **Updated:** All user INSERT statements to use correct role_ids
  - Moderators now use role_id=2
  - Admin user now uses role_id=3

### 2. Java Model Updates

#### Role.java
- Updated class documentation to remove `subject_coordinator` from the list of roles
- Added note that subject coordinators are students with privileges via `subject_coordinators` table

#### User.java
- Updated `roleName` field documentation to remove `subject_coordinator`
- Deprecated `isSubjectCoordinator()` method
- Added documentation directing developers to use `SubjectCoordinatorDAO.isCoordinator(userId)` instead

### 3. Security/Authorization Changes

#### AuthFilter.java
- Added `SubjectCoordinatorDAO` dependency
- Removed `subject_coordinator` from role-based rules
- Implemented special handling for `/subject-coordinator/*` paths that:
  - Allows admins full access
  - Checks `subject_coordinators` table (via DAO) instead of user role
  - Returns 403 Forbidden if user is not in the table

### 4. Controller Updates

#### LoginServlet.java
- Removed coordinator-specific routing logic
- Subject coordinators (who are students) now route to student dashboard like other students

#### DebugUserServlet.java
- Removed misleading guidance about updating role to `subject_coordinator`
- Added explanation that subject coordinator is a privilege, not a role
- Clarified that coordinators must be assigned by moderators via the `subject_coordinators` table

### 5. Package and Path Restructuring

#### Controller Package
**Renamed:** `com.uninest.controller.coordinator` → `com.uninest.controller.subjectcoordinator`

**Files Updated:**
- `ApproveResourceServlet.java`
- `RejectResourceServlet.java`
- `ResourceApprovalsServlet.java`

**URL Patterns Updated:** All servlets changed from `/coordinator/*` to `/subject-coordinator/*`

#### View Files

**Renamed Folder:** `src/main/webapp/WEB-INF/views/coordinator` → `views/subject-coordinator`

**Files Updated:**
- `resource-approvals.jsp` - Updated form action URLs to use `/subject-coordinator/*`

#### Tag Files

**Renamed:** `coordinator-dashboard.tag` → `subject-coordinator-dashboard.tag`

**Files Updated:**
- `subject-coordinator-dashboard.tag` - Updated navigation links
- `student-dashboard.tag` - Updated coordinator section label to "Subject Coordinator" and link to `/subject-coordinator/*`

## Verification

### Build Status
✅ Project compiles successfully with no errors
```
mvn clean compile
mvn clean package -DskipTests
```

### Code Verification
✅ No active references to `subject_coordinator` role in Java code (except deprecated method)
✅ All URL patterns consistently use `/subject-coordinator/*`
✅ Authorization properly checks `subject_coordinators` table

### Database Verification
✅ Roles table contains only: student, moderator, admin
✅ All user records use correct role_ids

## Migration Notes

### For Existing Deployments

If you have an existing database with the old schema:

1. **Backup your database first**

2. **Update roles table:**
```sql
-- Remove subject_coordinator role
DELETE FROM roles WHERE name = 'subject_coordinator';

-- Update role IDs
UPDATE roles SET id = 2 WHERE name = 'moderator';
UPDATE roles SET id = 3 WHERE name = 'admin';
```

3. **Update user records:**
```sql
-- Update moderators to use new role_id
UPDATE users SET role_id = 2 WHERE role_id = 3;

-- Update admins to use new role_id
UPDATE users SET role_id = 3 WHERE role_id = 4;

-- Users who were subject_coordinators should become students
-- Their coordinator status is maintained in subject_coordinators table
UPDATE users SET role_id = 1 WHERE role_id = 2;
```

4. **Verify subject_coordinators table:**
```sql
-- Ensure all coordinator assignments are in place
SELECT u.email, u.name, s.name as subject_name
FROM subject_coordinators sc
JOIN users u ON sc.user_id = u.id
JOIN subjects s ON sc.subject_id = s.subject_id;
```

### For New Deployments
Simply use the updated `db.sql` file which has all correct role IDs and no `subject_coordinator` role.

## Benefits of This Change

1. **Consistency:** Code now matches the design principle that coordinators are students with privileges
2. **Clarity:** Developers understand that coordinator status comes from `subject_coordinators` table
3. **Flexibility:** Students can be assigned/unassigned as coordinators without changing their role
4. **Maintainability:** Clear separation between roles (permanent user types) and privileges (temporary assignments)

## Testing Recommendations

1. **Login Flow:**
   - Test login as student, moderator, admin
   - Verify correct dashboard redirection

2. **Authorization:**
   - Test that only users in `subject_coordinators` table can access `/subject-coordinator/*` paths
   - Test that admins can access coordinator pages
   - Test that students without coordinator privilege get 403 Forbidden

3. **Coordinator Assignment:**
   - Verify moderators can assign/unassign coordinators
   - Verify assigned coordinators can access resource approvals page
   - Verify unassigned coordinators lose access immediately

4. **Database Integrity:**
   - Verify all users have valid role_ids
   - Verify subject_coordinators table references are maintained

## Future Considerations

- Consider adding session attribute `isCoordinator` that gets set during login for performance
- Could extend this pattern to other privilege-based features (e.g., teaching assistants, peer reviewers)
- May want to add coordinator assignment history/audit log

## References

- Original Feature Documentation: `SUBJECT_COORDINATOR_FEATURE.md`
- Database Schema: `src/main/resources/db/migration/db.sql`
- Authorization Filter: `src/main/java/com/uninest/security/AuthFilter.java`
- Coordinator DAO: `src/main/java/com/uninest/model/dao/SubjectCoordinatorDAO.java`
