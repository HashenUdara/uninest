package com.uninest.controller.admin;

import com.uninest.model.Organization;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "adminOrganizationEdit", urlPatterns = "/admin/organizations/edit")
public class OrganizationEditServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Optional<Organization> orgOpt = organizationDAO.findById(id);
            if (orgOpt.isPresent()) {
                req.setAttribute("organization", orgOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/admin/organization-edit.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Optional<Organization> orgOpt = organizationDAO.findById(id);
            if (orgOpt.isPresent()) {
                Organization org = orgOpt.get();
                org.setTitle(title);
                org.setDescription(description);
                organizationDAO.update(org);
                resp.sendRedirect(req.getContextPath() + "/admin/organizations?status=" + org.getStatus());
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
        }
    }
}
