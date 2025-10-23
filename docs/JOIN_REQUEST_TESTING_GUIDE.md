# Community Join Request Feature - Testing Guide

## Overview

This guide describes how to test the new community join request feature where students need moderator approval to join communities.

## Database Setup

1. **Reset Database**: Apply the updated schema from `src/main/resources/db/migration/db.sql`
   - The new `community_join_requests` table will be created
   - This table tracks all join requests with status (pending, approved, rejected)

2. **Verify Table Creation**:
   ```sql
   DESCRIBE community_join_requests;
   ```

## Test Scenarios

### Test 1: Student Submits Join Request

**Prerequisites:**
- Login as a student (e.g., s101@abc.com / password123)
- Student should not be in any community yet

**Steps:**
1. Navigate to `/student/join-community`
2. Enter a valid, approved community ID (e.g., 1)
3. Click "Join" button

**Expected Results:**
- Success message: "Join request submitted! Please wait for moderator approval."
- Request is created with status = 'pending' in `community_join_requests` table
- Student's `community_id` in `users` table remains NULL

**Verification Query:**
```sql
SELECT * FROM community_join_requests WHERE user_id = [student_id] AND community_id = [comm_id];
```

### Test 2: Duplicate Request Prevention

**Prerequisites:**
- Student has already submitted a pending request (from Test 1)

**Steps:**
1. Navigate to `/student/join-community`
2. Enter the same community ID again
3. Click "Join" button

**Expected Results:**
- Success message: "Your join request is pending moderator approval."
- No new request is created
- Only one pending request exists in database

### Test 3: Invalid Community ID

**Prerequisites:**
- Login as a student

**Steps:**
1. Navigate to `/student/join-community`
2. Enter an invalid community ID (e.g., 9999) or a non-approved community ID
3. Click "Join" button

**Expected Results:**
- Error message: "Invalid or not yet approved community ID"
- No request is created

### Test 4: Moderator Views Pending Requests

**Prerequisites:**
- Login as a moderator (e.g., m1@abc.com / password123)
- Moderator should be assigned to a community
- At least one student has submitted a join request for that community

**Steps:**
1. Navigate to moderator dashboard
2. Click "Join Requests" in the sidebar
3. View the "Pending" tab (default)

**Expected Results:**
- All pending join requests for moderator's community are displayed
- Table shows: Student name, email, academic year, and university
- Each row has "Approve" and "Reject" buttons
- Request count is displayed correctly

### Test 5: Moderator Approves Join Request

**Prerequisites:**
- Login as a moderator
- At least one pending join request exists

**Steps:**
1. Navigate to `/moderator/join-requests`
2. Click "Approve" button for a pending request

**Expected Results:**
- Request status changes to 'approved' in database
- Student's `community_id` in `users` table is updated
- Request moves to "Accepted" tab
- `processed_at` and `processed_by_user_id` fields are updated

**Verification Queries:**
```sql
-- Check request status
SELECT * FROM community_join_requests WHERE id = [request_id];

-- Check student's community assignment
SELECT id, email, community_id FROM users WHERE id = [student_id];
```

### Test 6: Moderator Rejects Join Request

**Prerequisites:**
- Login as a moderator
- At least one pending join request exists

**Steps:**
1. Navigate to `/moderator/join-requests`
2. Click "Reject" button for a pending request

**Expected Results:**
- Request status changes to 'rejected' in database
- Student's `community_id` remains NULL
- Request moves to "Rejected" tab
- `processed_at` and `processed_by_user_id` fields are updated

### Test 7: Tab Navigation

**Prerequisites:**
- Login as a moderator
- Have requests in different statuses (pending, approved, rejected)

**Steps:**
1. Navigate to `/moderator/join-requests`
2. Click through each tab: Pending, Accepted, Rejected
3. Verify URLs change to include `?status=pending|approved|rejected`

**Expected Results:**
- Each tab displays only requests with that status
- Active tab is highlighted
- Request count updates for each tab
- URL reflects the current tab selection

### Test 8: Security - Moderator Access Control

**Prerequisites:**
- Two moderators from different communities
- Create a join request for Community A

**Steps:**
1. Login as moderator of Community A
2. Verify the request is visible in join requests
3. Logout
4. Login as moderator of Community B
5. Check join requests page

**Expected Results:**
- Moderator B should NOT see the request for Community A
- Each moderator sees only requests for their own community

### Test 9: Student Re-applies After Rejection

**Prerequisites:**
- Student has a rejected join request

**Steps:**
1. Login as the student
2. Navigate to `/student/join-community`
3. Enter the same community ID
4. Submit the form

**Expected Results:**
- New pending request is created
- Student can re-apply after rejection
- Old rejected request remains in database

### Test 10: UI Consistency Check

**Prerequisites:**
- Login as moderator

**Steps:**
1. Navigate to `/moderator/join-requests`
2. Compare UI with `/admin/communities`

**Expected Results:**
- Similar layout and styling
- Same tab pattern (Pending, Accepted, Rejected)
- Table structure matches admin communities page
- No create/edit/delete buttons (as specified in requirements)
- Only approve/reject functionality available

## Edge Cases

### Edge Case 1: Student Already in Community
**Test:** Student with existing community_id tries to submit join request
**Expected:** Application should handle gracefully (current implementation allows it, consider adding validation)

### Edge Case 2: Moderator Without Community
**Test:** Moderator without assigned community accesses join requests
**Expected:** Redirect to moderator dashboard (implemented in JoinRequestsServlet)

### Edge Case 3: Concurrent Requests
**Test:** Multiple students request to join same community simultaneously
**Expected:** All requests are created and queued for approval

## Database Queries for Testing

### View All Join Requests
```sql
SELECT jr.*, 
       u.name AS user_name, 
       u.email AS user_email,
       c.title AS community_title
FROM community_join_requests jr
JOIN users u ON jr.user_id = u.id
JOIN communities c ON jr.community_id = c.id
ORDER BY jr.requested_at DESC;
```

### View Pending Requests for a Community
```sql
SELECT * FROM community_join_requests 
WHERE community_id = [comm_id] AND status = 'pending'
ORDER BY requested_at DESC;
```

### Check Student's Community Assignment
```sql
SELECT u.id, u.email, u.community_id, c.title AS community_title
FROM users u
LEFT JOIN communities c ON u.community_id = c.id
WHERE u.id = [student_id];
```

## Success Criteria

✓ Students can submit join requests  
✓ Students cannot join communities directly  
✓ Duplicate pending requests are prevented  
✓ Moderators see only requests for their community  
✓ Moderators can approve requests  
✓ Moderators can reject requests  
✓ Approved students are assigned to community  
✓ UI matches admin communities page style  
✓ Navigation tabs work correctly  
✓ Request counts are accurate  

## Troubleshooting

### Issue: Requests not showing up
- Check if moderator has community_id assigned
- Verify community_id matches between moderator and requests
- Check database for requests with matching community_id

### Issue: Approval not working
- Verify moderator has correct community_id
- Check servlet logs for errors
- Ensure UserDAO.assignCommunity() is working

### Issue: UI not displaying correctly
- Clear browser cache
- Check if CSS files are loaded
- Verify JSP syntax is correct
