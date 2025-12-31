package com.uninest.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * Loads secret configuration (like Gmail credentials) from an external properties file.
 * Lookup order:
 * 1. System property: secrets.path
 * 2. Environment variable: SECRETS_PATH
 * 3. Default relative path: ./config/secrets.properties
 * Falls back to environment variables GMAIL_USERNAME / GMAIL_APP_PASSWORD if properties not found.
 */
public class ConfigLoader {
    private static final Properties secrets = new Properties();
    private static boolean loaded = false;

    private static synchronized void loadIfNeeded() {
        if (loaded) return;
        String explicit = System.getProperty("secrets.path");
        if (explicit == null || explicit.isBlank()) {
            explicit = System.getenv("SECRETS_PATH");
        }
        if (explicit == null || explicit.isBlank()) {
            explicit = "config/secrets.properties"; // default
        }
        Path p = Paths.get(explicit);
        if (Files.exists(p)) {
            try (FileInputStream fis = new FileInputStream(p.toFile())) {
                secrets.load(fis);
            } catch (IOException e) {
                // log minimal; continue with env fallback
            }
        }
        loaded = true;
    }

    public static String get(String key) {
        loadIfNeeded();
        String val = secrets.getProperty(key);
        if (val != null) return val;
        // env fallback mapping
        if ("gmail.username".equals(key)) {
            return System.getenv("GMAIL_USERNAME");
        }
        if ("gmail.password".equals(key)) {
            return System.getenv("GMAIL_APP_PASSWORD");
        }
        return null;
    }
}
