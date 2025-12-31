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
import java.util.List;

/**
 * Servlet for displaying the community feed.
 * Fetches posts from database and forwards to index.jsp.
 */
@WebServlet(name = "community", urlPatterns = "/student/communityFeed")
public class CommunityServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Check if user has a community
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }
        
        // Fetch posts for the user's community
        List<CommunityPost> posts = postDAO.findByCommunityIdWithAuthor(user.getCommunityId());
        req.setAttribute("posts", posts);
        
        // Check for success message from post creation
        String postStatus = req.getParameter("post");
        if ("success".equals(postStatus)) {
            req.setAttribute("success", "Post created successfully!");
        }
        
        req.getRequestDispatcher("/WEB-INF/views/student/community/index.jsp").forward(req, resp);
    }
}
