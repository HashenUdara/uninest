package com.uninest.controller;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "login", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        if (email == null || password == null) {
            req.setAttribute("error", "Email and password required");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty() || !BCrypt.checkpw(password, userOpt.get().getPasswordHash())) {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        User user = userOpt.get();
        req.getSession(true).setAttribute("authUser", user);
        
        // Redirect by role with organization checks
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if (user.isSubjectCoordinator()) {
            resp.sendRedirect(req.getContextPath() + "/coordinator/dashboard");
        } else if (user.isModerator()) {
            // Check if moderator has organization and if it's approved
            Optional<Organization> orgOpt = organizationDAO.findByModeratorId(user.getId());
            if (orgOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/create-organization");
            } else if (!orgOpt.get().isApproved()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/organization-pending");
            } else {
                resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            }
        } else {
            // Student - check if they have joined an organization
            if (user.getOrganizationId() == null) {
                resp.sendRedirect(req.getContextPath() + "/student/join-organization");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
        }
    }
}
