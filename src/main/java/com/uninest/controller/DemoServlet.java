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
    "/student/community",
    "/student/community/new-post",
    "/student/community/post-details",
    "/student/community/subject",
    "/student/community/my-posts",
    "/student/community/edit-post",
    
})
public class DemoServlet extends HttpServlet {
    
    private static final Map<String, String> ROUTE_MAP = new HashMap<>();
    
    static {
        // Community routes
        ROUTE_MAP.put("/student/community", "/WEB-INF/views/student/community/index.jsp");
        ROUTE_MAP.put("/student/community/new-post", "/WEB-INF/views/student/community/new-post.jsp");
        ROUTE_MAP.put("/student/profile-settings", "/WEB-INF/views/general-user/demo/profile-settings.jsp");
        ROUTE_MAP.put("/student/community/post-details", "/WEB-INF/views/student/community/post-details.jsp");
        ROUTE_MAP.put("/student/community/subject", "/WEB-INF/views/student/community/subject.jsp");
        ROUTE_MAP.put("/student/community/my-posts", "/WEB-INF/views/student/community/my-posts.jsp");
        ROUTE_MAP.put("/student/community/edit-post", "/WEB-INF/views/student/community/edit-post.jsp");
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
