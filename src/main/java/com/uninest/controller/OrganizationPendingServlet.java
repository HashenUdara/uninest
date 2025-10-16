package com.uninest.controller;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "organizationPending", urlPatterns = "/moderator/organization-pending")
public class OrganizationPendingServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isModerator()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Check organization status
        Optional<Organization> orgOpt = organizationDAO.findByModeratorId(user.getId());
        if (orgOpt.isEmpty()) {
            // No organization, redirect to create
            resp.sendRedirect(req.getContextPath() + "/moderator/create-organization");
            return;
        }

        Organization org = orgOpt.get();
        if (org.isApproved()) {
            // Organization is approved, redirect to dashboard
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        // Set organization in request for JSP
        req.setAttribute("organization", org);
        req.getRequestDispatcher("/WEB-INF/views/moderator/organization-pending.jsp").forward(req, resp);
    }
}
