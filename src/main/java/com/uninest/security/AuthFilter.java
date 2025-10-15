package com.uninest.security;

import com.uninest.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = List.of("/login", "/", "/register");
    private static final List<String> STATIC_PREFIXES = List.of("/static/");

    // Map paths to required roles
    private final Map<String, Set<String>> roleRules = Map.of(
        "/admin/", Set.of("admin"),
        "/moderator/", Set.of("admin", "moderator"),
        "/coordinator/", Set.of("admin", "subject_coordinator"),
        "/student/", Set.of("admin", "subject_coordinator", "moderator", "student")
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String ctx = req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        // Allow public paths
        if (PUBLIC_PATHS.contains(path) || STATIC_PREFIXES.stream().anyMatch(path::startsWith)) {
            chain.doFilter(request, response);
            return;
        }

        // Check authentication
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        // Check authorization
        for (Map.Entry<String, Set<String>> entry : roleRules.entrySet()) {
            if (path.startsWith(entry.getKey()) && entry.getValue().stream().noneMatch(user::hasRole)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
