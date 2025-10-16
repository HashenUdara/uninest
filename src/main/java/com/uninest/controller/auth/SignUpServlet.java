package com.uninest.controller.auth;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "signup", urlPatterns = "/signup")
public class SignUpServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleStr = req.getParameter("role");
        String academicYearStr = req.getParameter("academicYear");
        String university = req.getParameter("university");

        // Validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || roleStr == null) {
            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Password match validation
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Password strength validation
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Role validation - only STUDENT and MODERATOR allowed
        String role = roleStr.trim().toLowerCase();
        if (!role.equals("student") && !role.equals("moderator")) {
            req.setAttribute("error", "Invalid role selection");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Check if email already exists
        Optional<User> existing = userDAO.findByEmail(email);
        if (existing.isPresent()) {
            req.setAttribute("error", "Email already registered");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Hash password
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(10));

        // Create user
        User user = new User();
        user.setEmail(email.trim());
        user.setPasswordHash(passwordHash);
        user.setRole(role);
        // Only students capture academic year + university on signup
        if (role.equals("student")) {
            try {
                if (academicYearStr != null && !academicYearStr.isBlank()) {
                    int ay = Integer.parseInt(academicYearStr);
                    if (ay >= 1 && ay <= 4) user.setAcademicYear(ay);
                }
            } catch (NumberFormatException ignored) {}
            if (university != null && !university.isBlank()) {
                user.setUniversity(university.trim());
            }
        }
        
        try {
            userDAO.create(user);
            // Auto-login after signup
            req.getSession(true).setAttribute("authUser", user);
            
            // Redirect based on role
            if (role.equals("student")) {
                if (user.getOrganizationId() == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/join-organization");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/moderator/organization/create");
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
        }
    }
}
