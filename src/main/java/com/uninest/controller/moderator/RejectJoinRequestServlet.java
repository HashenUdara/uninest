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
import java.util.Optional;

@WebServlet(name = "rejectJoinRequest", urlPatterns = "/moderator/join-requests/reject")
public class RejectJoinRequestServlet extends HttpServlet {
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        try {
            int requestId = Integer.parseInt(idStr);
            
            // Fetch the request to verify it belongs to moderator's community
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
            
            // Reject the request
            joinRequestDAO.reject(requestId, moderator.getId());
            
            resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/join-requests");
        }
    }
}
