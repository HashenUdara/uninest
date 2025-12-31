package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "rejectCommunity", urlPatterns = "/admin/communities/reject")
public class RejectCommunityServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        User admin = (User) req.getSession().getAttribute("authUser");
        try {
            int id = Integer.parseInt(idStr);
            communityDAO.reject(id, admin.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/communities?status=rejected");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
        }
    }
}
