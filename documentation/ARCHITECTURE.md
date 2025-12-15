# Architecture Documentation

## Overview

UniNest follows a **Model-View-Controller (MVC)** architecture pattern implemented using Jakarta EE technologies. The application is designed as a monolithic web application deployed on Apache Tomcat.

## Architectural Layers

### 1. Presentation Layer (View)

The presentation layer consists of:

- **JSP Pages**: Server-side rendered HTML templates
- **Tag Files**: Reusable UI components and layouts
- **Static Assets**: CSS, JavaScript, and images

```
src/main/webapp/
├── WEB-INF/
│   ├── views/           # JSP view templates
│   │   ├── admin/       # Admin dashboard views
│   │   ├── auth/        # Authentication views
│   │   ├── moderator/   # Moderator dashboard views
│   │   ├── student/     # Student dashboard views
│   │   └── subject-coordinator/  # Coordinator views
│   └── tags/            # Reusable JSP tags
│       ├── dashboard/   # Dashboard components
│       └── layouts/     # Page layouts
└── static/              # Static resources
    ├── app.css          # Main application styles
    ├── app.js           # Main application scripts
    ├── dashboard.css    # Dashboard-specific styles
    ├── dashboard.js     # Dashboard-specific scripts
    └── vendor/          # Third-party libraries
```

### 2. Controller Layer

Servlets handle HTTP requests and coordinate between the view and model layers.

```
com.uninest.controller/
├── admin/              # Admin management servlets
├── api/                # REST-like API endpoints
├── auth/               # Authentication servlets
├── moderator/          # Moderator functionality servlets
├── student/            # Student functionality servlets
├── students/           # Student management servlets
└── subjectcoordinator/ # Subject coordinator servlets
```

### 3. Business/Model Layer

Domain models represent the core business entities:

```
com.uninest.model/
├── Community.java
├── JoinRequest.java
├── Resource.java
├── ResourceCategory.java
├── Role.java
├── Student.java
├── Subject.java
├── SubjectCoordinator.java
├── Topic.java
├── TopicProgress.java
├── University.java
└── User.java
```

### 4. Data Access Layer (DAO)

DAOs encapsulate all database operations:

```
com.uninest.model.dao/
├── CommunityDAO.java
├── JoinRequestDAO.java
├── ResourceCategoryDAO.java
├── ResourceDAO.java
├── StudentDAO.java
├── SubjectCoordinatorDAO.java
├── SubjectDAO.java
├── TopicDAO.java
├── TopicProgressDAO.java
├── UniversityDAO.java
└── UserDAO.java
```

## Request Flow

```
┌──────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Browser    │────►│ AuthFilter  │────►│  Servlet    │────►│    DAO      │
│  (HTTP Req)  │     │ (Security)  │     │(Controller) │     │(Data Access)│
└──────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                │                    │
                                                │                    ▼
                                                │            ┌─────────────┐
                                                │            │   MySQL     │
                                                │            │  Database   │
                                                │            └─────────────┘
                                                │                    │
                                                ▼                    │
┌──────────────┐     ┌─────────────┐     ┌─────────────┐            │
│   Browser    │◄────│  JSP View   │◄────│   Model     │◄───────────┘
│ (HTML Resp)  │     │ (Template)  │     │  (Data)     │
└──────────────┘     └─────────────┘     └─────────────┘
```

### Detailed Request Flow:

1. **Browser** sends HTTP request to Tomcat
2. **AuthFilter** intercepts request for protected URLs
3. **AuthFilter** validates session and role permissions
4. **Servlet** receives request, processes business logic
5. **DAO** performs database operations
6. **Servlet** sets model data as request attributes
7. **JSP View** renders HTML using model data
8. **Response** sent back to browser

## Design Patterns

### 1. MVC (Model-View-Controller)
- **Model**: Java POJOs in `com.uninest.model`
- **View**: JSP pages in `WEB-INF/views`
- **Controller**: Servlets in `com.uninest.controller`

### 2. DAO (Data Access Object)
- Encapsulates database access
- Each entity has a corresponding DAO
- Uses JDBC with PreparedStatements for SQL injection prevention

### 3. Front Controller
- AuthFilter acts as a front controller for security
- Routes all protected requests through authentication check

### 4. Template Method
- JSP tag files provide reusable layouts
- Dashboard layouts extend base templates

## Package Structure

```
com.uninest/
├── controller/          # HTTP request handlers (Servlets)
│   ├── admin/           # Admin-related endpoints
│   ├── api/             # API endpoints
│   ├── auth/            # Authentication (login, register, etc.)
│   ├── moderator/       # Moderator-related endpoints
│   ├── student/         # Student-related endpoints
│   ├── students/        # Student CRUD operations
│   └── subjectcoordinator/  # Coordinator endpoints
├── model/               # Domain entities
│   └── dao/             # Data Access Objects
├── repository/          # Additional repository classes
├── security/            # Security components
│   └── AuthFilter.java  # Authentication filter
└── util/                # Utility classes
    ├── ConfigLoader.java  # Configuration utilities
    ├── DBConnection.java  # Database connection manager
    ├── Env.java           # Environment variable handler
    └── MailUtil.java      # Email sending utility
```

## Configuration

### web.xml Configuration

The `web.xml` file configures:
- Welcome files
- Filter mappings for AuthFilter
- URL pattern protection

### Database Configuration

Database connection is configured via environment variables:
- `DB_HOST`: Database host
- `DB_PORT`: Database port
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASS`: Database password
- `DB_SSL_MODE`: SSL mode for connection

## Security Architecture

### Authentication Flow

```
┌─────────────────┐
│  Login Request  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  LoginServlet   │
│  (POST /login)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    UserDAO      │
│ (findByEmail)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  BCrypt Verify  │
│   Password      │
└────────┬────────┘
         │
    ┌────┴────┐
    │ Valid?  │
    └────┬────┘
         │
    ┌────┴────┐
   Yes       No
    │         │
    ▼         ▼
┌─────────┐  ┌─────────────┐
│ Create  │  │ Return Error│
│ Session │  └─────────────┘
└────┬────┘
     │
     ▼
┌─────────────────┐
│ Redirect based  │
│   on role       │
└─────────────────┘
```

### Authorization

AuthFilter enforces role-based access:
- `/admin/*` → Admin only
- `/moderator/*` → Admin, Moderator
- `/student/*` → Admin, Moderator, Student
- `/subject-coordinator/*` → Subject Coordinators (via table lookup)

## Error Handling

- Servlets catch exceptions and forward to error JSP
- Database errors are wrapped in RuntimeException
- User-friendly error messages displayed on frontend

## Scalability Considerations

### Current Limitations
- Single database connection per request (no pooling)
- Session-based authentication (not stateless)
- Server-side rendering (no REST API for mobile)

### Potential Improvements
- Add connection pooling (HikariCP)
- Implement caching layer
- Add REST API for mobile/SPA clients
- Consider microservices for large-scale deployment
