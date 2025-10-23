# Subject & Topic Management System

## Overview
The moderator can now manage subjects and topics within their community. This feature provides full CRUD operations for both subjects and topics, with grid and list view options.

## Features Implemented

### Subject Management
- **Grid View**: `/moderator/subjects` - Display subjects as cards grouped by semester
- **List View**: `/moderator/subjects?view=list` - Display subjects in a sortable datatable
- **Create Subject**: `/moderator/subjects/create` - Form to create a new subject
- **Edit Subject**: `/moderator/subjects/edit?id={subjectId}` - Form to edit an existing subject
- **Delete Subject**: POST to `/moderator/subjects/delete` - Delete a subject (cascade deletes topics)

### Topic Management
- **Grid View**: `/moderator/topics?subjectId={id}` - Display topics as cards
- **List View**: `/moderator/topics?subjectId={id}&view=list` - Display topics in a sortable datatable
- **Create Topic**: `/moderator/topics/create?subjectId={id}` - Form to create a new topic
- **Edit Topic**: `/moderator/topics/edit?id={topicId}&subjectId={id}` - Form to edit an existing topic
- **Delete Topic**: POST to `/moderator/topics/delete` - Delete a topic

## Database Schema

### Subjects Table
```sql
CREATE TABLE subjects (
  subject_id INT AUTO_INCREMENT PRIMARY KEY,
  community_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  code VARCHAR(50),
  academic_year TINYINT NOT NULL,
  semester TINYINT NOT NULL,
  status ENUM('upcoming', 'ongoing', 'completed') DEFAULT 'upcoming',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE
);
```

### Topics Table
```sql
CREATE TABLE topics (
  topic_id INT AUTO_INCREMENT PRIMARY KEY,
  subject_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE
);
```

## Navigation Flow

1. **Moderator Dashboard** → Click "Subjects" in sidebar
2. **Subjects (Grid/List)** → View all subjects for the moderator's community
3. **Create Subject** → Click "+ Create Subject" button
4. **View Topics** → Click on a subject card or folder icon
5. **Topics (Grid/List)** → View all topics for the selected subject
6. **Create Topic** → Click "+ Create Topic" button
7. **Edit/Delete** → Use action buttons (pencil/trash icons)

## URL Pattern
- All topic-related URLs include `subjectId` parameter to maintain context
- View switching is done via `?view=list` or `?view=grid` (grid is default)
- Success messages are shown via URL parameters (e.g., `?success=created`)

## Demo Data
The system includes demo subjects and topics for testing:
- 12 subjects across 5 communities
- 20 topics distributed among various subjects
- Subjects cover different academic years (1-3) and semesters (1-2)
- Status options: upcoming, ongoing, completed

## UI Components
- **subjects.css**: Styling for subject/topic cards, view switcher, status badges
- **Grid View**: Cards with subject code as colorful thumbnail
- **List View**: Sortable datatable with inline actions
- **Forms**: Clean, accessible forms with validation

## Testing Checklist

### Subject Tests
- [ ] View subjects in grid mode
- [ ] View subjects in list mode
- [ ] Create a new subject
- [ ] Edit an existing subject
- [ ] Delete a subject (confirm cascade delete of topics)
- [ ] Search subjects (if implemented)
- [ ] Sort subjects in list view
- [ ] Verify subjects are filtered by moderator's community

### Topic Tests
- [ ] View topics in grid mode
- [ ] View topics in list mode
- [ ] Create a new topic
- [ ] Edit an existing topic
- [ ] Delete a topic
- [ ] Navigate from subject to topics
- [ ] Verify subjectId is maintained in all URLs
- [ ] Breadcrumb navigation works correctly

### Authorization Tests
- [ ] Moderator can only access subjects in their community
- [ ] Moderator can only access topics for subjects in their community
- [ ] Non-moderators cannot access these pages

## Notes
- All operations check that the moderator has a community_id assigned
- Delete operations include confirmation dialogs
- Success/error messages are displayed as alerts
- UI maintains consistency with existing moderator dashboard
