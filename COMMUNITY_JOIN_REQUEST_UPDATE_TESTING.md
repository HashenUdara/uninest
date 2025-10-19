# Community Join Request Feature - Testing Guide

## Overview
This document provides testing instructions for the updated community join request feature that ensures:
1. One student can join only one community
2. Students can cancel their pending join requests
3. Students can see their request status
4. Automatic redirect to dashboard when request is approved

## Prerequisites
- Database with `community_join_requests` table already created
- At least one approved community in the database
- Test accounts:
  - One student account (not in any community)
  - One moderator account (assigned to a community)

## Test Scenarios

### Scenario 1: Submit a Join Request
**Steps:**
1. Log in as a student who is not in any community
2. Navigate to the join community page (`/student/join-community`)
3. Enter a valid, approved community ID
4. Click "Join" button

**Expected Result:**
- Success message: "Join request submitted! Please wait for moderator approval."
- A pending request status card appears showing:
  - Clock icon with "Pending Request" header
  - "Waiting for moderator approval" text
  - Community name and ID
  - Status badge showing "Pending"
  - "Cancel Request" button
- The join form is hidden

### Scenario 2: Attempt to Submit Another Request
**Steps:**
1. With a pending request already visible
2. Try to navigate to `/student/join-community` again

**Expected Result:**
- The same pending request status is displayed
- The join form remains hidden
- No duplicate request is created in the database

### Scenario 3: Submit Request with Different Community ID
**Steps:**
1. Try to submit a POST request with a different community ID while having a pending request
   (Can be tested by temporarily showing the form or using browser dev tools)

**Expected Result:**
- Error message: "You already have a pending request. Please cancel it first before submitting a new one."
- The existing pending request status card is still displayed
- No new request is created

### Scenario 4: Cancel a Pending Request
**Steps:**
1. With a pending request visible on the page
2. Click the "Cancel Request" button
3. Confirm the cancellation in the browser alert dialog

**Expected Result:**
- Page redirects back to `/student/join-community`
- Success message: "Join request cancelled successfully."
- The pending request status card disappears
- The join form is displayed again
- The request is deleted from the database (status = 'pending' only)

### Scenario 5: Moderator Approves Request
**Steps:**
1. Log in as a moderator
2. Navigate to "Join Requests" (`/moderator/join-requests`)
3. Find the student's pending request
4. Click "Approve" button

**Expected Result:**
- Request moves to "Accepted" tab
- Student is assigned to the community (community_id updated in users table)
- Request status changes to 'approved' in database

### Scenario 6: Student Refreshes After Approval
**Steps:**
1. After moderator approves the request (Scenario 5)
2. As the student, refresh the join community page (`/student/join-community`)

**Expected Result:**
- Student is automatically redirected to `/student/dashboard`
- Student session is updated with the community_id
- Student can now access community features

### Scenario 7: Already in Community
**Steps:**
1. Log in as a student who is already assigned to a community
2. Try to navigate to `/student/join-community`

**Expected Result:**
- Automatically redirected to `/student/dashboard`
- Cannot access the join community page

### Scenario 8: Invalid Community ID
**Steps:**
1. Log in as a student without a community
2. Enter an invalid or non-approved community ID
3. Click "Join" button

**Expected Result:**
- Error message: "Invalid or not yet approved community ID"
- No request is created
- Form remains visible for retry

### Scenario 9: Non-numeric Community ID
**Steps:**
1. Enter a non-numeric value (e.g., "abc") in the community ID field
2. Click "Join" button

**Expected Result:**
- Error message: "Please enter a valid community ID"
- No request is created
- Form remains visible

## UI/UX Validation

### Visual Consistency Check
The request status card should match the application's design system:
- Uses design tokens from CSS variables (--color-*, --space-*, --radius-*, --fs-*)
- Clock icon is rendered using Lucide icons
- Pending badge uses amber/orange color scheme (#f59e0b)
- Clean, modern card design with proper spacing
- Responsive and works on mobile devices

### Accessibility Check
- All interactive elements are keyboard accessible
- Icons have `aria-hidden="true"` attribute
- Confirmation dialog on cancel action
- Clear, descriptive button labels
- Proper color contrast for text

## Database Verification

### Check Pending Request
```sql
SELECT * FROM community_join_requests 
WHERE user_id = <student_user_id> AND status = 'pending';
```

### Check Community Assignment
```sql
SELECT id, email, community_id FROM users 
WHERE id = <student_user_id>;
```

### Check Request History
```sql
SELECT * FROM community_join_requests 
WHERE user_id = <student_user_id> 
ORDER BY requested_at DESC;
```

## Edge Cases

### Edge Case 1: Moderator Rejects Then Approves
**Steps:**
1. Moderator rejects a request
2. Student navigates to join community page
3. Student sees form and can submit a new request

**Expected:** Student can submit a new request after rejection.

### Edge Case 2: Multiple Students Same Community
**Steps:**
1. Two different students submit requests to the same community
2. Moderator should see both requests

**Expected:** Each student can only have one pending request, but multiple students can request the same community.

### Edge Case 3: Session Timeout
**Steps:**
1. Submit a request
2. Wait for session to timeout
3. Try to cancel request

**Expected:** Redirected to login page (handled by AuthFilter).

## Performance Considerations

- Session refresh on page load adds one database query
- Database indexes on `community_join_requests` table ensure fast lookups:
  - `idx_join_req_user` on `user_id`
  - `idx_join_req_status` on `status`
  - `idx_join_req_community` on `community_id`

## Security Validation

1. **Authorization Check:** Students can only cancel their own requests
2. **Status Validation:** Can only cancel pending requests (not approved/rejected)
3. **Community Isolation:** Moderators only see requests for their community
4. **SQL Injection Protection:** All queries use PreparedStatement with parameters
5. **XSS Protection:** JSTL automatically escapes output

## Troubleshooting

### Issue: Student Not Redirected After Approval
**Solution:** Check if session refresh is working. Verify UserDAO.findById() returns updated user.

### Issue: Cancel Button Not Working
**Solution:** Check if servlet mapping is correct. Verify request ID is passed correctly.

### Issue: Duplicate Requests Created
**Solution:** Verify findPendingRequestByUser() is checking across all communities, not just one.

### Issue: Form Shows Despite Pending Request
**Solution:** Check JSTL condition `${empty pendingRequest}` and ensure attribute is set correctly.

## Conclusion

This feature provides a complete solution for managing community join requests with:
- One pending request per student constraint
- Self-service request cancellation
- Real-time status visibility
- Automatic redirect after approval
- Consistent, accessible UI design
