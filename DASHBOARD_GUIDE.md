# Dashboard UI Integration Guide

This guide explains how to use the new modern dashboard layout and components in UniNest.

## Overview

The new dashboard UI provides a clean, modern interface with:
- Sidebar navigation with icons
- Dark/light theme toggle
- Reusable component tags
- Responsive design
- Professional typography and spacing

## Architecture

### Files Structure
```
src/main/webapp/
├── static/
│   ├── dashboard.css         # Main dashboard styles (from app.css)
│   ├── dashboard.js          # Dashboard functionality (theme toggle, etc.)
│   ├── img/
│   │   └── logo.png         # UniNest logo
│   └── vendor/
│       └── lucide.js        # Icon library
└── WEB-INF/
    ├── tags/
    │   ├── layouts/
    │   │   └── modern-dashboard.tag  # Main dashboard layout
    │   └── dashboard/
    │       ├── nav-item.tag         # Navigation item component
    │       └── card.tag             # Card component
    └── views/
        ├── admin/dashboard.jsp
        ├── student/dashboard.jsp
        ├── moderator/dashboard.jsp
        └── coordinator/dashboard.jsp
```

## Using the Dashboard Layout

### Basic Usage

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:modern-dashboard title="My Dashboard" pageTitle="Dashboard Title">
  <jsp:attribute name="name">
    <!-- Navigation items go here -->
    <dash:nav-item href="/path" icon="home" label="Dashboard" active="${true}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <!-- Page content goes here -->
    <dash:section title="Section Title">
      <dash:grid>
        <dash:card title="Card Title" meta="Card description" />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
</layout:modern-dashboard>
```

### Layout Attributes

- `title` - Browser tab title (optional)
- `pageTitle` - Main page heading (optional)
- `breadcrumb` - Breadcrumb navigation (optional)
- `active` - Currently active nav item (optional)
- `alerts` - Fragment for alert messages (optional)
- `scripts` - Fragment for page-specific scripts (optional)

## Reusable Components

### Navigation Item (`dash:nav-item`)

Creates a navigation link in the sidebar.

**Attributes:**
- `href` (required) - Link URL
- `icon` (required) - Lucide icon name (e.g., "home", "book", "user")
- `label` (required) - Link text
- `active` (optional) - Boolean, true if this is the active page

**Example:**
```jsp
<dash:nav-item 
  href="${pageContext.request.contextPath}/student/dashboard" 
  icon="home" 
  label="Dashboard" 
  active="${true}" />
```

### Card Component (`dash:card`)

Creates a content card with optional media area.

**Attributes:**
- `title` (required) - Card title
- `meta` (optional) - Subtitle or metadata text
- `mediaClass` (optional) - Additional CSS class for media area

**Example:**
```jsp
<dash:card 
  title="Data Structures" 
  meta="CS204 - Dr. Evelyn Reed" />
```

### Section Component (`dash:section`)

Creates a section with a title for organizing dashboard content.

**Attributes:**
- `title` (required) - Section title

**Example:**
```jsp
<dash:section title="My Subjects">
  <p>Content goes here</p>
</dash:section>
```

### Grid Component (`dash:grid`)

Creates a grid container for cards with responsive layout.

**Attributes:**
- `columns` (optional) - "auto" for auto-fit responsive grid, default is 4-column

**Example:**
```jsp
<dash:grid>
  <dash:card title="Card 1" meta="Description" />
  <dash:card title="Card 2" meta="Description" />
</dash:grid>

<!-- Auto-fit responsive grid -->
<dash:grid columns="auto">
  <dash:card title="Card 1" meta="Description" />
</dash:grid>
```

## CSS Classes

### Layout Classes
- `.l-app` - Main app container
- `.c-sidebar` - Sidebar navigation
- `.c-page` - Main content area
- `.c-page__header` - Page header area

### Component Classes
- `.c-nav__item` - Navigation link
- `.c-nav__icon` - Icon container
- `.c-card` - Card container
- `.c-card__body` - Card content
- `.c-card__title` - Card title
- `.c-card__meta` - Card metadata

### Grid Classes
- `.o-grid` - Grid container
- `.o-grid--cards` - 4-column card grid
- `.o-grid--auto` - Auto-fit responsive grid

### Typography
- `.c-section-title` - Section heading
- `.c-page__title` - Page title

### Utilities
- `.u-bg-surface` - Surface background color
- `.u-text-muted` - Muted text color
- `.u-sr-only` - Screen reader only

## Theme Toggle

The dashboard includes automatic dark/light theme support:
- System preference detection
- Manual toggle button (top right)
- Persistent preference (localStorage)

No additional code needed - it's automatic!

## Icons

Icons are provided by Lucide (https://lucide.dev/icons)

**Common icons:**
- `home` - Home/Dashboard
- `book` - Books/Subjects
- `user` - User/Profile
- `users` - Users/People
- `settings` - Settings
- `log-out` - Logout
- `graduation-cap` - Education
- `file-text` - Documents
- `bar-chart-3` - Analytics
- `message-square` - Messages
- `shield` - Security/Moderation
- `flag` - Reports
- `upload` - Upload
- `folder` - Folders

## Best Practices

1. **Consistent Navigation**: Use the same navigation structure across related dashboards
2. **Active States**: Always mark the current page as active
3. **Icon Selection**: Choose meaningful, recognizable icons
4. **Card Grids**: Use `.o-grid--cards` for consistent 4-column layouts
5. **Section Titles**: Use `.c-section-title` to organize content into sections
6. **Accessibility**: The layout includes ARIA labels and keyboard navigation support

## Customization

### Adding Custom Styles

Create a separate CSS file for page-specific styles:

```jsp
<layout:modern-dashboard title="My Page">
  <jsp:attribute name="scripts">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/my-custom.css" />
  </jsp:attribute>
  ...
</layout:modern-dashboard>
```

### Adding Page Scripts

```jsp
<layout:modern-dashboard title="My Page">
  <jsp:attribute name="scripts">
    <script>
      // Your custom JavaScript
    </script>
  </jsp:attribute>
  ...
</layout:modern-dashboard>
```

## Migration from Old Dashboard

To migrate an existing dashboard page:

1. Replace `<layout:page>` or `<layout:dashboard>` with `<layout:modern-dashboard>`
2. Replace navigation links with `<dash:nav-item>` components
3. Wrap content in `<jsp:attribute name="content">` tags
4. Move navigation to `<jsp:attribute name="name">` section
5. Replace section headings with `<dash:section>` components
6. Replace grid divs with `<dash:grid>` components
7. Replace old card HTML with `<dash:card>` components

**Before:**
```jsp
<layout:page title="Dashboard">
  <h2 class="c-section-title">My Items</h2>
  <div class="o-grid o-grid--cards">
    <article class="c-card">...</article>
  </div>
</layout:page>
```

**After:**
```jsp
<layout:modern-dashboard title="Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item href="..." icon="home" label="Dashboard" active="${true}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <dash:section title="My Items">
      <dash:grid>
        <dash:card title="..." meta="..." />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
</layout:modern-dashboard>
```

## Examples

### Complete Dashboard Example

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:modern-dashboard title="Student Dashboard" pageTitle="My Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/dashboard" 
      icon="home" 
      label="Dashboard" 
      active="${true}" />
    <dash:nav-item 
      href="#" 
      icon="book" 
      label="My Subjects" 
      active="${false}" />
    <dash:nav-item 
      href="#" 
      icon="user" 
      label="Profile" 
      active="${false}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <dash:section title="Welcome, ${sessionScope.authUser.email}">
      <p>Access your subjects, resources, and track your learning progress.</p>
    </dash:section>
    
    <dash:section title="My Subjects">
      <dash:grid>
        <dash:card title="Data Structures" meta="CS204 - Dr. Evelyn Reed" />
        <dash:card title="Algorithms" meta="CS205 - Prof. Michael Chen" />
        <dash:card title="Database Systems" meta="CS301 - Dr. Sarah Wilson" />
        <dash:card title="Web Development" meta="CS320 - Prof. James Anderson" />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
</layout:modern-dashboard>
```

### Real Examples

See the following files for complete, production-ready examples:
- `/WEB-INF/views/admin/dashboard.jsp` - Admin dashboard
- `/WEB-INF/views/student/dashboard.jsp` - Student dashboard
- `/WEB-INF/views/moderator/dashboard.jsp` - Moderator dashboard
- `/WEB-INF/views/coordinator/dashboard.jsp` - Coordinator dashboard

## Support

For issues or questions about the dashboard UI, refer to:
- CSS architecture: `dashboard.css` (ITCSS + BEM methodology)
- JavaScript functionality: `dashboard.js`
- Component definitions: `/WEB-INF/tags/dashboard/`
