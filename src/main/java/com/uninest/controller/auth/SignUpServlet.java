package com.uninest.controller.auth;

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
        req.setAttribute("universities", universityDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleStr = req.getParameter("role");
        String academicYearStr = req.getParameter("academicYear");
        String universityIdStr = req.getParameter("universityId");

        // Validation
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
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
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setPasswordHash(passwordHash);
        user.setRole(role);
        // Both students and moderators capture academic year + university on signup
        try {
            if (academicYearStr != null && !academicYearStr.isBlank()) {
                int ay = Integer.parseInt(academicYearStr);
                if (ay >= 1 && ay <= 4) user.setAcademicYear(ay);
            }
        } catch (NumberFormatException ignored) {}
        try {
            if (universityIdStr != null && !universityIdStr.isBlank()) {
                user.setUniversityId(Integer.parseInt(universityIdStr));
            }
        } catch (NumberFormatException ignored) {}
        
        // Set university ID number and faculty
        String universityIdNumber = req.getParameter("universityIdNumber");
        String faculty = req.getParameter("faculty");
        if (universityIdNumber != null && !universityIdNumber.trim().isEmpty()) {
            user.setUniversityIdNumber(universityIdNumber.trim());
        }
        if (faculty != null && !faculty.trim().isEmpty()) {
            user.setFaculty(faculty.trim());
        }
        
        try {
            userDAO.create(user);
            // Auto-login after signup
            req.getSession(true).setAttribute("authUser", user);
            
            // Redirect based on role
            if (role.equals("student")) {
                if (user.getCommunityId() == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/join-community");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/moderator/community/create");
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(req, resp);
        }
    }
}
