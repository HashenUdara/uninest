# Development Setup Guide

## Prerequisites

Before setting up the development environment, ensure you have the following installed:

| Software | Version | Purpose |
|----------|---------|---------|
| Java JDK | 17+ | Runtime and compilation |
| Apache Maven | 3.6+ | Build automation |
| MySQL | 8.0+ | Database |
| Apache Tomcat | 11.x | Application server |
| Git | 2.x+ | Version control |
| IDE | Any | Development (IntelliJ IDEA, Eclipse, VS Code) |

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/HashenUdara/uninest.git
cd uninest
```

---

## Step 2: Database Setup

### 2.1 Create Database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE uninest CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER 'uninest_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON uninest.* TO 'uninest_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 2.2 Run Migration Scripts

```bash
mysql -u uninest_user -p uninest < src/main/resources/db/migration/db.sql
```

This script will:
- Create all tables
- Insert default roles (student, moderator, admin)
- Insert Sri Lankan universities
- Insert default admin user (a1@abc.com / password123)
- Insert demo communities
- Insert demo moderators (m1-m20@abc.com)
- Insert demo students (s1-s100@abc.com)
- Insert demo subjects and topics

---

## Step 3: Configure Environment Variables

UniNest requires environment variables for database connection.

### Option A: Export in Terminal

```bash
export DB_HOST="localhost"
export DB_PORT="3306"
export DB_NAME="uninest"
export DB_USER="uninest_user"
export DB_PASS="your_password"
export DB_SSL_MODE="DISABLED"  # Use "REQUIRED" for production
```

### Option B: Create .env File (Not committed)

Create `application.properties` in the resources folder (this file is gitignored):

```properties
DB_HOST=localhost
DB_PORT=3306
DB_NAME=uninest
DB_USER=uninest_user
DB_PASS=your_password
DB_SSL_MODE=DISABLED
```

### Option C: IDE Configuration

Configure environment variables in your IDE's run configuration.

---

## Step 4: Tomcat Setup

### 4.1 Download and Install Tomcat

Download Tomcat 11.x from: https://tomcat.apache.org/download-11.cgi

Extract to a directory, e.g., `/opt/tomcat` or `C:\tomcat`

### 4.2 Configure Tomcat

For macOS (Homebrew):
```bash
brew install tomcat
```

The default installation location is:
```
/opt/homebrew/Cellar/tomcat/11.0.10/libexec
```

---

## Step 5: Build the Project

### Using Maven

```bash
# Clean build (recommended for first time)
mvn clean package -DskipTests

# Quick rebuild
mvn package -DskipTests

# Build with tests
mvn clean package
```

The WAR file will be generated at: `target/uninest.war`

---

## Step 6: Deploy to Tomcat

### Option A: Manual Deployment

```bash
# Copy WAR to Tomcat webapps
cp target/uninest.war $TOMCAT_HOME/webapps/

# Start Tomcat
$TOMCAT_HOME/bin/startup.sh
```

### Option B: Using redeploy.sh Script

The project includes a convenient deployment script:

```bash
# Full build and restart Tomcat
./redeploy.sh

# Fast incremental deploy (no restart)
./redeploy.sh fast

# Watch mode (auto-deploy on changes)
./redeploy.sh watch
```

Configure the script for your environment:
```bash
export TOMCAT_BASE="/path/to/tomcat"
```

---

## Step 7: Access the Application

Open your browser and navigate to:

```
http://localhost:8080/uninest/
```

### Default Credentials (Development Only)

> ⚠️ **WARNING**: These credentials are for **development and testing only**. 
> Never use these in production. Always create new users with strong passwords for production environments.

| Role | Email | Password |
|------|-------|----------|
| Admin | a1@abc.com | password123 |
| Moderator | m1@abc.com | password123 |
| Student | s1@abc.com | password123 |

For production, create new admin users with secure passwords and remove or disable the demo accounts.

---

## IDE Setup

### IntelliJ IDEA

1. **Import Project**
   - File → Open → Select the project directory
   - Import as Maven project

2. **Configure JDK**
   - File → Project Structure → Project → SDK: 17

3. **Configure Tomcat**
   - Run → Edit Configurations
   - Add → Tomcat Server → Local
   - Configure Tomcat Home and artifact deployment

4. **Environment Variables**
   - Run → Edit Configurations
   - Add environment variables in the "Environment variables" field

### Eclipse

1. **Import Project**
   - File → Import → Maven → Existing Maven Projects

2. **Configure Server**
   - Window → Preferences → Server → Runtime Environments
   - Add Apache Tomcat v11.0

3. **Run on Server**
   - Right-click project → Run As → Run on Server

### VS Code

1. **Install Extensions**
   - Extension Pack for Java
   - Maven for Java
   - Tomcat for Java

2. **Configure Launch**
   - Create `.vscode/launch.json` for debugging configuration

---

## Project Structure Overview

```
uninest/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/uninest/
│   │   │       ├── controller/    # Servlets
│   │   │       ├── model/         # Domain models
│   │   │       │   └── dao/       # Data access
│   │   │       ├── repository/    # Repository layer
│   │   │       ├── security/      # Auth filter
│   │   │       └── util/          # Utilities
│   │   ├── resources/
│   │   │   └── db/migration/      # SQL scripts
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/         # JSP views
│   │       │   ├── tags/          # Tag files
│   │       │   └── web.xml        # Web config
│   │       └── static/            # CSS, JS, images
│   └── test/                      # Test classes
├── documentation/                 # This documentation
├── docs/                         # Feature docs
├── ui-templates/                 # HTML templates
├── pom.xml                       # Maven config
└── redeploy.sh                   # Deploy script
```

---

## Common Development Tasks

### Adding a New Servlet

1. Create class in appropriate package under `controller/`
2. Annotate with `@WebServlet(urlPatterns = "/your-path")`
3. Implement `doGet()` and/or `doPost()` methods
4. Create corresponding JSP in `WEB-INF/views/`

### Adding a New DAO Method

1. Open the appropriate DAO in `model/dao/`
2. Add method with SQL query
3. Use PreparedStatements for all queries
4. Return Optional for single results, List for multiple

### Adding a New JSP View

1. Create JSP in appropriate folder under `WEB-INF/views/`
2. Use JSTL for logic (`<c:if>`, `<c:forEach>`)
3. Use tag files for layouts
4. Set request attributes in servlet before forwarding

---

## Debugging

### Enable Debug Logging

Add to `catalina.properties`:
```properties
java.util.logging.ConsoleHandler.level=FINE
```

### Database Query Debugging

Add to JDBC URL:
```
?logger=com.mysql.cj.log.StandardLogger&profileSQL=true
```

### Hot Reload

Use `./redeploy.sh fast` or `./redeploy.sh watch` for faster development cycles.

---

## Testing

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=UserDAOTest

# Skip tests during build
mvn package -DskipTests
```

---

## Troubleshooting

### "MySQL Driver not found"

Ensure MySQL Connector/J is in the classpath. Check `pom.xml` for:
```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>9.0.0</version>
</dependency>
```

### "Connection refused" to database

1. Verify MySQL is running: `mysql.server status`
2. Check environment variables are set
3. Verify database exists and user has permissions

### "404 Not Found" for servlets

1. Check WAR is deployed correctly
2. Verify servlet URL mapping
3. Check `web.xml` for filter mappings

### "500 Internal Server Error"

1. Check Tomcat logs: `$TOMCAT_HOME/logs/catalina.out`
2. Look for Java exceptions
3. Verify JSP paths are correct

### Build Failures

```bash
# Clear Maven cache
mvn dependency:purge-local-repository

# Rebuild
mvn clean install -U
```
