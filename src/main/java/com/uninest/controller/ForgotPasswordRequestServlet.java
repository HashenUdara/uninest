package com.uninest.controller;

import com.uninest.model.dao.UserDAO;
import com.uninest.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "forgotPasswordRequest", urlPatterns = "/forgot-password")
public class ForgotPasswordRequestServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        Optional<User> userOpt = userDAO.findByEmail(email); // validate existence
        if (userOpt.isEmpty()) {
            req.setAttribute("error", "No account found for that email.");
            req.setAttribute("emailValue", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        String token = userDAO.createResetToken(userOpt.get().getId(), 30); // 30 min
        // For simplicity, display token on confirmation page instead of email send.
        req.setAttribute("resetToken", token);
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password-requested.jsp").forward(req, resp);
    }
}
