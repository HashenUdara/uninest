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
import java.util.List;

@WebServlet(name = "manageOrganizations", urlPatterns = "/admin/organizations")
public class ManageOrganizationsServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Get all organizations
        List<Organization> organizations = organizationDAO.findAll();
        req.setAttribute("organizations", organizations);
        req.getRequestDispatcher("/WEB-INF/views/admin/organizations.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String orgIdStr = req.getParameter("orgId");

        if (action == null || orgIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            return;
        }

        try {
            int orgId = Integer.parseInt(orgIdStr);
            
            if ("approve".equals(action)) {
                organizationDAO.updateStatus(orgId, "approved");
            } else if ("reject".equals(action)) {
                organizationDAO.updateStatus(orgId, "rejected");
            }
        } catch (NumberFormatException e) {
            // Invalid org ID
        }

        resp.sendRedirect(req.getContextPath() + "/admin/organizations");
    }
}
