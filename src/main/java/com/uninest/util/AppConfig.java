package com.uninest.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    private static final Properties properties = new Properties();
    
    static {
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new RuntimeException("Unable to find application.properties");
            }
            properties.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Error loading application.properties", e);
        }
    }
    
    public static String getProperty(String key) {
        String value = properties.getProperty(key);
        if (value != null) {
            // Replace ${user.home} with actual user home directory
            value = value.replace("${user.home}", System.getProperty("user.home"));
        }
        return value;
    }
    
    public static String getProperty(String key, String defaultValue) {
        String value = getProperty(key);
        return value != null ? value : defaultValue;
    }
    
    public static int getIntProperty(String key, int defaultValue) {
        String value = getProperty(key);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    public static long getLongProperty(String key, long defaultValue) {
        String value = getProperty(key);
        if (value != null) {
            try {
                return Long.parseLong(value);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    // File Upload Configuration
    public static String getUploadBasePath() {
        return getProperty("UPLOAD_BASE_PATH", System.getProperty("user.home") + "/uninest-uploads");
    }
    
    public static long getUploadMaxFileSize() {
        return getLongProperty("UPLOAD_MAX_FILE_SIZE", 52428800L); // 50MB default
    }
    
    public static long getUploadMaxRequestSize() {
        return getLongProperty("UPLOAD_MAX_REQUEST_SIZE", 62914560L); // 60MB default
    }
}
