package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "rejectOrganization", urlPatterns = "/admin/organizations/reject")
public class RejectOrganizationServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        User admin = (User) req.getSession().getAttribute("authUser");
        try {
            int id = Integer.parseInt(idStr);
            organizationDAO.reject(id, admin.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/organizations?status=rejected");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/organizations");
        }
    }
}
