package com.uninest.controller.student;

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
 * Servlet for deleting community posts.
 * Handles POST /student/community/delete-post
 */
@WebServlet(name = "deletePost", urlPatterns = "/student/community/delete-post")
public class DeletePostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Get post ID from request parameter
            String postIdParam = req.getParameter("id");
            if (postIdParam == null || postIdParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=invalid");
                return;
            }
            
            int postId = Integer.parseInt(postIdParam);
            
            // Fetch post to verify ownership
            Optional<CommunityPost> postOpt = postDAO.findById(postId);
            if (postOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=notfound");
                return;
            }
            
            CommunityPost post = postOpt.get();
            
            // Verify ownership - only the author can delete
            if (post.getUserId() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=unauthorized");
                return;
            }
            
            // Delete the post
            boolean deleted = postDAO.delete(postId);
            
            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?delete=success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=failed");
            }
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?error=failed");
        }
    }
}
