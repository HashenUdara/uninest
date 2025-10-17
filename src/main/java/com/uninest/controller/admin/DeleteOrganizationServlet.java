package com.uninest.controller.admin;

import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "deleteOrganization", urlPatterns = "/admin/organizations/delete")
public class DeleteOrganizationServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");
        
        try {
            int id = Integer.parseInt(idStr);
            organizationDAO.delete(id);
            
            if (status != null && !status.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/organizations?status=" + status);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/organizations");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
        }
    }
}
