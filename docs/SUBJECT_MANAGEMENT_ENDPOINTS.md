# Subject & Topic Management API Endpoints

## Subject Endpoints

### View Subjects (Grid View)
- **URL**: `/moderator/subjects`
- **Method**: GET
- **Description**: Display all subjects for moderator's community in grid view
- **Parameters**: None
- **Response**: Renders subjects-grid.jsp

### View Subjects (List View)
- **URL**: `/moderator/subjects?view=list`
- **Method**: GET
- **Description**: Display all subjects for moderator's community in list/table view
- **Parameters**: 
  - `view=list` (required)
- **Response**: Renders subjects-list.jsp

### Create Subject Form
- **URL**: `/moderator/subjects/create`
- **Method**: GET
- **Description**: Display form to create a new subject
- **Parameters**: None
- **Response**: Renders subject-form.jsp (empty form)

### Create Subject (Submit)
- **URL**: `/moderator/subjects/create`
- **Method**: POST
- **Description**: Create a new subject
- **Form Parameters**:
  - `name` (required): Subject name
  - `code`: Subject code (e.g., CS204)
  - `description`: Subject description
  - `academicYear` (required): 1-4
  - `semester` (required): 1-2
  - `status` (required): upcoming, ongoing, or completed
- **Success**: Redirect to `/moderator/subjects?success=created`
- **Error**: Re-render form with error message

### Edit Subject Form
- **URL**: `/moderator/subjects/edit?id={subjectId}`
- **Method**: GET
- **Description**: Display form to edit an existing subject
- **Parameters**:
  - `id` (required): Subject ID
- **Response**: Renders subject-form.jsp (pre-filled form)

### Edit Subject (Submit)
- **URL**: `/moderator/subjects/edit`
- **Method**: POST
- **Description**: Update an existing subject
- **Form Parameters**:
  - `id` (required): Subject ID
  - `name` (required): Subject name
  - `code`: Subject code
  - `description`: Subject description
  - `academicYear` (required): 1-4
  - `semester` (required): 1-2
  - `status` (required): upcoming, ongoing, or completed
- **Success**: Redirect to `/moderator/subjects?success=updated`
- **Error**: Re-render form with error message

### Delete Subject
- **URL**: `/moderator/subjects/delete`
- **Method**: POST
- **Description**: Delete a subject (cascade deletes all topics)
- **Form Parameters**:
  - `id` (required): Subject ID
- **Success**: Redirect to `/moderator/subjects?success=deleted`
- **Error**: Redirect to `/moderator/subjects?error=notfound`

## Topic Endpoints

### View Topics (Grid View)
- **URL**: `/moderator/topics?subjectId={id}`
- **Method**: GET
- **Description**: Display all topics for a subject in grid view
- **Parameters**:
  - `subjectId` (required): Subject ID
- **Response**: Renders topics-grid.jsp

### View Topics (List View)
- **URL**: `/moderator/topics?subjectId={id}&view=list`
- **Method**: GET
- **Description**: Display all topics for a subject in list/table view
- **Parameters**:
  - `subjectId` (required): Subject ID
  - `view=list` (required)
- **Response**: Renders topics-list.jsp

### Create Topic Form
- **URL**: `/moderator/topics/create?subjectId={id}`
- **Method**: GET
- **Description**: Display form to create a new topic
- **Parameters**:
  - `subjectId` (required): Subject ID
- **Response**: Renders topic-form.jsp (empty form)

### Create Topic (Submit)
- **URL**: `/moderator/topics/create`
- **Method**: POST
- **Description**: Create a new topic
- **Form Parameters**:
  - `subjectId` (required): Subject ID
  - `title` (required): Topic title
  - `description`: Topic description
- **Success**: Redirect to `/moderator/topics?subjectId={id}&success=created`
- **Error**: Re-render form with error message

### Edit Topic Form
- **URL**: `/moderator/topics/edit?id={topicId}&subjectId={subjectId}`
- **Method**: GET
- **Description**: Display form to edit an existing topic
- **Parameters**:
  - `id` (required): Topic ID
  - `subjectId` (required): Subject ID
- **Response**: Renders topic-form.jsp (pre-filled form)

### Edit Topic (Submit)
- **URL**: `/moderator/topics/edit`
- **Method**: POST
- **Description**: Update an existing topic
- **Form Parameters**:
  - `id` (required): Topic ID
  - `subjectId` (required): Subject ID
  - `title` (required): Topic title
  - `description`: Topic description
- **Success**: Redirect to `/moderator/topics?subjectId={id}&success=updated`
- **Error**: Re-render form with error message

### Delete Topic
- **URL**: `/moderator/topics/delete`
- **Method**: POST
- **Description**: Delete a topic
- **Form Parameters**:
  - `id` (required): Topic ID
  - `subjectId` (required): Subject ID
- **Success**: Redirect to `/moderator/topics?subjectId={id}&success=deleted`
- **Error**: Redirect to `/moderator/topics?subjectId={id}&error=notfound`

## Authorization

All endpoints require:
1. User must be logged in (authUser in session)
2. User must have moderator role (role_id = 3)
3. User must have a community_id assigned
4. For subject operations: Subject must belong to moderator's community
5. For topic operations: Topic's subject must belong to moderator's community

## Success/Error Parameters

### Success Messages
- `?success=created`: Item created successfully
- `?success=updated`: Item updated successfully
- `?success=deleted`: Item deleted successfully

### Error Messages
- `?error=notfound`: Item not found or access denied
- `?error=invalid`: Invalid parameters provided

## Navigation Flow

```
/moderator/subjects (Grid)
    |
    ├─> /moderator/subjects?view=list (List)
    |
    ├─> /moderator/subjects/create (Create Form)
    |       └─> POST /moderator/subjects/create
    |               └─> Redirect to /moderator/subjects?success=created
    |
    ├─> /moderator/subjects/edit?id={id} (Edit Form)
    |       └─> POST /moderator/subjects/edit
    |               └─> Redirect to /moderator/subjects?success=updated
    |
    ├─> POST /moderator/subjects/delete
    |       └─> Redirect to /moderator/subjects?success=deleted
    |
    └─> /moderator/topics?subjectId={id} (Grid)
            |
            ├─> /moderator/topics?subjectId={id}&view=list (List)
            |
            ├─> /moderator/topics/create?subjectId={id} (Create Form)
            |       └─> POST /moderator/topics/create
            |               └─> Redirect to /moderator/topics?subjectId={id}&success=created
            |
            ├─> /moderator/topics/edit?id={tid}&subjectId={id} (Edit Form)
            |       └─> POST /moderator/topics/edit
            |               └─> Redirect to /moderator/topics?subjectId={id}&success=updated
            |
            └─> POST /moderator/topics/delete
                    └─> Redirect to /moderator/topics?subjectId={id}&success=deleted
```
