package com.uninest.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Simple utility to send emails using Gmail SMTP. Requires the following environment variables:
 * GMAIL_USERNAME - full gmail address
 * GMAIL_APP_PASSWORD - 16 char app password (not regular account password)
 */
public class MailUtil {

    private static Session buildSession() {
        final String username = Env.get("GMAIL_USERNAME");
        final String password = Env.get("GMAIL_APP_PASSWORD");
        if (username == null || password == null) {
            throw new IllegalStateException("Missing GMAIL_USERNAME or GMAIL_APP_PASSWORD in configuration");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }

    public static void send(String to, String subject, String htmlBody) throws MessagingException {
        Session session = buildSession();
        Message message = new MimeMessage(session);
        String from = Env.get("GMAIL_USERNAME");
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=utf-8");
        Transport.send(message);
    }   
}
