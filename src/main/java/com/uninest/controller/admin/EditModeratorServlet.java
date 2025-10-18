package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "adminEditModerator", urlPatterns = "/admin/moderators/edit")
public class EditModeratorServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> moderatorOpt = userDAO.findById(id);
        
        if (moderatorOpt.isEmpty() || !moderatorOpt.get().isModerator()) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        req.setAttribute("moderator", moderatorOpt.get());
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.getRequestDispatcher("/WEB-INF/views/admin/edit-moderator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> moderatorOpt = userDAO.findById(id);
        
        if (moderatorOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        User moderator = moderatorOpt.get();
        moderator.setEmail(req.getParameter("email"));
        
        String university = req.getParameter("university");
        if (university != null && !university.isEmpty()) {
            moderator.setUniversity(university);
        } else {
            moderator.setUniversity(null);
        }
        
        String communityIdStr = req.getParameter("communityId");
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            moderator.setCommunityId(Integer.parseInt(communityIdStr));
        } else {
            moderator.setCommunityId(null);
        }

        userDAO.update(moderator);
        resp.sendRedirect(req.getContextPath() + "/admin/moderators?success=updated");
    }
}
