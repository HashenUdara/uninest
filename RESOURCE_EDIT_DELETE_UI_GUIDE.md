# Resource Edit & Delete - UI/UX Guide

## User Interface Overview

This document describes the visual and interactive elements added for resource editing and deletion.

---

## 1. My Resources View - Table Actions

### Before (Original)
```
┌─────────────────────────────────────────────────────────────┐
│ Title        │ Subject │ Topic  │ Category │ Status  │ Actions │
├─────────────────────────────────────────────────────────────┤
│ Study Notes  │ CS101   │ Java   │ Notes    │ Pending │ 👁 📥   │
└─────────────────────────────────────────────────────────────┘
```
- 👁 = View details
- 📥 = Download (only for approved)

### After (Enhanced)
```
┌────────────────────────────────────────────────────────────────┐
│ Title        │ Subject │ Topic  │ Category │ Status  │ Actions  │
├────────────────────────────────────────────────────────────────┤
│ Study Notes  │ CS101   │ Java   │ Notes    │ Pending │ 👁 ✏️ 🗑️ │
└────────────────────────────────────────────────────────────────┘
```
- 👁 = View details
- ✏️ = Edit resource (NEW)
- 🗑️ = Delete resource (NEW, with red styling)

**Note**: In topic-specific views (when viewing a topic's resources), only 👁 and 📥 are shown.

---

## 2. Resource Detail Page - Action Bar

### Before (Original)
```
┌───────────────────────────────────────────────────────┐
│                                            [Open] [↓] │
└───────────────────────────────────────────────────────┘
```

### After (Enhanced) - For Resource Owner
```
┌───────────────────────────────────────────────────────┐
│ [Edit] [Delete]                          [Open] [↓]   │
└───────────────────────────────────────────────────────┘
```
- Edit button: Opens edit form
- Delete button: Shows confirmation, then deletes (red styling)

### For Non-Owner (Viewing Someone Else's Resource)
```
┌───────────────────────────────────────────────────────┐
│                                            [Open] [↓] │
└───────────────────────────────────────────────────────┘
```
No change - edit/delete buttons only visible to owner.

---

## 3. Edit Resource Form

### Layout (3-Tab Interface)

```
┌──────────────────────────────────────────────────────────────┐
│ Edit Resource                                                 │
├──────────────────────────────────────────────────────────────┤
│ Resource Title *                                             │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ Advanced Java Programming                                ││
│ └──────────────────────────────────────────────────────────┘│
│                                                              │
│ Description                                                  │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ Comprehensive notes covering OOP concepts...             ││
│ └──────────────────────────────────────────────────────────┘│
│                                                              │
│ Select Subject *        Select Topic *                       │
│ ┌────────────────┐     ┌────────────────┐                  │
│ │ CS101 - Java   ▼│     │ OOP Basics     ▼│                  │
│ └────────────────┘     └────────────────┘                  │
│                                                              │
│ Select Category *                                            │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ Lecture Notes                                            ▼││
│ └──────────────────────────────────────────────────────────┘│
│                                                              │
│ ⚠️  Note: This resource is currently approved. Editing it   │
│     will reset its status to "pending" and require          │
│     re-approval by the subject coordinator.                 │
│                                                              │
│ [Keep existing file] [Upload new file] [Use new link]       │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Current File:                                                │
│ resources/1698234567_notes.pdf (pdf)                         │
│                                                              │
│ [Cancel]                                    [Save Changes]   │
└──────────────────────────────────────────────────────────────┘
```

### Tab 1: Keep existing file (Default)
Shows current file information, no upload required.

### Tab 2: Upload new file
```
┌──────────────────────────────────────────────────────────────┐
│ Choose File *                                                │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ [Choose File] No file chosen                             ││
│ └──────────────────────────────────────────────────────────┘│
│ Supported formats: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX,   │
│ TXT, ZIP (Max 50MB)                                          │
└──────────────────────────────────────────────────────────────┘
```

### Tab 3: Use new link
```
┌──────────────────────────────────────────────────────────────┐
│ Resource Link *                                              │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ https://drive.google.com/...                             ││
│ └──────────────────────────────────────────────────────────┘│
│ Make sure the link is publicly accessible or shared with    │
│ the right audience.                                          │
└──────────────────────────────────────────────────────────────┘
```

---

## 4. Delete Confirmation Dialog

### Browser Confirmation (JavaScript Alert)
```
┌─────────────────────────────────────────────────────┐
│  ⚠️  Confirm                                         │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Are you sure you want to delete this resource?    │
│  This action cannot be undone.                     │
│                                                     │
│                           [Cancel]  [OK]           │
└─────────────────────────────────────────────────────┘
```

---

## 5. Success/Error Messages

### Edit Success
```
┌──────────────────────────────────────────────────────────────┐
│ ✓ Resource updated successfully!                             │
└──────────────────────────────────────────────────────────────┘
```

### Delete Success
```
┌──────────────────────────────────────────────────────────────┐
│ ✓ Resource deleted successfully.                             │
└──────────────────────────────────────────────────────────────┘
```

### Error (Authorization)
```
┌──────────────────────────────────────────────────────────────┐
│ ✗ Error: You can only edit your own resources.               │
└──────────────────────────────────────────────────────────────┘
```

---

## 6. Status Badge Changes

### Before Edit (Approved Resource)
```
Resource Title: Advanced Java Notes
Status: ┌──────────┐
        │ Approved │ (Green badge)
        └──────────┘
```

### After Edit (Status Reset)
```
Resource Title: Advanced Java Notes (Updated)
Status: ┌─────────┐
        │ Pending │ (Orange/Yellow badge)
        └─────────┘
```

---

## 7. Responsive Behavior

### Desktop
- Full table with all columns visible
- Icon buttons with tooltips
- Side-by-side form fields

### Mobile
- Stack form fields vertically
- Larger touch targets for buttons
- Scrollable table with essential columns

---

## 8. Color Coding

### Buttons
- **Edit**: Ghost style (transparent background, subtle border)
- **Delete**: Ghost + Danger style (red text/icon)
- **Save Changes**: Primary style (blue background)
- **Cancel**: Ghost style

### Alerts
- **Success**: Green background
- **Warning**: Orange/yellow background  
- **Error**: Red background

### Status Badges
- **Approved**: Green
- **Pending**: Orange/Yellow
- **Rejected**: Red

---

## 9. Accessibility Features

### Keyboard Navigation
- Tab through all form fields
- Enter to submit forms
- Escape to close dialogs
- Space/Enter to activate buttons

### ARIA Labels
```html
<button aria-label="Edit resource">
  <i data-lucide="edit"></i>
</button>

<button aria-label="Delete resource">
  <i data-lucide="trash-2"></i>
</button>
```

### Screen Reader Announcements
- "Resource updated successfully"
- "Are you sure you want to delete this resource? This action cannot be undone."
- "Edit resource: Advanced Java Notes"

---

## 10. Animation/Transitions

### Button Hover States
- Slight color change
- Subtle scale effect (1.02x)
- Smooth transition (200ms)

### Alert Messages
- Fade in on display
- Auto-dismiss after 5 seconds (for success messages)
- Close button available

### Form Validation
- Real-time validation on blur
- Error messages appear below fields
- Required field indicators (red asterisk)

---

## 11. Icon Reference

### Lucide Icons Used
- `edit` - Edit button
- `trash-2` - Delete button
- `save` - Save changes button
- `upload` - Upload file tab
- `link` - Use link tab
- `file-text` - Keep existing file tab
- `eye` - View details
- `download` - Download file
- `external-link` - Open link (for link-type resources)

---

## Summary

The UI enhancements provide:
1. **Clear Visual Hierarchy**: Edit/Delete separated from view/download
2. **Safety Measures**: Confirmation dialogs, warning messages
3. **Consistency**: Matches existing design system and patterns
4. **Accessibility**: Keyboard navigation, ARIA labels, screen reader support
5. **Feedback**: Success/error messages, status updates
6. **Context Awareness**: Buttons shown only when appropriate
7. **Responsive**: Works on all device sizes

All styling uses existing CSS classes from the application's design system (`c-btn`, `c-alert`, `c-badge`, etc.), ensuring visual consistency across the application.
