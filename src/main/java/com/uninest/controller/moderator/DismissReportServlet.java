package com.uninest.controller.moderator;

import com.uninest.model.CommunityPost;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import com.uninest.model.dao.PostReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet for dismissing reports on community posts.
 * Only accessible by moderators.
 */
@WebServlet(name = "DismissReportServlet", urlPatterns = "/moderator/community/post/dismiss-report")
public class DismissReportServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();
    private final PostReportDAO reportDAO = new PostReportDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null || !"moderator".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String postIdStr = req.getParameter("postId");

        if (postIdStr != null) {
            try {
                int postId = Integer.parseInt(postIdStr);
                
                // Verify post exists and belongs to the moderator's community
                Optional<CommunityPost> postOpt = postDAO.findById(postId);
                if (postOpt.isPresent()) {
                    CommunityPost post = postOpt.get();
                    if (post.getCommunityId() == user.getCommunityId()) {
                        // Dismiss all pending reports for this post
                        reportDAO.dismissReportsForPost(postId, user.getId());
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid IDs
            }
        }

        // Redirect back to the moderator community feed (reported tab)
        String redirectUrl = req.getContextPath() + "/moderator/community?tab=reported";
        resp.sendRedirect(redirectUrl);
    }
}
