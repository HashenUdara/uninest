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

@WebServlet(name = "login", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

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
        
        // Check if moderator is approved
        if (user.isModerator() && !user.isApproved()) {
            req.setAttribute("error", "Your moderator account is pending approval by an administrator");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        
        req.getSession(true).setAttribute("authUser", user);
        // Redirect by role
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if (user.isSubjectCoordinator()) {
            resp.sendRedirect(req.getContextPath() + "/coordinator/dashboard");
        } else if (user.isModerator()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}
