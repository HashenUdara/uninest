package com.uninest.controller.moderator;

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

@WebServlet(name = "removeStudent", urlPatterns = "/moderator/students/remove")
public class RemoveStudentServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        try {
            int studentId = Integer.parseInt(idStr);
            
            // Verify the student belongs to the moderator's community
            Optional<User> studentOpt = userDAO.findById(studentId);
            if (studentOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/students");
                return;
            }
            
            User student = studentOpt.get();
            
            // Verify the student is in the moderator's community
            if (moderator.getCommunityId() == null || 
                !moderator.getCommunityId().equals(student.getCommunityId())) {
                resp.sendRedirect(req.getContextPath() + "/moderator/students");
                return;
            }
            
            // Delete all join requests for this student
            joinRequestDAO.deleteByUserId(studentId);
            
            // Remove the community assignment
            userDAO.removeCommunity(studentId);
            
            resp.sendRedirect(req.getContextPath() + "/moderator/students?success=removed");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/students");
        }
    }
}
