package com.uninest.controller.moderator;

import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import com.uninest.model.dao.ModeratorActionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ModeratorDeletePost", urlPatterns = "/moderator/community/post/delete")
public class ModeratorDeletePostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();
    private final ModeratorActionDAO actionDAO = new ModeratorActionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("authUser");
        
        // 1. Auth & Role Check
        if (user == null || !"moderator".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // 2. Get Parameters
        String postIdStr = req.getParameter("postId");
        String reason = req.getParameter("reason");

        if (postIdStr == null || postIdStr.isEmpty() || reason == null || reason.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community?error=invalid_deletion");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            
            // 3. Log the action (Audit Trail)
            boolean logged = actionDAO.logAction(user.getId(), postId, "POST_DELETE", reason.trim());
            
            if (logged) {
                // 4. Perform Deletion
                boolean deleted = postDAO.delete(postId);
                if (deleted) {
                    resp.sendRedirect(req.getContextPath() + "/moderator/community?msg=post_deleted");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/moderator/community?error=deletion_failed");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/moderator/community?error=log_failed");
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community?error=invalid_id");
        }
    }
}
