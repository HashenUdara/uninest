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
 * Servlet for displaying the user's own posts.
 * Handles GET /student/community/my-posts
 */
@WebServlet(name = "myPosts", urlPatterns = "/student/community/my-posts")
public class MyPostsServlet extends HttpServlet {

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

        // Fetch posts for current user
        List<CommunityPost> posts = postDAO.findByUserId(user.getId());

        // Enrich with poll vote state
        com.uninest.model.dao.PollDAO pollDAO = new com.uninest.model.dao.PollDAO();
        for (CommunityPost post : posts) {
            if (post.getPoll() != null) {
                pollDAO.loadUserVoteState(post.getPoll(), user.getId());
            }
        }

        req.setAttribute("posts", posts);

        req.getRequestDispatcher("/WEB-INF/views/student/community/my-posts.jsp").forward(req, resp);
    }
}
