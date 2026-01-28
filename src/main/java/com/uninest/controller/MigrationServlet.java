package com.uninest.controller;

import com.uninest.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;

@WebServlet("/debug/migrate")
public class MigrationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {

            out.println("Starting migration...");

            // 1. Add columns (Ignore error if exists)
            run(stmt, out, "ALTER TABLE users ADD COLUMN name VARCHAR(200) NULL AFTER email");
            run(stmt, out, "ALTER TABLE users ADD COLUMN community_id INT NULL AFTER role_id");
            run(stmt, out, "ALTER TABLE users ADD COLUMN academic_year TINYINT NULL AFTER community_id");
            run(stmt, out, "ALTER TABLE users ADD COLUMN university_id INT NULL AFTER academic_year");

            // 2. Add Constraints
            run(stmt, out, "ALTER TABLE users ADD CONSTRAINT fk_users_community FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE SET NULL");
            run(stmt, out, "ALTER TABLE users ADD CONSTRAINT fk_users_university FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE SET NULL");

            out.println("Migration finished.");

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

    private void run(Statement stmt, PrintWriter out, String sql) {
        try {
            stmt.executeUpdate(sql);
            out.println("SUCCESS: " + sql);
        } catch (Exception e) {
            out.println("SKIPPED (" + e.getMessage() + "): " + sql);
        }
    }
}
