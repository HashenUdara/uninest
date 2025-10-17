package com.uninest.controller.admin;

import com.uninest.model.Community;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "adminCommunityEdit", urlPatterns = "/admin/communities/edit")
public class CommunityEditServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Optional<Community> commOpt = communityDAO.findById(id);
            if (commOpt.isPresent()) {
                req.setAttribute("community", commOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/admin/community-edit.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/communities");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Optional<Community> commOpt = communityDAO.findById(id);
            if (commOpt.isPresent()) {
                Community comm = commOpt.get();
                comm.setTitle(title);
                comm.setDescription(description);
                communityDAO.update(comm);
                resp.sendRedirect(req.getContextPath() + "/admin/communities?status=" + comm.getStatus());
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/communities");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/communities");
        }
    }
}
