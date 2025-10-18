package com.uninest.controller.moderator;

import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "moderatorDashboard", urlPatterns = "/moderator/dashboard")
public class ModeratorDashboardServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        // If moderator has no approved community, redirect to creation/waiting
        java.util.Optional<com.uninest.model.Community> commOpt = communityDAO.findByCreatorUserId(user.getId());
        if (commOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community/create");
            return;
        }
        if (!commOpt.get().isApproved()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community/waiting");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/moderator/dashboard.jsp").forward(req, resp);
    }
}
