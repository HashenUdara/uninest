package com.uninest.security;

import com.uninest.model.User;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = List.of("/login", "/", "/register");
    private static final List<String> STATIC_PREFIXES = List.of("/static/");

    // Map paths to required roles (excluding coordinator which is checked separately)
    private final Map<String, Set<String>> roleRules = Map.of(
        "/admin/", Set.of("admin"),
        "/moderator/", Set.of("admin", "moderator"),
        "/student/", Set.of("admin", "moderator", "student")
    );
    
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

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

        // Special check for subject coordinator paths - check subject_coordinators table
        if (path.startsWith("/subject-coordinator/")) {
            // Admins can access all subject coordinator pages
            if (user.hasRole("admin")) {
                chain.doFilter(request, response);
                return;
            }
            // Check if user is a subject coordinator via the table
            if (!coordinatorDAO.isCoordinator(user.getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Check authorization for other paths
        for (Map.Entry<String, Set<String>> entry : roleRules.entrySet()) {
            if (path.startsWith(entry.getKey()) && entry.getValue().stream().noneMatch(user::hasRole)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
