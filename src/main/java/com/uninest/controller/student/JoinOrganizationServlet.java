package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "joinOrganization", urlPatterns = "/student/join-organization")
public class JoinOrganizationServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        String orgIdStr = req.getParameter("organizationId");
        try {
            int orgId = Integer.parseInt(orgIdStr);
            Optional<com.uninest.model.Organization> orgOpt = organizationDAO.findById(orgId);
            if (orgOpt.isEmpty() || !orgOpt.get().isApproved()) {
                req.setAttribute("error", "Invalid or not yet approved organization ID");
                req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
                return;
            }
            if (userDAO.assignOrganization(user.getId(), orgId)) {
                user.setOrganizationId(orgId);
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            } else {
                req.setAttribute("error", "Failed to join organization. Try again.");
                req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Please enter a valid organization ID");
            req.getRequestDispatcher("/WEB-INF/views/student/join-organization.jsp").forward(req, resp);
        }
    }
}
