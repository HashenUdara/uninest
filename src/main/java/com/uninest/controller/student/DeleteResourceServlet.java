package com.uninest.controller.student;

import com.uninest.model.Resource;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "deleteResource", urlPatterns = "/student/resources/delete")
public class DeleteResourceServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String resourceIdStr = req.getParameter("resourceId");
        if (resourceIdStr == null || resourceIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/resources?error=invalid");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources?error=notfound");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if user owns this resource
            if (resource.getUploadedBy() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources?error=unauthorized");
                return;
            }
            
            // Only allow deletion of pending, rejected, or pending_edit resources
            if (!resource.getStatus().equals("pending") && 
                !resource.getStatus().equals("rejected") && 
                !resource.getStatus().equals("pending_edit")) {
                resp.sendRedirect(req.getContextPath() + "/student/resources?error=cannotdelete");
                return;
            }
            
            // Delete the resource
            boolean deleted = resourceDAO.delete(resourceId);
            
            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/student/resources?delete=success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/resources?error=failed");
            }
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/resources?error=invalid");
        }
    }
}
