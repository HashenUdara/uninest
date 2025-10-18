package com.uninest.controller.admin;

import com.uninest.model.Community;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "adminCommunityCreate", urlPatterns = "/admin/communities/create")
public class CommunityCreateServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/admin/community-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        
        User admin = (User) req.getSession().getAttribute("authUser");
        
        Community comm = new Community();
        comm.setTitle(title);
        comm.setDescription(description);
        comm.setCreatedByUserId(admin.getId());
        comm.setStatus("approved"); // Admin-created communities are automatically approved
        comm.setApproved(true);
        
        communityDAO.create(comm);
        resp.sendRedirect(req.getContextPath() + "/admin/communities?status=approved");
    }
}
