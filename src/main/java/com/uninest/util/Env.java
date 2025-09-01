package com.uninest.util;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/** Simple wrapper around dotenv with lazy singleton loading. */
public class Env {
    private static Dotenv dotenv;
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

    private static Dotenv getDotenv() {
        if (dotenv == null) {
            dotenv = Dotenv.configure()
                    .ignoreIfMissing()
                    .load();
        }
        return dotenv;
    }

    public static String get(String key) {
        // 1. Real environment variable
        String val = System.getenv(key);
        if (val != null) return val;
        // 2. application.properties
        initProps();
        val = props.getProperty(key);
        if (val != null) return val;
        // 3. .env (dotenv)
        return getDotenv().get(key);
    }
}
