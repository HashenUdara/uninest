# Organization Management Implementation

## Overview

This implementation adds comprehensive organization management functionality to the uninest application, including:

1. **Organization Creation for Moderators**: Moderators can create organizations after signup
2. **Admin Approval Workflow**: Organizations must be approved by admins before becoming active
3. **Student Organization Joining**: Students can join approved organizations using organization IDs
4. **Enhanced Signup**: Students must provide academic year and university during signup

## Features Implemented

### 1. Database Schema Changes

- Added `organizations` table with fields for title, description, status, and moderator
- Extended `users` table with:
  - `organization_id` - links users to their organization
  - `academic_year` - stores student's year (1-4)
  - `university` - stores student's university name

See [DATABASE_CHANGES.md](DATABASE_CHANGES.md) for detailed schema information.

### 2. Moderator Workflow

#### Signup Flow:
1. Moderator signs up at `/signup`
2. Redirected to `/moderator/create-organization`
3. Creates organization with title and description
4. Redirected to `/moderator/organization-pending`
5. Waits for admin approval

#### Login Flow:
1. Moderator logs in
2. System checks organization status:
   - No organization → redirect to create organization
   - Pending → redirect to pending approval page
   - Approved → redirect to dashboard
3. Dashboard displays organization ID for sharing with students

**New Pages:**
- `/moderator/create-organization` - Organization creation form
- `/moderator/organization-pending` - Waiting page (styled like forgot-password-requested)

### 3. Student Workflow

#### Signup Flow:
1. Student signs up at `/signup`
2. Must provide:
   - Email and password
   - Academic year (1-4)
   - University (from 15 Sri Lankan universities)
3. Redirected to `/student/join-organization`
4. Enters organization ID provided by moderator
5. System validates:
   - Organization exists
   - Organization is approved
6. Student joins organization and redirected to dashboard

#### Login Flow:
1. Student logs in
2. System checks organization membership:
   - Not joined → redirect to join organization page
   - Joined → redirect to dashboard

**New Pages:**
- `/student/join-organization` - Organization ID entry form

**Enhanced Signup:**
- Academic year dropdown (1, 2, 3, 4)
- University dropdown with 15 Sri Lankan universities
- Fields shown/hidden based on selected role (student vs moderator)

### 4. Admin Workflow

#### Organization Management:
1. Admin logs in
2. Accesses `/admin/organizations` from dashboard
3. Views all organizations with status
4. Can approve or reject pending organizations

**New Pages:**
- `/admin/organizations` - Organization list and approval interface

## File Changes

### New Java Files:
- `Organization.java` - Model class for organizations
- `OrganizationDAO.java` - Database access for organizations
- `CreateOrganizationServlet.java` - Handles organization creation
- `OrganizationPendingServlet.java` - Displays pending approval page
- `JoinOrganizationServlet.java` - Handles student organization joining
- `ManageOrganizationsServlet.java` - Admin organization management

### Modified Java Files:
- `User.java` - Added organization_id, academic_year, university fields
- `UserDAO.java` - Updated to handle new user fields
- `SignUpServlet.java` - Enhanced to handle student fields and redirect flows
- `LoginServlet.java` - Added organization status checks
- `ModeratorDashboardServlet.java` - Added organization approval check
- `StudentDashboardServlet.java` - Added organization membership check

### New JSP Files:
- `moderator/create-organization.jsp` - Organization creation form
- `moderator/organization-pending.jsp` - Pending approval page
- `student/join-organization.jsp` - Organization joining form
- `admin/organizations.jsp` - Organization management interface

### Modified JSP Files:
- `auth/signup.jsp` - Added academic year and university fields
- `admin/dashboard.jsp` - Added link to manage organizations
- `moderator/dashboard.jsp` - Display organization ID

### Database Files:
- `db/migration/db.sql` - Updated schema with new tables and fields

## Sri Lankan Universities Supported

1. University of Colombo
2. University of Peradeniya
3. University of Sri Jayewardenepura
4. University of Kelaniya
5. University of Moratuwa
6. University of Jaffna
7. University of Ruhuna
8. Eastern University, Sri Lanka
9. South Eastern University of Sri Lanka
10. Rajarata University of Sri Lanka
11. Sabaragamuwa University of Sri Lanka
12. Wayamba University of Sri Lanka
13. Uva Wellassa University
14. Open University of Sri Lanka
15. Buddhist and Pali University of Sri Lanka

## URLs Summary

### Moderator Routes:
- `GET/POST /moderator/create-organization` - Create organization
- `GET /moderator/organization-pending` - Pending approval status
- `GET /moderator/dashboard` - Dashboard (requires approved org)

### Student Routes:
- `GET/POST /student/join-organization` - Join organization
- `GET /student/dashboard` - Dashboard (requires org membership)

### Admin Routes:
- `GET/POST /admin/organizations` - Manage organizations
- `GET /admin/dashboard` - Admin dashboard

### Auth Routes (Modified):
- `GET/POST /signup` - Enhanced with academic year and university
- `POST /login` - Updated with organization checks

## Security Considerations

1. **Authorization Checks**: All servlets verify user role before allowing access
2. **Organization Validation**: Students can only join approved organizations
3. **Moderator Restrictions**: Moderators blocked from dashboard until approved
4. **Data Validation**: All inputs validated server-side

## Testing Recommendations

### Manual Testing:

1. **Moderator Flow:**
   - Sign up as moderator
   - Create organization
   - Verify redirected to pending page
   - Login again, verify still on pending page
   - Have admin approve
   - Login, verify dashboard access
   - Verify organization ID displayed

2. **Student Flow:**
   - Sign up as student with year and university
   - Enter organization ID (get from moderator dashboard)
   - Verify joined successfully
   - Login again, verify direct dashboard access

3. **Admin Flow:**
   - Login as admin
   - Access organizations page
   - Approve a pending organization
   - Verify status updated
   - Verify moderator can now access dashboard

4. **Edge Cases:**
   - Student enters invalid org ID
   - Student enters pending org ID
   - Moderator tries to create second organization
   - User without org tries to access dashboard

## Build Instructions

```bash
# Compile the project
mvn clean compile

# Package as WAR
mvn clean package

# Run with Tomcat
mvn tomcat7:run
```

## Database Setup

1. Create MySQL database: `uninest_auth`
2. Run the SQL script: `src/main/resources/db/migration/db.sql`
3. Configure database connection in your environment

## Notes

- Minimum password length: 6 characters
- Organization approval is required before moderators can access dashboard
- Students must join an organization before accessing dashboard
- Organization IDs are auto-generated and must be shared manually by moderators
