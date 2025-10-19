package com.uninest.controller.student;

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

@WebServlet(name = "cancelJoinRequest", urlPatterns = "/student/cancel-join-request")
public class CancelJoinRequestServlet extends HttpServlet {
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        String idStr = req.getParameter("id");
        
        try {
            int requestId = Integer.parseInt(idStr);
            
            // Verify the request belongs to this user and is pending
            Optional<JoinRequest> requestOpt = joinRequestDAO.findById(requestId);
            if (requestOpt.isEmpty() || requestOpt.get().getUserId() != user.getId() || 
                !"pending".equals(requestOpt.get().getStatus())) {
                req.setAttribute("error", "Invalid request or cannot cancel a processed request.");
                req.getRequestDispatcher("/WEB-INF/views/student/join-community.jsp").forward(req, resp);
                return;
            }
            
            // Delete the request
            if (joinRequestDAO.delete(requestId)) {
                req.setAttribute("success", "Join request cancelled successfully.");
            } else {
                req.setAttribute("error", "Failed to cancel request. Please try again.");
            }
            
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
        }
    }
}
