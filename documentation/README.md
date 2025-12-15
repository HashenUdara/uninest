# UniNest - Complete Documentation

## 📚 Documentation Index

Welcome to the UniNest documentation! This comprehensive guide will help your team understand the entire codebase, architecture, and development practices.

## 🎯 What is UniNest?

UniNest is a **University Community Management System** built using Java Jakarta EE (Servlets, JSP, JSTL) with a MySQL database. It provides a platform for university students and moderators to collaborate within academic communities, share resources, track learning progress, and manage subjects and topics.

## 📖 Documentation Structure

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | System architecture, design patterns, and technology stack |
| [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) | Complete database schema with table relationships |
| [MODELS.md](./MODELS.md) | Java model classes and their properties |
| [DATA_ACCESS.md](./DATA_ACCESS.md) | DAO (Data Access Object) layer documentation |
| [CONTROLLERS.md](./CONTROLLERS.md) | Servlet controllers and API endpoints |
| [VIEWS.md](./VIEWS.md) | JSP views and UI templates |
| [USER_ROLES.md](./USER_ROLES.md) | User roles, permissions, and authorization |
| [SECURITY.md](./SECURITY.md) | Authentication, authorization, and security features |
| [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md) | Development environment setup guide |
| [DEPLOYMENT.md](./DEPLOYMENT.md) | Deployment instructions and configuration |
| [FEATURES.md](./FEATURES.md) | Feature list and functionality overview |

## 🏗️ Quick Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT BROWSER                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      TOMCAT 11 SERVER                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                     WEB LAYER                              │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐    │  │
│  │  │   Filters   │  │  Servlets   │  │   JSP Views     │    │  │
│  │  │ (AuthFilter)│  │(Controllers)│  │   (Templates)   │    │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘    │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                   BUSINESS LAYER                           │  │
│  │  ┌─────────────┐  ┌─────────────────────────────────────┐  │  │
│  │  │   Models    │  │        DAO Layer                    │  │  │
│  │  │(User, Role, │  │  (UserDAO, CommunityDAO, etc.)      │  │  │
│  │  │ Community)  │  │                                     │  │  │
│  │  └─────────────┘  └─────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     MYSQL DATABASE                               │
│    (users, roles, communities, subjects, topics, resources)     │
└─────────────────────────────────────────────────────────────────┘
```

## 🔑 Key Components

### User Roles
- **Admin**: Full system access, user management, community approval
- **Moderator**: Community management, subject/topic management, join request approval
- **Student**: Access to community resources, progress tracking, resource upload
- **Subject Coordinator**: Special student privilege for resource approval (not a role, but a flag)

### Core Entities
- **Communities**: Academic groups (e.g., "Computer Science Society")
- **Subjects**: Courses within communities (e.g., "Data Structures")
- **Topics**: Learning units within subjects (e.g., "Arrays and Linked Lists")
- **Resources**: Educational materials uploaded by students

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| Language | Java | 17+ |
| Web Framework | Jakarta EE (Servlets) | 6.0 |
| View Technology | JSP + JSTL | 3.0 |
| Database | MySQL | 8.0+ |
| Build Tool | Maven | 3.x |
| Application Server | Tomcat | 11.x |
| Password Hashing | BCrypt (jBCrypt) | 0.4 |
| Email | Jakarta Mail | 2.0.1 |

## 📁 Project Structure

```
uninest/
├── documentation/          # This documentation folder
├── docs/                   # Feature-specific documentation
├── src/
│   └── main/
│       ├── java/com/uninest/
│       │   ├── controller/ # Servlet controllers
│       │   ├── model/      # Domain models
│       │   │   └── dao/    # Data Access Objects
│       │   ├── repository/ # Repository layer
│       │   ├── security/   # Auth filters
│       │   └── util/       # Utility classes
│       ├── resources/
│       │   └── db/migration/ # SQL scripts
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── views/  # JSP views
│           │   ├── tags/   # JSP tag files
│           │   └── web.xml # Web configuration
│           └── static/     # CSS, JS, images
├── ui-templates/           # HTML templates
├── pom.xml                 # Maven configuration
└── redeploy.sh            # Deployment script
```

## 🚀 Quick Start

1. **Set up the database** (see [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md))
2. **Configure environment variables** for database connection
3. **Build the project**: `mvn clean package`
4. **Deploy to Tomcat**: Use `redeploy.sh` or copy WAR file
5. **Access the application**: `http://localhost:8080/uninest/`

## 🔐 Default Credentials (Development Only)

> ⚠️ **WARNING**: These are for **development and testing only**. Do not use in production.

| Role | Email | Password |
|------|-------|----------|
| Admin | a1@abc.com | password123 |
| Moderator | m1@abc.com | password123 |
| Student | s1@abc.com | password123 |

## 📞 Need Help?

Refer to the individual documentation files for detailed information on each component. For feature-specific documentation, check the `docs/` folder in the root directory.

---

**Last Updated**: December 2025  
**Version**: 1.0-SNAPSHOT
