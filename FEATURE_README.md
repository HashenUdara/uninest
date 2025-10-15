# Moderator Approval Feature - Quick Start Guide

## What's New

This update adds:
1. **Moderator approval workflow** - Moderators need admin approval before accessing the system
2. **Enhanced signup form** - Academic year and university selection required
3. **Pending approval page** - Waiting page for unapproved moderators

## Quick Implementation Steps

### 1. Update Database Schema

Run the updated database migration script:
```bash
mysql -u [username] -p [database_name] < src/main/resources/db/migration/db.sql
```

Or if you have an existing database, see `DATABASE_CHANGES.md` for migration SQL.

### 2. Deploy Application

```bash
mvn clean package
# Deploy target/uninest.war to your application server
```

### 3. Test the Changes

#### Test Student Signup
1. Go to `/signup`
2. Fill in all fields including Academic Year and University
3. Select "Student" role
4. Submit - should auto-login and redirect to student dashboard

#### Test Moderator Signup
1. Go to `/signup`
2. Fill in all fields including Academic Year and University
3. Select "Moderator" role
4. Submit - should redirect to `/auth/pending-approval` page
5. Try to login - should see error message

#### Approve Moderator (Admin Task)
```sql
-- View pending moderators
SELECT u.id, u.email, u.academic_year, un.name AS university, u.created_at
FROM users u
JOIN roles r ON u.role_id = r.id
LEFT JOIN universities un ON u.university_id = un.id
WHERE r.name = 'moderator' AND u.is_approved = 0;

-- Approve a moderator
UPDATE users SET is_approved = 1 WHERE id = [user_id];
```

#### Test Approved Moderator Login
1. After admin approval, login with moderator credentials
2. Should successfully redirect to moderator dashboard

## Documentation Files

- **DATABASE_CHANGES.md** - Database schema changes and migration instructions
- **IMPLEMENTATION_SUMMARY.md** - Complete feature documentation and technical details
- **UI_CHANGES.md** - Visual mockups and user flow diagrams

## Key Features

### For Students
- Select academic year (1-4) during signup
- Select university from dropdown
- Immediate access after signup

### For Moderators
- Select academic year and university during signup
- Must wait for admin approval
- Cannot login until approved
- See clear error message when trying to login before approval

### For Admins
- Manual approval required for moderators
- SQL commands provided for approval
- Future enhancement: Admin dashboard for approval management

## Database Schema Summary

### New Table: `universities`
- Contains 15 Sri Lankan universities
- Referenced by users table

### Updated Table: `users`
- `is_approved` - TINYINT(1), default 1 (for moderator approval)
- `academic_year` - INT, nullable (1-4)
- `university_id` - INT, foreign key to universities

## Technical Changes Summary

### Backend
- New `UniversityDAO` for university data access
- Updated `UserDAO` with new fields and queries
- Updated `User` model with new properties
- Enhanced `SignUpServlet` with approval logic
- Updated `LoginServlet` with approval check
- New `PendingApprovalServlet` for waiting page

### Frontend
- Updated `signup.jsp` with academic year and university dropdowns
- New `pending-approval.jsp` for moderator waiting state
- Maintains existing design system and responsive layout

## Build Status

✅ Compilation successful  
✅ WAR packaging successful  
✅ No breaking changes  
✅ All existing functionality preserved  

## Support

For issues or questions:
1. Check `IMPLEMENTATION_SUMMARY.md` for detailed documentation
2. Review `DATABASE_CHANGES.md` for database-related issues
3. See `UI_CHANGES.md` for UI flow diagrams

## Future Enhancements

Suggested improvements:
- Admin dashboard for moderator approval management
- Email notifications on approval/rejection
- Bulk approval functionality
- Moderator application review interface
- Activity logging for approval actions
