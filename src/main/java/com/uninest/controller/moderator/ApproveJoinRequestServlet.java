package com.uninest.controller.moderator;

import com.uninest.model.JoinRequest;
import com.uninest.model.User;
import com.uninest.model.dao.JoinRequestDAO;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "approveJoinRequest", urlPatterns = "/moderator/join-requests/approve")
public class ApproveJoinRequestServlet extends HttpServlet {
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        try {
            int requestId = Integer.parseInt(idStr);
            
            // Fetch the request to get user and community IDs
            Optional<JoinRequest> requestOpt = joinRequestDAO.findById(requestId);
            if (requestOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
                return;
            }
            
            JoinRequest request = requestOpt.get();
            
            // Verify the request is for moderator's community
            if (moderator.getCommunityId() == null || 
                !moderator.getCommunityId().equals(request.getCommunityId())) {
                resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
                return;
            }
            
            // Approve the request
            if (joinRequestDAO.approve(requestId, moderator.getId())) {
                // Assign the community to the user
                userDAO.assignCommunity(request.getUserId(), request.getCommunityId());
            }
            
            resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
        }
    }
}
