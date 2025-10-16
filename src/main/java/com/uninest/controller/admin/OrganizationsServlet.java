package com.uninest.controller.admin;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "adminOrganizations", urlPatterns = "/admin/organizations")
public class OrganizationsServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Organization> orgs = organizationDAO.findAll();
        req.setAttribute("organizations", orgs);
        req.getRequestDispatcher("/WEB-INF/views/admin/organizations.jsp").forward(req, resp);
    }
}
