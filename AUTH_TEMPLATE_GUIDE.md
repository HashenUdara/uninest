# Authentication Template Integration Guide

## Overview

This document explains the reusable authentication template system integrated into the UniNest JSP application.

## Architecture

### 1. Layout Structure

The authentication pages use a dedicated `auth.tag` layout that provides:

- Clean, centered design without navigation headers/footers
- Dark mode toggle with persistent state
- Modern, accessible UI with proper ARIA labels
- Responsive design for mobile and desktop

### 2. Reusable Components

Located in `/WEB-INF/tags/auth/`, these tags provide standardized form elements:

#### `field.tag` - Form Input Field

Creates a styled input field with label and error messaging.

**Attributes:**

- `id` (required): Unique identifier for the input
- `name` (required): Form field name
- `label` (required): Display label text
- `type` (optional): Input type (default: "text")
- `placeholder` (optional): Placeholder text
- `required` (optional): Boolean for required validation
- `autocomplete` (optional): Autocomplete attribute
- `minlength` (optional): Minimum length validation
- `value` (optional): Pre-filled value
- `autofocus` (optional): Boolean for autofocus

**Example:**

```jsp
<auth:field
  id="email"
  name="email"
  label="Email"
  type="email"
  placeholder="Enter your email"
  required="true"
  autocomplete="email"
/>
```

#### `button.tag` - Primary Button

Creates a styled primary button.

**Attributes:**

- `text` (required): Button text
- `type` (optional): Button type (default: "submit")

**Example:**

```jsp
<auth:button text="Login" />
```

#### `link.tag` - Styled Link

Creates a styled link component.

**Attributes:**

- `href` (required): Link URL
- `text` (required): Link text
- `muted` (optional): Boolean for muted styling

**Example:**

```jsp
<auth:link href="/forgot-password" text="Forgot Password?" />
```

### 3. Static Assets

#### CSS (`/static/auth.css`)

- Modern design tokens (colors, spacing, typography)
- Dark mode support with automatic detection
- BEM methodology for maintainable styles
- Accessible focus states and error styling

#### JavaScript (`/static/auth.js`)

Features:

- **Theme Toggle**: Persistent dark/light mode with system preference detection
- **Form Validation**: Client-side validation with accessible error messages
- **Password Strength Meter**: Visual feedback for password strength

#### Icons (`/static/vendor/lucide.js`)

Lightweight icon library for UI elements.

## Using the Auth Layout

### Basic Structure

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>

<layout:auth title="Page Title">
  <h1 class="c-auth__title" id="auth-title">Welcome back</h1>

  <!-- Error messages -->
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; margin-bottom: var(--space-4);">
      ${error}
    </div>
  </c:if>

  <!-- Form -->
  <form class="c-auth__form js-auth-form" method="post" action="..." novalidate>
    <auth:field ... />
    <auth:button text="Submit" />
  </form>

  <!-- Footer links -->
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>

  <!-- Optional scripts -->
  <jsp:attribute name="scripts">
    <script>
      // Page-specific JavaScript
      document.querySelector(".js-auth-form").classList.add("js-validate");
    </script>
  </jsp:attribute>
</layout:auth>
```

## Examples

### Login Page

See: `/WEB-INF/views/auth/login.jsp`

- Email/username field
- Password field
- "Forgot Password?" link
- Form validation

### Forgot Password Page

See: `/WEB-INF/views/auth/forgot-password.jsp`

- Email field with description
- "Remembered your password?" link

### Reset Password Page

See: `/WEB-INF/views/auth/reset-password.jsp`

- New password field
- Confirm password field
- Hidden token field

### Success State

See: `/WEB-INF/views/auth/forgot-password-requested.jsp`

- Success icon with checkmark
- Message display
- Back to login link

## Features

### 1. Dark Mode

- Automatic detection of system preference
- Manual toggle button (top-right)
- Persistent state across page loads
- Smooth transitions

### 2. Form Validation

- Client-side validation before submission
- Accessible error messages
- Visual feedback (red borders, error text)
- ARIA live regions for screen readers

### 3. Accessibility

- Proper ARIA labels and roles
- Keyboard navigation support
- Focus management
- Screen reader friendly

### 4. Responsive Design

- Mobile-first approach
- Adapts to all screen sizes
- Touch-friendly buttons
- Readable on small screens

## Extending the System

### Adding New Auth Pages

1. Create a new JSP file in `/WEB-INF/views/auth/`
2. Use the `layout:auth` tag
3. Import auth component tags
4. Build your form using `auth:field`, `auth:button`, etc.
5. Maintain consistent styling by using CSS variables

### Custom Components

To create new reusable components:

1. Add a new tag file in `/WEB-INF/tags/auth/`
2. Follow the existing naming conventions
3. Use BEM CSS classes (`.c-component__element`)
4. Document the component's attributes

### Styling Customizations

Modify design tokens in `/static/auth.css`:

```css
:root {
  --color-brand: #542cf5; /* Primary color */
  --color-brand-hover: #4723d6; /* Hover state */
  --space-4: 1rem; /* Spacing unit */
  --fs-base: 1rem; /* Base font size */
  /* ... more tokens ... */
}
```

## Browser Support

- Modern browsers (Chrome, Firefox, Safari, Edge)
- IE11 not supported (uses modern CSS features)
- Mobile browsers fully supported

## Dependencies

- Google Fonts: Inter font family
- Lucide Icons: Icon library (included in static assets)
- No external JavaScript frameworks required

## Maintenance Notes

- CSS uses ITCSS architecture for scalability
- JavaScript is vanilla (no framework dependencies)
- All components are self-contained
- Dark mode preference stored in localStorage as `uninest-theme`
