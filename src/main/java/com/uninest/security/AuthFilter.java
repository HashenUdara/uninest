package com.uninest.security;

import com.uninest.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {
    private static final Set<String> PUBLIC_PATHS = Set.of("/login", "/index.jsp", "/");
    private static final String STATIC_PREFIX = "/static/";
    // Map of exact path -> required roles
    private static final Map<String, Set<String>> PROTECTED = Map.of(
            "/students/add", Set.of("ADMIN")
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String ctx = req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        // Allow static and public
        if (path.startsWith(STATIC_PREFIX) || PUBLIC_PATHS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            // Save original target
            req.getSession().setAttribute("redirectAfterLogin", path + (req.getQueryString()==null?"":"?"+req.getQueryString()));
            resp.sendRedirect(ctx + "/login");
            return;
        }
        // Ensure boolean convenience attribute
        if (req.getSession().getAttribute("isAdmin") == null) {
            req.getSession().setAttribute("isAdmin", user.getRoles().contains("ADMIN"));
        }

        Set<String> needed = PROTECTED.get(path);
        if (needed != null && user.getRoles().stream().noneMatch(needed::contains)) {
            resp.sendError(403);
            return;
        }
        chain.doFilter(request, response);
    }
}
