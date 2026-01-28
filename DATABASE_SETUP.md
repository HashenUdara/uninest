# Database Setup Guide for UniNest

## Quick Setup (Recommended)

Follow these steps to set up the local MySQL database:

### 1. Install MySQL
If you don't have MySQL installed:
- Download MySQL Community Server from: https://dev.mysql.com/downloads/mysql/
- Or use XAMPP/WAMP which includes MySQL

### 2. Create the Database
Open MySQL command line or MySQL Workbench and run:
```sql
CREATE DATABASE uninest CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

### 3. Import the Schema
Import the database schema file:
```bash
mysql -u root -p uninest < "c:/Users/pushpika sampath/Downloads/uninest-main (1)/uninest-main-gpa/uninest/src/main/resources/db/migration/db.sql"
```

Or using MySQL Workbench:
1. Open MySQL Workbench
2. Connect to your local server
3. Select the `uninest` database
4. Go to File > Run SQL Script
5. Select: `uninest/src/main/resources/db/migration/db.sql`
6. Click Run

### 4. Configure application.properties
The file is already created at:
`uninest/src/main/resources/application.properties`

Update it with your MySQL root password:
```properties
DB_HOST=localhost
DB_PORT=3306
DB_NAME=uninest
DB_SSL_MODE=DISABLED
DB_USER=root
DB_PASS=your_mysql_root_password
```

**If your MySQL root user has no password**, leave `DB_PASS` empty:
```properties
DB_PASS=
```

### 5. Restart Tomcat
Restart your Tomcat server to apply the new configuration.

## Demo Users

The database comes with pre-populated demo users. All passwords are: `password123`

- **Admin**: a1@abc.com
- **Moderators**: m1@abc.com through m20@abc.com
- **Students**: s1@abc.com through s100@abc.com

## Troubleshooting

### Error: Access denied for user 'root'@'localhost'
- Your MySQL root password is incorrect
- Update `DB_PASS` in application.properties with the correct password

### Error: Unknown database 'uninest'
- You haven't created the database yet
- Run: `CREATE DATABASE uninest;`

### Error: Table doesn't exist
- You haven't imported the schema
- Import the db.sql file as shown in step 3
