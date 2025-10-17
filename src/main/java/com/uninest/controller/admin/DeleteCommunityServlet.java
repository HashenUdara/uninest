package com.uninest.controller.admin;

import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "deleteCommunity", urlPatterns = "/admin/communities/delete")
public class DeleteCommunityServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");
        
        try {
            int id = Integer.parseInt(idStr);
            communityDAO.delete(id);
            
            if (status != null && !status.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/communities?status=" + status);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/communities");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
        }
    }
}
