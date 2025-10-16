package com.uninest.controller.moderator;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "organizationCreate", urlPatterns = "/moderator/organization/create")
public class OrganizationCreateServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/moderator/organization-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        String title = req.getParameter("title");
        String description = req.getParameter("description");

        if (title == null || title.trim().isEmpty()) {
            req.setAttribute("error", "Title is required");
            req.getRequestDispatcher("/WEB-INF/views/moderator/organization-create.jsp").forward(req, resp);
            return;
        }

        Organization org = new Organization();
        org.setTitle(title.trim());
        org.setDescription(description == null ? null : description.trim());
        org.setCreatedByUserId(user.getId());
        organizationDAO.create(org);

        resp.sendRedirect(req.getContextPath() + "/moderator/organization/waiting");
    }
}
