# Community Join Request Feature

## Summary

This feature implements a moderator approval system for students joining communities. Previously, students could join communities immediately by entering a community ID. Now, students must submit a join request which requires moderator approval.

## Changes Overview

### Database Schema Changes

**New Table: `community_join_requests`**

```sql
CREATE TABLE `community_join_requests` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `community_id` INT NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `requested_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `processed_at` TIMESTAMP NULL DEFAULT NULL,
  `processed_by_user_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_join_req_status` (`status`),
  INDEX `idx_join_req_user` (`user_id`),
  INDEX `idx_join_req_community` (`community_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`processed_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Fields:**
- `id`: Primary key
- `user_id`: Foreign key to the student requesting to join
- `community_id`: Foreign key to the target community
- `status`: Current status ('pending', 'approved', 'rejected')
- `requested_at`: Timestamp when request was created
- `processed_at`: Timestamp when request was processed
- `processed_by_user_id`: Foreign key to moderator who processed the request

### Backend Components

#### 1. Model Class: `JoinRequest.java`

Represents a community join request with the following properties:
- Basic request information (id, user_id, community_id, status)
- User details (name, email, academic year, university)
- Community details (title)
- Processing information (processed_at, processed_by)

**Location:** `src/main/java/com/uninest/model/JoinRequest.java`

#### 2. DAO Class: `JoinRequestDAO.java`

Provides data access methods for join requests:
- `create(userId, communityId)`: Create a new join request
- `findById(id)`: Retrieve a specific request
- `findByCommunityAndStatus(communityId, status)`: Get all requests for a community by status
- `approve(requestId, moderatorUserId)`: Approve a request
- `reject(requestId, moderatorUserId)`: Reject a request
- `findPendingRequestByUserAndCommunity(userId, communityId)`: Check for existing pending request

**Location:** `src/main/java/com/uninest/model/dao/JoinRequestDAO.java`

#### 3. Servlets

**a. Modified: `JoinCommunityServlet.java`**

**Changes:**
- Removed direct community assignment via `UserDAO.assignCommunity()`
- Now creates a join request via `JoinRequestDAO.create()`
- Added validation to prevent duplicate pending requests
- Displays success message after request submission

**Location:** `src/main/java/com/uninest/controller/student/JoinCommunityServlet.java`

**b. New: `JoinRequestsServlet.java`**

Displays join requests for a moderator's community with tab filtering:
- GET `/moderator/join-requests?status=pending|approved|rejected`
- Shows only requests for the logged-in moderator's community
- Supports three tabs: Pending, Accepted, Rejected

**Location:** `src/main/java/com/uninest/controller/moderator/JoinRequestsServlet.java`

**c. New: `ApproveJoinRequestServlet.java`**

Handles join request approval:
- POST `/moderator/join-requests/approve`
- Validates request belongs to moderator's community
- Updates request status to 'approved'
- Assigns student to the community via `UserDAO.assignCommunity()`
- Records moderator ID and timestamp

**Location:** `src/main/java/com/uninest/controller/moderator/ApproveJoinRequestServlet.java`

**d. New: `RejectJoinRequestServlet.java`**

Handles join request rejection:
- POST `/moderator/join-requests/reject`
- Validates request belongs to moderator's community
- Updates request status to 'rejected'
- Records moderator ID and timestamp

**Location:** `src/main/java/com/uninest/controller/moderator/RejectJoinRequestServlet.java`

### Frontend Components

#### 1. Moderator Join Requests Page: `join-requests.jsp`

A complete page for managing join requests, following the same UI pattern as `admin/communities.jsp`:

**Features:**
- Breadcrumb navigation
- Three-tab interface (Pending, Accepted, Rejected)
- Table displaying student information:
  - Student name with avatar
  - Email address
  - Academic year
  - University name
- Action buttons based on status:
  - Pending: Approve, Reject
  - Approved: Reject (to reverse)
  - Rejected: Approve (to reconsider)
- Request count display
- Confirmation modal for actions

**Location:** `src/main/webapp/WEB-INF/views/moderator/join-requests.jsp`

#### 2. Updated: Student Join Community Page

**Changes:**
- Added success message display for join request submission
- Green text color for success messages

**Location:** `src/main/webapp/WEB-INF/views/student/join-community.jsp`

#### 3. Updated: Moderator Dashboard Navigation

**Changes:**
- Added "Join Requests" navigation item with user-plus icon
- Links to `/moderator/join-requests`
- Positioned after Dashboard and before Content Review

**Location:** `src/main/webapp/WEB-INF/tags/layouts/moderator-dashboard.tag`

## User Flow

### Student Perspective

1. **Submit Request**
   - Navigate to "Join Community" page
   - Enter valid community ID
   - Click "Join" button
   - See success message: "Join request submitted! Please wait for moderator approval."

2. **Duplicate Request Prevention**
   - If student submits again with same community ID
   - See message: "Your join request is pending moderator approval."
   - No duplicate request is created

3. **After Approval**
   - Student's `community_id` is updated in database
   - Student gains access to community features

### Moderator Perspective

1. **View Requests**
   - Click "Join Requests" in sidebar
   - See all pending requests for their community
   - View student details (name, email, year, university)

2. **Approve Request**
   - Click "Approve" button
   - Request status changes to 'approved'
   - Student is automatically assigned to community
   - Request moves to "Accepted" tab

3. **Reject Request**
   - Click "Reject" button
   - Request status changes to 'rejected'
   - Student is NOT assigned to community
   - Request moves to "Rejected" tab

4. **Reconsider Decisions**
   - Can reject an approved request
   - Can approve a rejected request
   - Allows flexibility in decision-making

## Security Considerations

1. **Community Isolation**
   - Moderators see only requests for their own community
   - Validation ensures moderators cannot process requests from other communities

2. **Authentication Required**
   - All endpoints protected by `AuthFilter`
   - Session validation for moderator role

3. **Authorization Checks**
   - Servlets verify moderator's `community_id` matches request's `community_id`
   - Prevents unauthorized access to requests

## API Endpoints

### Student Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/student/join-community` | GET | Display join form |
| `/student/join-community` | POST | Submit join request |

### Moderator Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/moderator/join-requests` | GET | List join requests (with status filter) |
| `/moderator/join-requests?status=pending` | GET | List pending requests |
| `/moderator/join-requests?status=approved` | GET | List approved requests |
| `/moderator/join-requests?status=rejected` | GET | List rejected requests |
| `/moderator/join-requests/approve` | POST | Approve a join request |
| `/moderator/join-requests/reject` | POST | Reject a join request |

## Database Queries

### Common Operations

**Create Join Request:**
```sql
INSERT INTO community_join_requests(user_id, community_id, status) 
VALUES(?, ?, 'pending');
```

**Approve Request:**
```sql
UPDATE community_join_requests 
SET status = 'approved', processed_at = NOW(), processed_by_user_id = ? 
WHERE id = ?;
```

**Assign Student to Community:**
```sql
UPDATE users SET community_id = ? WHERE id = ?;
```

**Get Requests by Community and Status:**
```sql
SELECT jr.*, u.name AS user_name, u.email AS user_email, 
       u.academic_year AS user_academic_year, uni.name AS university_name, 
       c.title AS community_title
FROM community_join_requests jr
JOIN users u ON jr.user_id = u.id
LEFT JOIN universities uni ON u.university_id = uni.id
JOIN communities c ON jr.community_id = c.id
WHERE jr.community_id = ? AND jr.status = ?
ORDER BY jr.requested_at DESC;
```

## Configuration Required

1. **Database Migration**
   - Run the updated `db.sql` script to create the `community_join_requests` table
   - Recommended to backup existing data before migration

2. **No Application Configuration Changes**
   - All changes are backward compatible
   - Existing functionality remains intact

## Testing

Refer to `JOIN_REQUEST_TESTING_GUIDE.md` for comprehensive testing scenarios.

## Future Enhancements

Possible improvements for future iterations:

1. **Email Notifications**
   - Notify students when request is approved/rejected
   - Notify moderators of new join requests

2. **Request Comments**
   - Allow students to add a message with their request
   - Allow moderators to add rejection reasons

3. **Bulk Operations**
   - Approve/reject multiple requests at once
   - Export requests to CSV

4. **Request History**
   - Show students their request history
   - Allow viewing of rejection reasons

5. **Auto-approval Rules**
   - Configure certain conditions for automatic approval
   - Based on university, academic year, etc.

## Compatibility

- **Java Version:** 1.8+
- **Servlet API:** Jakarta Servlet 6.0
- **Database:** MySQL 5.7+
- **Browser Compatibility:** Modern browsers (Chrome, Firefox, Safari, Edge)

## Support

For issues or questions:
1. Check the testing guide for troubleshooting steps
2. Review servlet logs for error messages
3. Verify database schema is correctly applied
4. Ensure moderators have community assignments
