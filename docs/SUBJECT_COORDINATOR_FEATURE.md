# Subject Coordinator Feature

## Overview
This feature allows moderators to assign subject coordinators from students in their community. A subject coordinator is a student assigned to manage a specific subject. Each student can only be a coordinator for one subject at a time.

## Database Schema

### Table: subject_coordinators
```sql
CREATE TABLE `subject_coordinators` (
  `coordinator_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coordinator_id`),
  UNIQUE KEY `unique_user` (`user_id`),
  INDEX `idx_coordinator_subject` (`subject_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Important:** The `UNIQUE` constraint on `user_id` ensures that one coordinator can manage only one subject.

## User Flows

### Flow 1: Assign Coordinators from Subject Management Page
1. Moderator navigates to Subjects page (grid or list view)
2. Clicks the "user-plus" icon button on a subject card/row
3. Views current coordinators for that subject (if any)
4. Clicks "Assign New Coordinator" button
5. Selects one or more students from the available list
6. Submits the form to assign coordinators

### Flow 2: View All Coordinators Globally
1. Moderator clicks "Subject Coordinators" in the sidebar
2. Views all coordinators across all subjects in the community
3. Can navigate to specific subject's coordinator page by clicking subject links

### Flow 3: Unassign a Coordinator
1. Moderator views coordinators for a specific subject
2. Clicks "Remove" button next to a coordinator
3. Confirms the action
4. Coordinator is unassigned and can be assigned to another subject

## Components

### Backend Components

#### Models
- **SubjectCoordinator.java** - Model class representing the coordinator assignment with joined display fields

#### DAOs
- **SubjectCoordinatorDAO.java** - Data access layer with methods:
  - `findBySubjectId(int)` - Get coordinators for a subject
  - `findByCommunityId(int)` - Get all coordinators in a community
  - `assign(int userId, int subjectId)` - Assign a coordinator
  - `unassign(int coordinatorId)` - Remove coordinator assignment
  - `isCoordinator(int userId)` - Check if user is already a coordinator
  - `isCoordinatorForSubject(int userId, int subjectId)` - Check specific assignment

#### Servlets
- **SubjectCoordinatorsServlet.java** - `/moderator/subject-coordinators` - List coordinators for a specific subject
- **AssignCoordinatorServlet.java** - `/moderator/subject-coordinators/assign` - Assign new coordinators (GET: show form, POST: process assignment)
- **UnassignCoordinatorServlet.java** - `/moderator/subject-coordinators/unassign` - Remove coordinator assignment
- **AllCoordinatorsServlet.java** - `/moderator/coordinators` - Global view of all coordinators

### Frontend Components

#### JSP Pages
- **subject-coordinators.jsp** - Shows coordinators for a specific subject with data table and empty state
- **assign-coordinator.jsp** - Multi-select interface for assigning students as coordinators
- **all-coordinators.jsp** - Global listing of all coordinators with subject information

#### UI Updates
- Added "user-plus" icon button to subject cards in `subjects-grid.jsp`
- Added "user-plus" icon button to subject rows in `subjects-list.jsp`
- Added "Subject Coordinators" menu item to `moderator-dashboard.tag` sidebar

## Design Decisions

1. **One Coordinator Per Subject Rule**: The UNIQUE constraint on `user_id` enforces that a student can only be coordinator for one subject, matching the requirement.

2. **Filtering Available Students**: When assigning coordinators, the system automatically filters out students who are already coordinators for any subject.

3. **Empty State UI**: When no coordinators are assigned, the page shows a centered empty state with a call-to-action button.

4. **Consistent Styling**: All data tables use the same styling as the students page, including user avatars, academic year, and university information.

5. **Breadcrumb Navigation**: Clear breadcrumb paths help users understand their location in the navigation hierarchy.

6. **Action Buttons**: Each coordinator row has a "Remove" button for easy unassignment, with confirmation dialog.

## URL Patterns

- `/moderator/subject-coordinators?subjectId={id}` - View coordinators for a subject
- `/moderator/subject-coordinators/assign?subjectId={id}` - Assign new coordinators
- `/moderator/subject-coordinators/unassign` - Unassign a coordinator (POST)
- `/moderator/coordinators` - Global coordinator view

## Security Considerations

1. All servlets verify that the moderator has a community assigned
2. Subject ownership is verified before allowing coordinator management
3. Only students from the same community can be assigned as coordinators
4. Duplicate assignments are prevented by checking existing coordinator status

## Future Enhancements

- Add search/filter functionality in the coordinator lists
- Add bulk unassign capability
- Add coordinator permissions (allow them to manage their assigned subject)
- Add notifications when a student is assigned/unassigned as coordinator
