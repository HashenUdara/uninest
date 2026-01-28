package com.uninest.config;

import com.uninest.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class AutoMigrationListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AutoMigration] Checking database schema...");
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {

            // 1. Add columns (Ignore error if exists - "Duplicate column name" is fine)
            run(stmt, "ALTER TABLE users ADD COLUMN name VARCHAR(200) NULL AFTER email");
            run(stmt, "ALTER TABLE users ADD COLUMN community_id INT NULL AFTER role_id");
            run(stmt, "ALTER TABLE users ADD COLUMN academic_year TINYINT NULL AFTER community_id");
            run(stmt, "ALTER TABLE users ADD COLUMN university_id INT NULL AFTER academic_year");

            // 2. Add Constraints (Might fail if already exists, that's expected)
            run(stmt, "ALTER TABLE users ADD CONSTRAINT fk_users_community FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE SET NULL");
            run(stmt, "ALTER TABLE users ADD CONSTRAINT fk_users_university FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE SET NULL");

            System.out.println("[AutoMigration] Schema check completed.");

        } catch (Exception e) {
            System.err.println("[AutoMigration] Warning: Migration check failed (DB might be down or unreachable): " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void run(Statement stmt, String sql) {
        try {
            stmt.executeUpdate(sql);
            System.out.println("[AutoMigration] Executed: " + sql);
        } catch (Exception e) {
            // Expected if column/constraint already exists
            System.out.println("[AutoMigration] Skipped (or failed): " + sql + " -> " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
