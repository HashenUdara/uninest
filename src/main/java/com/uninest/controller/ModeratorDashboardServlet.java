package com.uninest.controller;

import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "moderatorDashboard", urlPatterns = "/moderator/dashboard")
public class ModeratorDashboardServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        // If moderator has no approved organization, redirect to creation/waiting
        java.util.Optional<com.uninest.model.Organization> orgOpt = organizationDAO.findByCreatorUserId(user.getId());
        if (orgOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/organization/create");
            return;
        }
        if (!orgOpt.get().isApproved()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/organization/waiting");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/moderator/dashboard.jsp").forward(req, resp);
    }
}
