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
import java.util.List;

/**
 * Servlet for displaying the community feed to Moderators.
 */
@WebServlet(name = "ModeratorCommunity", urlPatterns = "/moderator/community")
public class ModeratorCommunityServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Ensure only moderators can access (Role check)
        if (!"moderator".equalsIgnoreCase(user.getRole())) {
             resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
             return;
        }

        // Check if user has a community
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard?error=no_community");
            return;
        }

        String tab = req.getParameter("tab");
        if (tab == null) tab = "upvoted"; // Default
        
        List<CommunityPost> posts;
        if ("deleted".equalsIgnoreCase(tab)) {
            posts = postDAO.findDeletedByCommunityId(user.getCommunityId());
        } else {
            // Fetch active posts (Same DAO logic as students)
            // Note: upvoted/recent sorting could be added here in future
            posts = postDAO.findByCommunityIdWithAuthor(user.getCommunityId());
        }
        
        req.setAttribute("posts", posts);
        req.setAttribute("activeTab", tab);
        
        req.getRequestDispatcher("/WEB-INF/views/moderator/community/index.jsp").forward(req, resp);
    }
}
