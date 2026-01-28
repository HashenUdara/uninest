package com.uninest.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;


/**
 * Database connection helper.
 * Priority of configuration:
 * 1. Explicit DB_URL env var (full JDBC URL)
 * 2. Build from individual vars: DB_HOST, DB_PORT, DB_NAME, DB_SSL_MODE
 *    with defaults targeting the provided DigitalOcean Managed MySQL values.
 * Credentials via DB_USER / DB_PASS.
 */
public class DBConnection {
    // Hardcoded DigitalOcean Managed MySQL credentials (requested). WARNING: Don't commit real secrets in production.
    private static final String HOST = Env.get("DB_HOST");
    private static final String PORT = Env.get("DB_PORT");
    private static final String DB = Env.get("DB_NAME");
    private static final String SSL_MODE = Env.get("DB_SSL_MODE");
    private static final String USER = Env.get("DB_USER");
    private static final String PASS = Env.get("DB_PASS");
    private static final String URL = String.format(
            "jdbc:mysql://%s:%s/%s?sslMode=%s&serverTimezone=UTC", HOST, PORT, DB, SSL_MODE);

    static {
        try {
            // Driver auto registers via SPI since Connector/J 8+, but explicit load is fine
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        Properties props = new Properties();
        props.setProperty("user", USER);
        props.setProperty("password", PASS);
        // Optional fallback properties
        props.setProperty("characterEncoding", "UTF-8");
        return DriverManager.getConnection(URL, props);
    }

    // Removed getenv usage since values are hardcoded.
}
