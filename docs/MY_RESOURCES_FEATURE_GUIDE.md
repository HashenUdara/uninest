# My Resources Feature - Implementation Guide

## Overview
This document describes the My Resources feature implementation for the UniNest student dashboard. This feature allows students to upload study materials, subject coordinators to review and approve submissions, and provides a comprehensive UI for managing resources.

## Feature Components

### 1. Database Schema

#### Resource Categories Table
```sql
CREATE TABLE resource_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
```

**Pre-populated Categories:**
- Lecture Notes
- Short Notes
- Past Papers
- Tutorials
- Assignments
- Lab Sheets
- Video Tutorials
- Project Reports
- Reference Materials
- Model Answers

#### Resources Table
```sql
CREATE TABLE resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    topic_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(100) NOT NULL,
    upload_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    visibility ENUM('private','public') DEFAULT 'private',
    approved_by INT DEFAULT NULL,
    approval_date DATETIME DEFAULT NULL,
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES resource_categories(category_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(id),
    FOREIGN KEY (approved_by) REFERENCES users(id)
);
```

### 2. Model Classes

#### Resource.java
Located at: `src/main/java/com/uninest/model/Resource.java`

**Key Properties:**
- Basic resource information (title, description, file URL, file type)
- Status tracking (pending, approved, rejected)
- Visibility control (private, public)
- Relationships to topic, category, uploader, and approver
- Display fields from joined tables (uploader name, subject name, etc.)

#### ResourceCategory.java
Located at: `src/main/java/com/uninest/model/ResourceCategory.java`

**Key Properties:**
- Category ID, name, and description

### 3. Data Access Objects (DAOs)

#### ResourceDAO.java
Located at: `src/main/java/com/uninest/model/dao/ResourceDAO.java`

**Key Methods:**
- `findById(int resourceId)` - Get a specific resource with full details
- `findByUserId(int userId)` - Get all resources uploaded by a user
- `findByUserIdAndCategory(int userId, int categoryId)` - Filter by category
- `findPendingBySubjectIds(List<Integer> subjectIds)` - Get pending resources for coordinator approval
- `create(Resource resource)` - Upload a new resource
- `approve(int resourceId, int approverId)` - Approve a resource submission
- `reject(int resourceId, int approverId)` - Reject a resource submission
- `delete(int resourceId)` - Delete a resource

#### ResourceCategoryDAO.java
Located at: `src/main/java/com/uninest/model/dao/ResourceCategoryDAO.java`

**Key Methods:**
- `findAll()` - Get all resource categories
- `findById(int categoryId)` - Get a specific category
- `findByName(String categoryName)` - Find category by name

### 4. Controllers

#### Student Controllers

##### StudentResourcesServlet.java
- **URL Pattern:** `/student/resources`
- **Purpose:** Display all resources uploaded by the student
- **Features:**
  - Category-based filtering via query parameter
  - Grid and table view support
  - Status badges (pending, approved, rejected)

##### UploadResourceServlet.java
- **URL Pattern:** `/student/resources/upload`
- **Purpose:** Handle resource upload
- **Features:**
  - File upload (max 20MB)
  - Link-based resource submission
  - Subject and topic selection
  - Category selection
  - File validation
  - Automatic thumbnail generation based on file type

#### Coordinator Controllers

##### ResourceApprovalsServlet.java
- **URL Pattern:** `/coordinator/resource-approvals`
- **Purpose:** Display pending resources for approval
- **Access Control:** Only accessible to users who are subject coordinators
- **Features:**
  - Shows resources from subjects the coordinator manages
  - Preview/download capability
  - Approve/reject actions

##### ApproveResourceServlet.java
- **URL Pattern:** `/coordinator/resource-approvals/approve`
- **Method:** POST
- **Purpose:** Approve a resource submission
- **Actions:** Sets status to 'approved', visibility to 'public', records approver

##### RejectResourceServlet.java
- **URL Pattern:** `/coordinator/resource-approvals/reject`
- **Method:** POST
- **Purpose:** Reject a resource submission
- **Actions:** Sets status to 'rejected', records approver

#### API Controllers

##### SubjectTopicsApiServlet.java
- **URL Pattern:** `/api/subjects/*/topics`
- **Purpose:** AJAX endpoint for fetching topics by subject
- **Returns:** JSON array of topics

### 5. Views (JSP Pages)

#### resources.jsp
Located at: `src/main/webapp/WEB-INF/views/student/resources.jsp`

**Features:**
- Tab-based category filtering
- Grid view with file-type-based thumbnails
- Table view with detailed information
- Empty state for no resources
- Status badges (pending/approved/rejected)
- View toggle between grid and table
- Upload success notification

**UI Components:**
- Breadcrumb navigation
- Category tabs
- Upload button in page header
- View toggle buttons
- Empty state with icon and call-to-action

#### upload-resource.jsp
Located at: `src/main/webapp/WEB-INF/views/student/upload-resource.jsp`

**Features:**
- Form validation
- Subject and topic dropdowns (cascading)
- Category selection
- Upload mode toggle (file vs link)
- File type restrictions
- File size limit (20MB)
- Drag-and-drop support

**Form Fields:**
- Title (required)
- Description (optional)
- Subject (required, dropdown)
- Topic (required, dropdown - populated via AJAX)
- Category (required, dropdown)
- File/Link (required, based on mode)

#### resource-approvals.jsp
Located at: `src/main/webapp/WEB-INF/views/coordinator/resource-approvals.jsp`

**Features:**
- Pending resources table
- Resource preview/download
- Approve/reject buttons
- Empty state when no pending resources
- Success/error notifications

### 6. Navigation Updates

#### Student Dashboard
- Added "My Resources" link to main navigation
- Links to `/student/resources`
- Active state indication

#### Coordinator Section
- Conditionally displayed in student dashboard if user is a coordinator
- Visual divider separating student and coordinator sections
- "Resource Approvals" link

### 7. Styling

#### CSS Updates
Located at: `src/main/webapp/static/dashboard.css`

**New Styles Added:**
- `.c-empty-state` - Empty state container
- `.c-empty-state__icon` - Icon wrapper
- `.c-empty-state__title` - Empty state title
- `.c-empty-state__message` - Empty state message
- `.c-nav__divider` - Navigation section divider
- `.c-nav__label` - Navigation section label
- `.c-badge--warning` - Warning badge (pending status)
- `.c-badge--success` - Success badge (approved status)
- `.c-badge--danger` - Danger badge (rejected status)
- `.c-table-actions` - Improved table action buttons layout

#### File Type Thumbnails
Dynamic thumbnail generation based on file type:
- PDF, DOC, DOCX, TXT → file-text icon
- PPT, PPTX → file-input icon
- XLS, XLSX → table icon
- JPG, PNG, GIF → image icon
- MP4, MOV → film icon
- ZIP, RAR → file-archive icon
- Links → link icon

### 8. Workflow

#### Student Workflow:
1. Student navigates to "My Resources" page
2. Clicks "Upload Resource" button
3. Fills in resource details (title, description, subject, topic, category)
4. Chooses upload method (file or link)
5. Submits the form
6. Resource is saved with "pending" status
7. Student is redirected to resources page with success message
8. Resource appears in their list with "pending" badge

#### Coordinator Workflow:
1. Coordinator sees "Resource Approvals" link in navigation (if they coordinate any subject)
2. Navigates to approval page
3. Sees list of pending resources for their subjects
4. Can preview/download resources
5. Approves or rejects submissions
6. Approved resources become public and visible to all students
7. Rejected resources remain private

### 9. Security Considerations

- File upload size limit: 20MB
- Allowed file types: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, TXT, ZIP
- File storage in secure upload directory
- Coordinator role validation on approval/rejection endpoints
- Subject-coordinator relationship validation
- User authentication required for all endpoints

### 10. Database Migrations

Run the SQL script to create new tables:
```bash
mysql -u [username] -p [database] < src/main/resources/db/migration/db.sql
```

The script includes:
- CREATE TABLE statements for resource_categories and resources
- INSERT statements for 10 pre-populated categories

### 11. Testing Checklist

#### Student Features:
- [ ] Navigate to My Resources page
- [ ] View empty state when no resources uploaded
- [ ] Click Upload Resource button
- [ ] Fill form with valid data
- [ ] Upload a file successfully
- [ ] Upload a link successfully
- [ ] View uploaded resource in resources list
- [ ] Filter resources by category
- [ ] Toggle between grid and table views
- [ ] See correct status badges

#### Coordinator Features:
- [ ] Verify coordinator menu appears only for coordinators
- [ ] Navigate to Resource Approvals page
- [ ] View pending resources
- [ ] Preview/download a resource
- [ ] Approve a resource
- [ ] Verify approved resource becomes public
- [ ] Reject a resource
- [ ] Verify rejected resource status updates

#### Integration:
- [ ] Subject-topic dropdown cascade works
- [ ] File type validation works
- [ ] File size limit enforced
- [ ] Success/error notifications display correctly
- [ ] Navigation highlights correct active page

### 12. Future Enhancements

Potential improvements for future iterations:
- Resource search functionality
- Resource ratings and comments
- Resource download analytics
- Bulk approval for coordinators
- Resource versioning
- Notification system for approval/rejection
- Resource tags and advanced filtering
- Resource visibility controls (share with specific groups)
- Resource expiration dates
- Resource edit functionality

## Deployment Notes

1. **Database Setup**: Run the migration script to create new tables
2. **Upload Directory**: Ensure `uploads/resources` directory exists and is writable
3. **Build**: Run `mvn clean package` to create WAR file
4. **Deploy**: Deploy `target/uninest.war` to Tomcat server
5. **Testing**: Verify all functionality in development environment before production deployment

## File Summary

### New Java Files (11 files):
1. `src/main/java/com/uninest/model/Resource.java`
2. `src/main/java/com/uninest/model/ResourceCategory.java`
3. `src/main/java/com/uninest/model/dao/ResourceDAO.java`
4. `src/main/java/com/uninest/model/dao/ResourceCategoryDAO.java`
5. `src/main/java/com/uninest/controller/student/StudentResourcesServlet.java`
6. `src/main/java/com/uninest/controller/student/UploadResourceServlet.java`
7. `src/main/java/com/uninest/controller/coordinator/ResourceApprovalsServlet.java`
8. `src/main/java/com/uninest/controller/coordinator/ApproveResourceServlet.java`
9. `src/main/java/com/uninest/controller/coordinator/RejectResourceServlet.java`
10. `src/main/java/com/uninest/controller/api/SubjectTopicsApiServlet.java`

### New JSP Files (3 files):
1. `src/main/webapp/WEB-INF/views/student/resources.jsp`
2. `src/main/webapp/WEB-INF/views/student/upload-resource.jsp`
3. `src/main/webapp/WEB-INF/views/coordinator/resource-approvals.jsp`

### Modified Files (4 files):
1. `src/main/resources/db/migration/db.sql` - Added tables
2. `src/main/webapp/WEB-INF/tags/layouts/student-dashboard.tag` - Added navigation
3. `src/main/java/com/uninest/controller/student/StudentDashboardServlet.java` - Added coordinator check
4. `src/main/webapp/static/dashboard.css` - Added styles
5. `src/main/java/com/uninest/model/dao/SubjectCoordinatorDAO.java` - Added findByUserId method

## Support

For questions or issues with this implementation, please refer to:
- Code comments in the source files
- Existing patterns in similar features (e.g., join requests, subject management)
- Database schema documentation
