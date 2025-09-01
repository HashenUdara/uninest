package com.uninest.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/** Simple wrapper to load properties from application.properties */
public class Env {
    private static Properties props;

    private static synchronized void initProps() {
        if (props != null) return;
        props = new Properties();
        try (InputStream in = Env.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            // swallow; treat as missing
        }
    }

    public static String get(String key) {
        // 1. Real environment variable
        String val = System.getenv(key);
        if (val != null) return val;
        // 2. application.properties
        initProps();
        return props.getProperty(key);
    }
}
