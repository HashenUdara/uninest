package com.uninest.controller;

import com.uninest.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "studentDashboard", urlPatterns = "/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Check if student has joined an organization
        if (user.getOrganizationId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-organization");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}
