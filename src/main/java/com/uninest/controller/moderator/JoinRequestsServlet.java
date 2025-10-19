package com.uninest.controller.moderator;

import com.uninest.model.JoinRequest;
import com.uninest.model.User;
import com.uninest.model.dao.JoinRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "moderatorJoinRequests", urlPatterns = "/moderator/join-requests")
public class JoinRequestsServlet extends HttpServlet {
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String status = req.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "pending";
        }
        
        List<JoinRequest> requests = joinRequestDAO.findByCommunityAndStatus(moderator.getCommunityId(), status);
        req.setAttribute("requests", requests);
        req.setAttribute("currentStatus", status);
        req.getRequestDispatcher("/WEB-INF/views/moderator/join-requests.jsp").forward(req, resp);
    }
}
