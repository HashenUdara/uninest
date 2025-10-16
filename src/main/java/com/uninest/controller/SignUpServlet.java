package com.uninest.controller;

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
        
        // Validate student-specific fields
        if (role.equals("student")) {
            if (academicYearStr == null || academicYearStr.trim().isEmpty() ||
                university == null || university.trim().isEmpty()) {
                req.setAttribute("error", "Academic year and university are required for students");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
                return;
            }
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
        
        if (role.equals("student")) {
            try {
                int academicYear = Integer.parseInt(academicYearStr.trim());
                user.setAcademicYear(academicYear);
                user.setUniversity(university.trim());
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid academic year");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
                return;
            }
        }
        
        try {
            userDAO.create(user);
            // Auto-login after signup
            req.getSession(true).setAttribute("authUser", user);
            
            // Redirect based on role
            if (role.equals("student")) {
                // Student needs to enter organization ID
                resp.sendRedirect(req.getContextPath() + "/student/join-organization");
            } else {
                // Moderator needs to create organization
                resp.sendRedirect(req.getContextPath() + "/moderator/create-organization");
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
        }
    }
}
