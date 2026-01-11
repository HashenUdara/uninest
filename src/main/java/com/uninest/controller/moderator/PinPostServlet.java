package com.uninest.controller.moderator;

import com.uninest.model.CommunityPost;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet for pinning/unpinning community posts.
 * Only accessible by moderators.
 */
@WebServlet(name = "PinPostServlet", urlPatterns = "/moderator/community/post/pin")
public class PinPostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null || !"moderator".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String postIdStr = req.getParameter("postId");
        String pinAction = req.getParameter("action"); // "pin" or "unpin"

        if (postIdStr != null) {
            try {
                int postId = Integer.parseInt(postIdStr);
                boolean isPinned = "pin".equalsIgnoreCase(pinAction);
                
                // Verify post exists and belongs to the moderator's community
                Optional<CommunityPost> postOpt = postDAO.findById(postId);
                if (postOpt.isPresent()) {
                    CommunityPost post = postOpt.get();
                    if (post.getCommunityId() == user.getCommunityId()) {
                        postDAO.setPinned(postId, isPinned);
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid IDs
            }
        }

        // Redirect back to the moderator community feed
        String redirectUrl = req.getContextPath() + "/moderator/community";
        String tab = req.getParameter("tab");
        if (tab != null) {
            redirectUrl += "?tab=" + tab;
        }
        resp.sendRedirect(redirectUrl);
    }
}
