# UI Changes - Visual Overview

## Signup Page Updates

### Before (Original)
```
┌─────────────────────────────────────────────────────┐
│              Create your account                     │
├─────────────────────────────────────────────────────┤
│ Full Name           │ Email                         │
│ [____________]      │ [____________]                │
│                     │                               │
│ Password            │ Confirm Password              │
│ [____________]      │ [____________]                │
│                     │                               │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│ Password Strength: Weak                             │
│                                                      │
│ Select Your Role:                                   │
│ ○ Student - Access courses and materials           │
│ ○ Moderator - Manage content and users             │
│                                                      │
│            [Sign Up Button]                         │
└─────────────────────────────────────────────────────┘
```

### After (Updated)
```
┌─────────────────────────────────────────────────────┐
│              Create your account                     │
├─────────────────────────────────────────────────────┤
│ Full Name           │ Email                         │
│ [____________]      │ [____________]                │
│                     │                               │
│ Academic Year       │                               │  ← NEW
│ [Select your year▼] │                               │  ← NEW
│                     │                               │
│ University                                          │  ← NEW
│ [Select your university__________________▼]         │  ← NEW (full width)
│                                                      │
│ Password            │ Confirm Password              │
│ [____________]      │ [____________]                │
│                     │                               │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│ Password Strength: Weak                             │
│                                                      │
│ Select Your Role:                                   │
│ ○ Student - Access courses and materials           │
│ ○ Moderator - Manage content and users             │
│                                                      │
│            [Sign Up Button]                         │
└─────────────────────────────────────────────────────┘
```

### New Field Details

**Academic Year Dropdown:**
```
┌────────────────────┐
│ Select your year ▼ │
├────────────────────┤
│ 1st Year           │
│ 2nd Year           │
│ 3rd Year           │
│ 4th Year           │
└────────────────────┘
```

**University Dropdown:**
```
┌───────────────────────────────────────────────┐
│ Select your university ▼                      │
├───────────────────────────────────────────────┤
│ University of Colombo                         │
│ University of Peradeniya                      │
│ University of Sri Jayewardenepura             │
│ University of Kelaniya                        │
│ University of Moratuwa                        │
│ University of Jaffna                          │
│ University of Ruhuna                          │
│ Eastern University, Sri Lanka                 │
│ South Eastern University of Sri Lanka         │
│ Rajarata University of Sri Lanka              │
│ Sabaragamuwa University of Sri Lanka          │
│ Wayamba University of Sri Lanka               │
│ University of the Visual & Performing Arts    │
│ University of Vocational Technology           │
│ Open University of Sri Lanka                  │
└───────────────────────────────────────────────┘
```

## New Pending Approval Page

### Page Layout
```
┌─────────────────────────────────────────────────────┐
│                     ⏰                               │
│                  (clock icon)                       │
│                                                      │
│          Account Pending Approval                   │
│                                                      │
│  Your moderator account has been created            │
│  successfully. Please wait for an administrator     │
│  to approve your account before you can access      │
│  the system.                                        │
│                                                      │
│  You will receive an email notification once        │
│  your account has been approved.                    │
│                                                      │
│                                                      │
│              ← Back to Login                        │
│                                                      │
│         Terms of Service · Privacy Policy           │
└─────────────────────────────────────────────────────┘
```

## User Flow Diagrams

### Student Signup Flow
```
Start → Fill Form → Select "Student" → Submit
   ↓
Account Created (is_approved=1)
   ↓
Auto-Login
   ↓
Student Dashboard
```

### Moderator Signup Flow
```
Start → Fill Form → Select "Moderator" → Submit
   ↓
Account Created (is_approved=0)
   ↓
Redirect to Pending Approval Page
   ↓
Wait for Admin Approval
```

### Moderator Login (Unapproved)
```
Login Page → Enter Credentials → Submit
   ↓
Check is_approved
   ↓
is_approved = 0
   ↓
❌ Error: "Your moderator account is pending approval"
   ↓
Stay on Login Page
```

### Moderator Login (Approved)
```
Admin Updates Database (is_approved=1)
   ↓
Login Page → Enter Credentials → Submit
   ↓
Check is_approved
   ↓
is_approved = 1
   ↓
✅ Success → Moderator Dashboard
```

## Form Validation Messages

### Academic Year
- Required: "Please select your academic year"
- Invalid: "Invalid academic year selection"

### University
- Required: "Please select your university"
- Invalid: "Invalid university selection"

### Login Error (Unapproved Moderator)
```
┌─────────────────────────────────────────────────────┐
│              Login                                   │
├─────────────────────────────────────────────────────┤
│ ⚠️ Your moderator account is pending approval by    │
│    an administrator                                 │
│                                                      │
│ Email                                               │
│ [_________________________________]                 │
│                                                      │
│ Password                                            │
│ [_________________________________]                 │
│                                                      │
│            [Login Button]                           │
└─────────────────────────────────────────────────────┘
```

## Color and Style Notes

The new fields and pages use the existing CSS classes:
- `.c-field` - Form field container
- `.c-field__label` - Field labels
- `.c-field__input` - Input/select styling
- `.c-field__error` - Error messages
- `.c-state` - State message container (pending approval page)
- `.c-state__icon` - Icon container
- `.c-state__title` - State title
- `.c-state__text` - State description text

All styling matches the existing auth page design system with:
- Consistent spacing using CSS variables (`--space-*`)
- Matching typography (`--fs-*`)
- Same color scheme
- Responsive grid layout
- Lucide icons for visual elements

## Responsive Behavior

The form maintains a 2-column grid layout on desktop:
- Full Name and Email side by side
- Academic Year spans 1 column
- University spans full width (both columns)
- Password and Confirm Password side by side
- All other elements span full width

On mobile (handled by existing responsive CSS):
- Grid collapses to single column
- All fields stack vertically
- Maintains consistent spacing
