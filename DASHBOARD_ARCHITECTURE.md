# Dashboard Architecture Diagram

## New Nested Dashboard Structure

```
┌─────────────────────────────────────────────────────────────────────┐
│                     Base: dashboard.tag                              │
│  - HTML structure (DOCTYPE, <html>, <head>, <body>)                │
│  - Sidebar with <jsp:invoke fragment="navigation" />               │
│  - Header with breadcrumb and page title                           │
│  - Main content area with <jsp:doBody />                           │
│  - Footer with scripts                                              │
└──────────────────────────┬──────────────────────────────────────────┘
                           │
                           │ Extends/Wraps
                           │
        ┌──────────────────┴──────────────────┐
        │                                      │
        ▼                                      ▼
┌───────────────────┐              ┌───────────────────┐
│ admin-dashboard   │              │ student-dashboard │
│ .tag              │              │ .tag              │
│                   │              │                   │
│ - Dashboard       │              │ - Dashboard       │
│ - Students        │              │ - My Subjects     │
│ - Organizations   │              │ - Kuppi Sessions  │
│ - Settings        │              │ - Resources       │
│                   │              │ - Progress        │
│ Passes through    │              │ - Community       │
│ <jsp:doBody />    │              │ - Profile         │
└─────────┬─────────┘              └─────────┬─────────┘
          │                                  │
          │ Used by                          │ Used by
          │                                  │
    ┌─────┴──────┐                    ┌──────┴──────┐
    ▼            ▼                    ▼             ▼
┌─────────┐  ┌─────────┐         ┌─────────┐  ┌─────────┐
│ admin/  │  │ admin/  │         │student/ │  │student/ │
│dashboard│  │organiz- │         │dashboard│  │join-org │
│  .jsp   │  │ations   │         │  .jsp   │  │  .jsp   │
│         │  │  .jsp   │         │         │  │         │
│ Content │  │ Content │         │ Content │  │ Content │
│  only   │  │  only   │         │  only   │  │  only   │
└─────────┘  └─────────┘         └─────────┘  └─────────┘

        ┌──────────────────┴──────────────────┐
        │                                      │
        ▼                                      ▼
┌───────────────────┐              ┌───────────────────┐
│moderator-dashboard│              │coordinator-       │
│ .tag              │              │dashboard.tag      │
│                   │              │                   │
│ - Dashboard       │              │ - Dashboard       │
│ - Content Review  │              │ - My Subjects     │
│ - Reported        │              │ - Topics          │
│ - Users           │              │ - Upload          │
│ - Logs            │              │ - Analytics       │
│ - Settings        │              │ - Settings        │
│                   │              │                   │
│ Passes through    │              │ Passes through    │
│ <jsp:doBody />    │              │ <jsp:doBody />    │
└─────────┬─────────┘              └─────────┬─────────┘
          │                                  │
          │ Used by                          │ Used by
          │                                  │
          ▼                                  ▼
    ┌─────────┐                        ┌─────────┐
    │moderator│                        │coord-   │
    │/dash-   │                        │inator/ │
    │board.jsp│                        │dash-    │
    │         │                        │board.jsp│
    │ Content │                        │         │
    │  only   │                        │ Content │
    └─────────┘                        │  only   │
                                       └─────────┘
```

## Data Flow Example

When admin/dashboard.jsp is rendered:

```
1. Browser requests: /admin/dashboard
   
2. Servlet forwards to: admin/dashboard.jsp
   
3. JSP processing:
   admin/dashboard.jsp
   └─> Uses <layout:admin-dashboard>
       └─> admin-dashboard.tag
           ├─> Wraps <layout:dashboard>
           │   └─> dashboard.tag
           │       ├─> Renders HTML structure
           │       ├─> Invokes <navigation> fragment
           │       │   (Navigation items from admin-dashboard.tag)
           │       └─> Invokes <jsp:doBody />
           │           (Content from admin/dashboard.jsp)
           └─> Navigation defined once:
               - Dashboard (active)
               - Students
               - Organizations
               - Settings

4. HTML Output:
   <!DOCTYPE html>
   <html>
     <head>...</head>
     <body>
       <aside class="c-sidebar">
         <nav>
           <!-- Navigation from admin-dashboard.tag -->
           <a class="active">Dashboard</a>
           <a>Students</a>
           <a>Organizations</a>
           <a>Settings</a>
         </nav>
       </aside>
       <main class="c-page">
         <!-- Content from admin/dashboard.jsp -->
         <section>Welcome...</section>
         <section>Quick Actions...</section>
       </main>
     </body>
   </html>
```

## Key Points

1. **Single Responsibility**: Each layer has a clear purpose
   - Base layout: HTML structure and common elements
   - Role layouts: Role-specific navigation
   - Pages: Page-specific content only

2. **DRY (Don't Repeat Yourself)**: 
   - Navigation items defined once per role
   - No duplicate code across pages

3. **Correct JSP Tag Usage**:
   - `<jsp:doBody />` in main content area (✓)
   - `<jsp:invoke fragment="navigation" />` in sidebar (✓)

4. **Maintainability**:
   - Change navigation once, affects all pages
   - Easy to add new pages
   - Clear hierarchy and structure
