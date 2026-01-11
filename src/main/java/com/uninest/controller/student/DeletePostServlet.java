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
 * Handles POST /student/community/posts/delete
 */
@WebServlet(name = "deletePost", urlPatterns = "/student/community/posts/delete")
public class DeletePostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set response type to JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        // Check authentication
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }


        // Get and validate post ID
        String postIdStr = req.getParameter("postId");
        
        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\": false, \"message\": \"Invalid post ID\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            
            // Check if post exists
            Optional<CommunityPost> postOpt = postDAO.findById(postId);
            if (postOpt.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"success\": false, \"message\": \"Post not found\"}");
                return;
            }
            
            CommunityPost post = postOpt.get();
            
            // Verify ownership - only the author can delete their post
            if (post.getUserId() != user.getId()) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("{\"success\": false, \"message\": \"You can only delete your own posts\"}");
                return;
            }
            
            // Delete the post
            boolean deleted = postDAO.delete(postId);
            
            if (deleted) {
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"success\": true, \"message\": \"Post deleted successfully\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\": false, \"message\": \"Failed to delete post\"}");
            }
            
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\": false, \"message\": \"Invalid post ID format\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\": false, \"message\": \"An error occurred while deleting the post\"}");
        }
    }
}
