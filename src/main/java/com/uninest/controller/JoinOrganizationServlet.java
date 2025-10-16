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

@WebServlet(name = "joinOrganization", urlPatterns = "/student/join-organization")
public class JoinOrganizationServlet extends HttpServlet {
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
        if (!user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Check if user already has an organization
        if (user.getOrganizationId() != null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String orgIdStr = req.getParameter("organizationId");

        // Validation
        if (orgIdStr == null || orgIdStr.trim().isEmpty()) {
            req.setAttribute("error", "Organization ID is required");
            req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
            return;
        }

        try {
            int orgId = Integer.parseInt(orgIdStr.trim());
            
            // Check if organization exists and is approved
            Optional<Organization> orgOpt = organizationDAO.findById(orgId);
            if (orgOpt.isEmpty()) {
                req.setAttribute("error", "Invalid organization ID");
                req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
                return;
            }

            Organization org = orgOpt.get();
            if (!org.isApproved()) {
                req.setAttribute("error", "Organization is not yet approved by admin");
                req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
                return;
            }

            // Update user's organization
            userDAO.updateOrganization(user.getId(), orgId);
            
            // Refresh user session
            Optional<User> updatedUser = userDAO.findById(user.getId());
            if (updatedUser.isPresent()) {
                session.setAttribute("authUser", updatedUser.get());
            }

            // Redirect to student dashboard
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid organization ID format");
            req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
        } catch (RuntimeException e) {
            req.setAttribute("error", "Failed to join organization. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
        }
    }
}
