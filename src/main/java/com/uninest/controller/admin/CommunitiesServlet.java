package com.uninest.controller.admin;

import com.uninest.model.Community;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "adminCommunities", urlPatterns = "/admin/communities")
public class CommunitiesServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status = req.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "pending";
        }
        
        List<Community> communities = communityDAO.findByStatus(status);
        req.setAttribute("communities", communities);
        req.setAttribute("currentStatus", status);
        req.getRequestDispatcher("/WEB-INF/views/admin/communities.jsp").forward(req, resp);
    }
}
