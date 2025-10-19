package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import com.uninest.model.dao.JoinRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "joinCommunity", urlPatterns = "/student/join-community")
public class JoinCommunityServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        
        // Check if student already has a community (approved by moderator)
        if (user.getCommunityId() != null) {
            // Redirect to dashboard if already in a community
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        
        // Check if there's a pending request
        Optional<com.uninest.model.JoinRequest> pendingRequest = 
            joinRequestDAO.findPendingRequestByUser(user.getId());
        
        if (pendingRequest.isPresent()) {
            req.setAttribute("pendingRequest", pendingRequest.get());
        }
        
        req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        
        // Check if student already has a community
        if (user.getCommunityId() != null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        
        // Check if there's already a pending request (for any community)
        Optional<com.uninest.model.JoinRequest> existingPending = 
            joinRequestDAO.findPendingRequestByUser(user.getId());
        
        if (existingPending.isPresent()) {
            req.setAttribute("pendingRequest", existingPending.get());
            req.setAttribute("error", "You already have a pending request. Please cancel it first before submitting a new one.");
            req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
            return;
        }
        
        String commIdStr = req.getParameter("communityId");
        try {
            int commId = Integer.parseInt(commIdStr);
            Optional<com.uninest.model.Community> commOpt = communityDAO.findById(commId);
            if (commOpt.isEmpty() || !commOpt.get().isApproved()) {
                req.setAttribute("error", "Invalid or not yet approved community ID");
                req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
                return;
            }
            
            // Create join request
            int requestId = joinRequestDAO.create(user.getId(), commId);
            if (requestId > 0) {
                // Fetch the created request to display it
                Optional<com.uninest.model.JoinRequest> newRequest = joinRequestDAO.findById(requestId);
                if (newRequest.isPresent()) {
                    req.setAttribute("pendingRequest", newRequest.get());
                }
                req.setAttribute("success", "Join request submitted! Please wait for moderator approval.");
                req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Failed to submit join request. Try again.");
                req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Please enter a valid community ID");
            req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
        }
    }
}
