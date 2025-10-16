package com.uninest.controller;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import com.uninest.model.dao.UniversityDAO;
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
    private final UniversityDAO universityDAO = new UniversityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Load universities for the form
        req.setAttribute("universities", universityDAO.findAll());
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
        String universityStr = req.getParameter("university");

        // Validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || roleStr == null ||
            academicYearStr == null || academicYearStr.trim().isEmpty() ||
            universityStr == null || universityStr.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Password match validation
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Password strength validation
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Role validation - only STUDENT and MODERATOR allowed
        String role = roleStr.trim().toLowerCase();
        if (!role.equals("student") && !role.equals("moderator")) {
            req.setAttribute("error", "Invalid role selection");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }
        
        // Parse academic year and university
        int academicYear;
        int universityId;
        try {
            academicYear = Integer.parseInt(academicYearStr);
            universityId = Integer.parseInt(universityStr);
            if (academicYear < 1 || academicYear > 4) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid academic year or university selection");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
            return;
        }

        // Check if email already exists
        Optional<User> existing = userDAO.findByEmail(email);
        if (existing.isPresent()) {
            req.setAttribute("error", "Email already registered");
            req.setAttribute("universities", universityDAO.findAll());
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
        user.setAcademicYear(academicYear);
        user.setUniversityId(universityId);
        
        // Moderators need approval, students are auto-approved
        if (role.equals("moderator")) {
            user.setApproved(false);
        } else {
            user.setApproved(true);
        }
        
        try {
            userDAO.create(user);
            
            // Redirect based on role and approval status
            if (role.equals("student")) {
                // Auto-login students
                req.getSession(true).setAttribute("authUser", user);
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            } else {
                // Moderators go to pending approval page (no login)
                resp.sendRedirect(req.getContextPath() + "/auth/pending-approval");
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.setAttribute("universities", universityDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
        }
    }
}
