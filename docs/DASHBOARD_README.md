# Dashboard Component System

> Modern, reusable, scalable dashboard UI for UniNest

## Quick Start

### 1. Create a New Dashboard

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:dashboard title="My Dashboard" pageTitle="Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item href="/dashboard" icon="home" label="Home" active="${true}" />
    <dash:nav-item href="/profile" icon="user" label="Profile" active="${false}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <dash:section title="Overview">
      <dash:grid>
        <dash:card title="Card 1" meta="Description" />
        <dash:card title="Card 2" meta="Description" />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
</layout:dashboard>
```

### 2. Component Reference

| Component   | Purpose             | Required Attributes     |
| ----------- | ------------------- | ----------------------- |
| `dashboard` | Main layout         | -                       |
| `nav-item`  | Navigation link     | `href`, `icon`, `label` |
| `card`      | Content card        | `title`                 |
| `section`   | Content section     | `title`                 |
| `grid`      | Card grid container | -                       |

### 3. Icon Names

Common icons from [Lucide](https://lucide.dev/icons):

- `home` - Home/Dashboard
- `user` - User/Profile
- `users` - Multiple users
- `book` - Books/Subjects
- `settings` - Settings
- `log-out` - Logout
- `upload` - Upload
- `download` - Download
- `bar-chart` - Analytics

See [DASHBOARD_GUIDE.md](DASHBOARD_GUIDE.md) for complete documentation.

## Features

✨ **Modern UI** - Clean, professional design  
🌓 **Dark Mode** - Automatic theme switching  
📱 **Responsive** - Works on all devices  
♿ **Accessible** - ARIA labels, keyboard navigation  
🔧 **Reusable** - Component-based architecture  
📚 **Documented** - Comprehensive guides

## File Structure

```
src/main/webapp/
├── static/
│   ├── dashboard.css        # Dashboard styles
│   ├── dashboard.js         # Dashboard logic
│   ├── img/logo.png         # Logo
│   └── vendor/lucide.js     # Icons
└── WEB-INF/
    └── tags/
        ├── layouts/
        │   └── dashboard.tag    # Main layout
        └── dashboard/
            ├── nav-item.tag            # Navigation
            ├── card.tag                # Content card
            ├── section.tag             # Section
            └── grid.tag                # Grid layout
```

## Documentation

- **[DASHBOARD_GUIDE.md](DASHBOARD_GUIDE.md)** - Complete usage guide
- **[DASHBOARD_MIGRATION_SUMMARY.md](DASHBOARD_MIGRATION_SUMMARY.md)** - Migration details

## Examples

See working implementations:

- `views/admin/dashboard.jsp`
- `views/student/dashboard.jsp`
- `views/moderator/dashboard.jsp`
- `views/coordinator/dashboard.jsp`

## Component API

### `<layout:dashboard>`

Main dashboard layout with sidebar and theme toggle.

**Attributes:**

- `title` - Browser tab title
- `pageTitle` - Main page heading

**Fragments:**

- `name` - Navigation items (required)
- `content` - Page content (required)
- `alerts` - Alert messages
- `scripts` - Page scripts

### `<dash:nav-item>`

Navigation link with icon.

**Attributes:**

- `href` (required) - Link URL
- `icon` (required) - Lucide icon name
- `label` (required) - Link text
- `active` - Boolean, if active page

### `<dash:card>`

Content card with title and metadata.

**Attributes:**

- `title` (required) - Card title
- `meta` - Subtitle/metadata
- `mediaClass` - CSS class for media area

### `<dash:section>`

Section with title for content organization.

**Attributes:**

- `title` (required) - Section heading

### `<dash:grid>`

Responsive grid for cards.

**Attributes:**

- `columns` - "auto" for auto-fit, default is 4-column

## CSS Classes

### Layout

- `.l-app` - App container
- `.c-sidebar` - Sidebar
- `.c-page` - Main content
- `.c-page__header` - Page header

### Components

- `.c-nav__item` - Navigation link
- `.c-card` - Card
- `.c-section-title` - Section heading

### Grid

- `.o-grid` - Grid container
- `.o-grid--cards` - 4-column grid
- `.o-grid--auto` - Auto-fit grid

### Utilities

- `.u-bg-surface` - Surface background
- `.u-text-muted` - Muted text
- `.u-sr-only` - Screen reader only

## Theme Support

The dashboard includes automatic dark/light theme support:

```javascript
// Theme is automatically applied based on system preference
// Users can toggle with the button in top-right corner
// Preference is saved in localStorage
```

## Best Practices

1. **Use components** - Always use tag components instead of raw HTML
2. **Active states** - Mark current page as active in navigation
3. **Consistent icons** - Use appropriate, recognizable icons
4. **Section organization** - Use sections to organize content
5. **Grid layouts** - Use grid component for consistent spacing

## Customization

### Custom Styles

Add page-specific styles:

```jsp
<layout:dashboard title="My Page">
  <jsp:attribute name="scripts">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/custom.css" />
  </jsp:attribute>
  ...
</layout:dashboard>
```

### Custom JavaScript

Add page-specific scripts:

```jsp
<layout:dashboard title="My Page">
  <jsp:attribute name="scripts">
    <script>
      // Your JavaScript here
    </script>
  </jsp:attribute>
  ...
</layout:dashboard>
```

## Troubleshooting

### Icons not showing

- Ensure `lucide.js` is loaded
- Check icon name spelling
- Wait for `DOMContentLoaded`

### Theme toggle not working

- Check `dashboard.js` is loaded
- Clear localStorage if needed
- Check browser console for errors

### Cards not in grid

- Ensure cards are inside `<dash:grid>`
- Check CSS is loaded properly

## Support

For issues or questions:

1. Check documentation: [DASHBOARD_GUIDE.md](DASHBOARD_GUIDE.md)
2. Review examples in `views/*/dashboard.jsp`
3. Check CSS comments in `dashboard.css`
4. Review JS docs in `dashboard.js`

## Version

**Current Version:** 1.0  
**Build Status:** ✅ Passing  
**Last Updated:** October 2025

---

Built with ❤️ for UniNest
