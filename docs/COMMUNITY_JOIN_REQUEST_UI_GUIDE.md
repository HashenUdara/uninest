# Community Join Request - UI Visual Guide

## Page Layout

The join-community page uses the `auth` layout which provides:
- Centered content on the page
- Maximum width of 420px (auth form width)
- Clean, minimalist design
- Theme toggle in top-right corner
- White/dark mode support

## Visual States

### State 1: Initial Form (No Pending Request)

```
┌─────────────────────────────────────────────────┐
│                                                 │
│        Enter your community ID                  │
│     Ask your moderator for the approved         │
│            community ID.                        │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ Community ID                              │ │
│  │ ┌─────────────────────────────────────┐   │ │
│  │ │ e.g. 1024                           │   │ │
│  │ └─────────────────────────────────────┘   │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │              Join                         │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Colors:**
- Background: Light gray (--color-surface)
- Form background: White (--color-white)
- Primary button: Purple (#542cf5)
- Text: Dark gray (--color-text)
- Muted text: Light gray (--color-text-muted)
- Borders: Light gray (--color-border)

### State 2: Success Message After Submission

```
┌─────────────────────────────────────────────────┐
│                                                 │
│        Enter your community ID                  │
│     Ask your moderator for the approved         │
│            community ID.                        │
│                                                 │
│    ✓ Join request submitted! Please wait       │
│         for moderator approval.                 │
│               (in green #22c55e)                │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │  🕐  Pending Request                    │   │
│  │      Waiting for moderator approval     │   │
│  │                                         │   │
│  │  ┌───────────────────────────────────┐ │   │
│  │  │ Community:  React Study Group     │ │   │
│  │  ├───────────────────────────────────┤ │   │
│  │  │ Community ID:  1024               │ │   │
│  │  ├───────────────────────────────────┤ │   │
│  │  │ Status:  [PENDING]                │ │   │
│  │  └───────────────────────────────────┘ │   │
│  │                                         │   │
│  │  ┌───────────────────────────────────┐ │   │
│  │  │      Cancel Request               │ │   │
│  │  └───────────────────────────────────┘ │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Request Status Card Design:**
- Card background: White (--color-white)
- Border: 1px solid light gray (--color-border)
- Border radius: 8px (--radius-md)
- Padding: 24px (--space-6)
- Margin bottom: 24px

**Header Section:**
- Clock icon: 40x40px amber background circle
- Icon color: Amber (#f59e0b)
- Title: "Pending Request" (20px, semibold)
- Subtitle: "Waiting for moderator approval" (14px, muted)

**Details Section:**
- Background: Surface color (--color-surface)
- Border radius: 4px (--radius-sm)
- Padding: 16px (--space-4)
- Rows separated by borders
- Label: 14px, medium weight, muted
- Value: 14px, medium weight, dark

**Status Badge:**
- Background: rgba(245, 158, 11, 0.1) - amber with transparency
- Color: #f59e0b (amber)
- Padding: 4px 12px
- Border radius: 1000px (pill shape)
- Font size: 12px
- Font weight: Semibold
- Text: "PENDING" (uppercase)

**Cancel Button:**
- Full width
- Ghost style (outlined, not filled)
- Border: 1px solid
- Padding: 12px
- Border radius: 8px
- Text: "Cancel Request"
- Hover: Light background tint

### State 3: Error Message (Duplicate Request)

```
┌─────────────────────────────────────────────────┐
│                                                 │
│        Enter your community ID                  │
│     Ask your moderator for the approved         │
│            community ID.                        │
│                                                 │
│    ⚠ You already have a pending request.       │
│    Please cancel it first before submitting    │
│            a new one.                           │
│               (in red #d92c20)                  │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │  🕐  Pending Request                    │   │
│  │      Waiting for moderator approval     │   │
│  │  [... same as State 2 ...]              │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
└─────────────────────────────────────────────────┘
```

### State 4: After Cancellation Success

```
┌─────────────────────────────────────────────────┐
│                                                 │
│        Enter your community ID                  │
│     Ask your moderator for the approved         │
│            community ID.                        │
│                                                 │
│    ✓ Join request cancelled successfully.      │
│               (in green #22c55e)                │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ Community ID                              │ │
│  │ ┌─────────────────────────────────────┐   │ │
│  │ │ e.g. 1024                           │   │ │
│  │ └─────────────────────────────────────┘   │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │              Join                         │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Interactive Elements

### Cancel Request Button Interaction

1. **Normal State:**
   - Border: 1px solid gray
   - Background: Transparent
   - Text: Dark gray
   - Cursor: Pointer

2. **Hover State:**
   - Background: Light gray tint
   - Border remains same
   - Smooth transition (150ms)

3. **Click Behavior:**
   - Shows browser confirmation dialog
   - Dialog text: "Are you sure you want to cancel this join request?"
   - OK button: Submits form to cancel
   - Cancel button: Dismisses dialog

## Responsive Behavior

### Mobile (< 640px)
- Full width card
- Reduced padding (16px instead of 24px)
- Stacked layout for details rows
- Touch-friendly button size (minimum 44px height)

### Tablet (640px - 1024px)
- Centered card with max-width
- Standard padding
- Optimized for touch

### Desktop (> 1024px)
- Centered card with max-width (420px)
- Hover states enabled
- Keyboard navigation supported

## Accessibility Features

1. **Keyboard Navigation:**
   - Tab to navigate to Cancel button
   - Enter/Space to activate button
   - Focus outline visible on keyboard focus

2. **Screen Readers:**
   - Icon has `aria-hidden="true"`
   - Button has descriptive label
   - Status badge announces status
   - Confirmation dialog is announced

3. **Color Contrast:**
   - Text on white: 7:1 ratio (WCAG AAA)
   - Muted text: 4.5:1 ratio (WCAG AA)
   - Badge text: 4.5:1 ratio (WCAG AA)

4. **Focus Indicators:**
   - Purple focus ring (--shadow-focus)
   - 3px offset from element
   - High contrast

## Dark Mode Support

When dark mode is enabled (via theme toggle or system preference):

**Colors Change:**
- Background: Dark (#0d1117)
- Card background: Dark gray (#1b1f24)
- Text: Light gray (#f3f4f6)
- Muted text: Medium gray (#98a2b3)
- Borders: Dark border (#2e3440)
- Badge background: Amber with dark opacity
- Surface background: Darker shade

**Consistency:**
- All design tokens automatically adapt
- Smooth transition between modes
- Icons remain visible
- Contrast maintained

## Comparison with Existing UI

The request status card follows the same design patterns as:
- Admin/Moderator dashboard cards
- Community info cards
- User profile cards

**Shared Patterns:**
- Card-based layout
- Icon + text header
- Details section with key-value pairs
- Full-width action buttons
- Consistent spacing and typography
- Same border radius and shadows

**Design System Compliance:**
- Uses all CSS custom properties
- Follows BEM naming convention
- Matches existing component structure
- Responsive breakpoints align
- Accessibility standards match

## Implementation Notes

The UI is implemented using:
- **JSP/JSTL:** Conditional rendering logic
- **CSS:** Inline styles in JSP (component-scoped)
- **Lucide Icons:** Clock icon for pending status
- **Design Tokens:** All spacing, colors, fonts from :root
- **No JavaScript:** Pure CSS and HTML (except confirmation)

## Future UI Enhancements

Potential visual improvements:
1. Animated transitions when status card appears
2. Progress indicator showing "time waiting"
3. Avatar of moderator who needs to approve
4. Timeline showing request history
5. Estimated approval time based on historical data
6. Toast notifications instead of page refresh
7. Live updates using WebSocket when approved
