package com.uninest.controller.moderator;

import com.uninest.model.Community;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "moderatorDashboard", urlPatterns = "/moderator/dashboard")
public class ModeratorDashboardServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        // If moderator has no community assigned, redirect to creation
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community/create");
            return;
        }
        // Check if community is approved
        Optional<Community> commOpt = communityDAO.findById(user.getCommunityId());
        if (commOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community/create");
            return;
        }
        Community community = commOpt.get();
        if (!community.isApproved()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community/waiting");
            return;
        }
        
        // Pass community information to the JSP
        req.setAttribute("community", community);
        
        req.getRequestDispatcher("/WEB-INF/views/moderator/dashboard.jsp").forward(req, resp);
    }
}
