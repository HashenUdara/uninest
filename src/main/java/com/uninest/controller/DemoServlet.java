package com.uninest.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Centralized servlet for handling simple GET requests to static JSP pages.
 * No business logic - just routing to views.
 */
@WebServlet(urlPatterns = {
    "/student/community/post-details",
    "/student/community/subject",
    "/student/community/my-posts",
    "/student/community/edit-post",

    "/student/progress-analysis",
    "/student/progress-analysis/gpa-calculator",

    "/student/kuppi-sessions",
    "/student/kuppi-sessions/session-details",
    "/student/kuppi-sessions/requested-list",
    "/student/kuppi-sessions/requested-session-details",
    "/student/kuppi-sessions/kuppi-apply-conductor",
    "/student/kuppi-sessions/request",
    "/student/kuppi-sessions/my-sessions",
    "/student/profile-settings",
    "/student/quizzes",

    "/admin/profile-settings",
    "/moderator/profile-settings"


    
})
public class DemoServlet extends HttpServlet {
    
    private static final Map<String, String> ROUTE_MAP = new HashMap<>();
    
    static {
        // Community routes
        ROUTE_MAP.put("/student/community/post-details", "/WEB-INF/views/student/community/post-details.jsp");
        ROUTE_MAP.put("/student/community/subject", "/WEB-INF/views/student/community/subject.jsp");
        ROUTE_MAP.put("/student/community/my-posts", "/WEB-INF/views/student/community/my-posts.jsp");
        ROUTE_MAP.put("/student/community/edit-post", "/WEB-INF/views/student/community/edit-post.jsp");
        ROUTE_MAP.put("/student/progress-analysis", "/WEB-INF/views/student/progress-analysis/index.jsp");
        ROUTE_MAP.put("/student/progress-analysis/gpa-calculator", "/WEB-INF/views/student/progress-analysis/gpa-calculator.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions", "/WEB-INF/views/student/kuppi-sessions/index.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/session-details", "/WEB-INF/views/student/kuppi-sessions/session-details.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/requested-list", "/WEB-INF/views/student/kuppi-sessions/requested-list.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/requested-session-details", "/WEB-INF/views/student/kuppi-sessions/requested-session-details.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/kuppi-apply-conductor", "/WEB-INF/views/student/kuppi-sessions/kuppi-apply-conductor.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/request", "/WEB-INF/views/student/kuppi-sessions/kuppi-request.jsp");
        ROUTE_MAP.put("/student/kuppi-sessions/my-sessions", "/WEB-INF/views/student/kuppi-sessions/my-sessions.jsp");
        ROUTE_MAP.put("/student/profile-settings", "/WEB-INF/views/student/profile-settings.jsp");
        ROUTE_MAP.put("/admin/profile-settings", "/WEB-INF/views/admin/profile-settings.jsp");
        ROUTE_MAP.put("/moderator/profile-settings", "/WEB-INF/views/moderator/profile-settings.jsp");
        ROUTE_MAP.put("/student/quizzes", "/WEB-INF/views/student/quizzes.jsp");
    }
    

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String jspPath = ROUTE_MAP.get(path);
        
        if (jspPath != null) {
            req.getRequestDispatcher(jspPath).forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }
}
