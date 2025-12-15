# Deployment Guide

## Overview

UniNest is packaged as a WAR (Web Application Archive) file and can be deployed to any Jakarta EE compatible servlet container, with Apache Tomcat 11 being the recommended option.

## Deployment Options

### Option 1: Traditional WAR Deployment

Deploy the WAR file to Tomcat's webapps directory.

### Option 2: Using the redeploy.sh Script

Use the included deployment script for development and staging.

### Option 3: Docker Deployment

Containerize the application for cloud deployment.

---

## Production Build

### Build the WAR

```bash
# Clean build with tests
mvn clean package

# Build without tests (faster)
mvn clean package -DskipTests
```

Output: `target/uninest.war`

---

## Environment Configuration

### Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| DB_HOST | Database hostname | mysql.example.com |
| DB_PORT | Database port | 3306 |
| DB_NAME | Database name | uninest |
| DB_USER | Database username | uninest_user |
| DB_PASS | Database password | (secure password) |
| DB_SSL_MODE | SSL mode | REQUIRED |

### Setting Environment Variables

#### Linux/macOS

```bash
export DB_HOST="mysql.example.com"
export DB_PORT="3306"
export DB_NAME="uninest"
export DB_USER="uninest_user"
export DB_PASS="secure_password"
export DB_SSL_MODE="REQUIRED"
```

#### Tomcat setenv.sh

Create `$TOMCAT_HOME/bin/setenv.sh`:

```bash
#!/bin/bash
export DB_HOST="mysql.example.com"
export DB_PORT="3306"
export DB_NAME="uninest"
export DB_USER="uninest_user"
export DB_PASS="secure_password"
export DB_SSL_MODE="REQUIRED"

# JVM options
export CATALINA_OPTS="-Xms512m -Xmx2g"
```

#### Windows (setenv.bat)

Create `%TOMCAT_HOME%\bin\setenv.bat`:

```batch
set DB_HOST=mysql.example.com
set DB_PORT=3306
set DB_NAME=uninest
set DB_USER=uninest_user
set DB_PASS=secure_password
set DB_SSL_MODE=REQUIRED
```

---

## Tomcat Deployment

### Step 1: Prepare Tomcat

1. Download Tomcat 11.x from https://tomcat.apache.org/download-11.cgi
2. Extract to installation directory
3. Configure environment variables

### Step 2: Deploy WAR

```bash
# Stop Tomcat
$TOMCAT_HOME/bin/shutdown.sh

# Remove old deployment
rm -rf $TOMCAT_HOME/webapps/uninest*

# Copy new WAR
cp target/uninest.war $TOMCAT_HOME/webapps/

# Start Tomcat
$TOMCAT_HOME/bin/startup.sh
```

### Step 3: Verify Deployment

```bash
# Check Tomcat logs
tail -f $TOMCAT_HOME/logs/catalina.out

# Access application
curl http://localhost:8080/uninest/
```

---

## Database Migration

### Initial Setup

```bash
mysql -u root -p << EOF
CREATE DATABASE uninest CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER 'uninest_user'@'%' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON uninest.* TO 'uninest_user'@'%';
FLUSH PRIVILEGES;
EOF
```

### Run Migrations

```bash
mysql -u uninest_user -p uninest < src/main/resources/db/migration/db.sql
```

### Production Data Considerations

The migration script includes demo data. For production:

1. Run the schema creation parts only
2. Create admin user manually:
```sql
INSERT INTO users (email, name, password_hash, role_id) VALUES 
('admin@yourdomain.com', 'Administrator', '$2a$10$...', 3);
```

---

## Using redeploy.sh

The project includes a deployment script for convenience:

### Configuration

```bash
# Set Tomcat location
export TOMCAT_BASE="/opt/tomcat"

# Or use alternate webapps directory
export ALT_WEBAPPS_DIR="/var/tomcat/webapps"
```

### Usage

```bash
# Full rebuild and restart
./redeploy.sh

# Fast incremental deploy (no restart)
./redeploy.sh fast

# Watch mode for development
./redeploy.sh watch

# Deploy specific app name
./redeploy.sh myapp fast
```

---

## SSL/HTTPS Configuration

### Tomcat SSL Connector

Add to `$TOMCAT_HOME/conf/server.xml`:

```xml
<Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="/path/to/keystore.jks"
                     certificateKeystorePassword="your_password"
                     type="RSA" />
    </SSLHostConfig>
</Connector>
```

### Redirect HTTP to HTTPS

Add to `$TOMCAT_HOME/conf/web.xml`:

```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Entire Application</web-resource-name>
        <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <user-data-constraint>
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
</security-constraint>
```

---

## Docker Deployment

### Dockerfile

```dockerfile
FROM tomcat:11-jdk17

# Copy WAR file
COPY target/uninest.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: uninest
      MYSQL_USER: uninest_user
      MYSQL_PASSWORD: secure_password
    volumes:
      - mysql_data:/var/lib/mysql
      - ./src/main/resources/db/migration/db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"

  uninest:
    build: .
    environment:
      DB_HOST: mysql
      DB_PORT: "3306"
      DB_NAME: uninest
      DB_USER: uninest_user
      DB_PASS: secure_password
      DB_SSL_MODE: DISABLED
    ports:
      - "8080:8080"
    depends_on:
      - mysql

volumes:
  mysql_data:
```

### Deploy with Docker

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f uninest

# Stop
docker-compose down
```

---

## Cloud Deployment

### DigitalOcean App Platform

1. Create managed MySQL database
2. Configure environment variables in App Platform
3. Deploy from GitHub repository

### AWS Elastic Beanstalk

1. Create RDS MySQL instance
2. Create Elastic Beanstalk environment (Tomcat)
3. Upload WAR file or connect GitHub

### Google Cloud Platform

1. Create Cloud SQL MySQL instance
2. Deploy to App Engine (Java 17 runtime)
3. Configure `app.yaml` for settings

---

## Health Checks

### Basic Health Check

Access the root URL:
```
GET /uninest/
```

Expected: 200 OK with login page

### Database Health Check

Create a health endpoint servlet:

```java
@WebServlet("/health")
public class HealthServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        try (Connection con = DBConnection.getConnection()) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"status\":\"healthy\"}");
        } catch (SQLException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"status\":\"unhealthy\",\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
```

---

## Performance Tuning

### JVM Options

```bash
export CATALINA_OPTS="-Xms512m -Xmx2g -XX:+UseG1GC"
```

### Connection Pooling

For production, consider adding connection pooling (HikariCP):

```xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.1</version>
</dependency>
```

### Tomcat Thread Pool

Configure in `server.xml`:

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           maxThreads="200"
           minSpareThreads="10"
           acceptCount="100" />
```

---

## Logging

### Configure Logging

Create `$TOMCAT_HOME/conf/logging.properties`:

```properties
handlers = java.util.logging.ConsoleHandler, java.util.logging.FileHandler

java.util.logging.FileHandler.level = INFO
java.util.logging.FileHandler.pattern = ${catalina.base}/logs/uninest.%g.log
java.util.logging.FileHandler.limit = 10000000
java.util.logging.FileHandler.count = 5

com.uninest.level = INFO
```

---

## Backup Strategy

### Database Backup

```bash
# Daily backup script
mysqldump -u uninest_user -p uninest > backup_$(date +%Y%m%d).sql

# Restore from backup
mysql -u uninest_user -p uninest < backup_20251215.sql
```

### Upload Files Backup

Backup the file upload directory:
```bash
tar -czf uploads_backup.tar.gz /path/to/uploads/
```

---

## Monitoring

### Application Logs

```bash
tail -f $TOMCAT_HOME/logs/catalina.out
tail -f $TOMCAT_HOME/logs/localhost.log
```

### Database Monitoring

```sql
-- Check connections
SHOW PROCESSLIST;

-- Check slow queries
SHOW GLOBAL STATUS LIKE 'Slow_queries';
```

### System Resources

```bash
# Memory usage
free -h

# CPU usage
top

# Disk usage
df -h
```

---

## Rollback Procedure

### Quick Rollback

```bash
# Keep backup of previous WAR
mv $TOMCAT_HOME/webapps/uninest.war $TOMCAT_HOME/webapps/uninest.war.bak

# Restore previous version
mv $TOMCAT_HOME/webapps/uninest.war.previous $TOMCAT_HOME/webapps/uninest.war

# Restart
$TOMCAT_HOME/bin/shutdown.sh
$TOMCAT_HOME/bin/startup.sh
```

### Database Rollback

```bash
# Restore from backup
mysql -u uninest_user -p uninest < backup_before_deploy.sql
```
