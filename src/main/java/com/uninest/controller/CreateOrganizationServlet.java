package com.uninest.controller;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "createOrganization", urlPatterns = "/moderator/create-organization")
public class CreateOrganizationServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();
    private final UserDAO userDAO = new UserDAO();

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

        // Check if user already has an organization
        Optional<Organization> existingOrg = organizationDAO.findByModeratorId(user.getId());
        if (existingOrg.isPresent()) {
            // Redirect to pending approval page
            resp.sendRedirect(req.getContextPath() + "/moderator/organization-pending");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/moderator/create-organization.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String title = req.getParameter("title");
        String description = req.getParameter("description");

        // Validation
        if (title == null || title.trim().isEmpty()) {
            req.setAttribute("error", "Organization title is required");
            req.getRequestDispatcher("/WEB-INF/views/moderator/create-organization.jsp").forward(req, resp);
            return;
        }

        if (description == null || description.trim().isEmpty()) {
            req.setAttribute("error", "Organization description is required");
            req.getRequestDispatcher("/WEB-INF/views/moderator/create-organization.jsp").forward(req, resp);
            return;
        }

        try {
            Organization organization = new Organization();
            organization.setTitle(title.trim());
            organization.setDescription(description.trim());
            organization.setModeratorId(user.getId());
            organization.setStatus("pending");

            int orgId = organizationDAO.create(organization);
            
            // Update user's organization_id
            userDAO.updateOrganization(user.getId(), orgId);
            
            // Refresh user session with updated organization
            Optional<User> updatedUser = userDAO.findById(user.getId());
            if (updatedUser.isPresent()) {
                session.setAttribute("authUser", updatedUser.get());
            }

            // Redirect to pending approval page
            resp.sendRedirect(req.getContextPath() + "/moderator/organization-pending");
        } catch (RuntimeException e) {
            req.setAttribute("error", "Failed to create organization. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/moderator/create-organization.jsp").forward(req, resp);
        }
    }
}
