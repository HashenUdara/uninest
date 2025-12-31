package com.uninest.controller.auth;

import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "resetPassword", urlPatterns = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            resp.sendError(400, "Missing token");
            return;
        }
        Optional<Integer> userId = userDAO.validateResetToken(token);
        if (userId.isEmpty()) {
            resp.sendError(410, "Token invalid or expired");
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String pass = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        if (token == null || pass == null || confirm == null) {
            resp.sendError(400);
            return;
        }
        if (!pass.equals(confirm)) {
            req.setAttribute("token", token);
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
            return;
        }
        Optional<Integer> userId = userDAO.validateResetToken(token);
        if (userId.isEmpty()) {
            resp.sendError(410, "Token invalid or expired");
            return;
        }
        String hash = BCrypt.hashpw(pass, BCrypt.gensalt(12));
        userDAO.updatePassword(userId.get(), hash);
        userDAO.markTokenUsed(token);
        resp.sendRedirect(req.getContextPath() + "/login?reset=1");
    }
}
