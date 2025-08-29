package com.uninest.controller;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "login", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        if (email == null || password == null) {
            req.setAttribute("error", "Email and password required");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }
        User user = userDAO.findByEmail(email);
        if (user == null || !user.isEnabled() || !userDAO.verifyPassword(password, user.getPasswordHash())) {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }
    req.getSession().setAttribute("authUser", user);
    req.getSession().setAttribute("roles", user.getRoles());
    req.getSession().setAttribute("isAdmin", user.getRoles().contains("ADMIN"));
        String target = (String) req.getSession().getAttribute("redirectAfterLogin");
        if (target != null) req.getSession().removeAttribute("redirectAfterLogin");
        resp.sendRedirect(req.getContextPath() + (target != null ? target : "/students"));
    }
}
