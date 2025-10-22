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

        try {
            // Get resource ID from parameter
            String resourceIdStr = req.getParameter("id");
            if (resourceIdStr == null || resourceIdStr.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Resource ID is required");
                return;
            }

            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if user owns this resource
            if (resource.getUploadedBy() != user.getId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only delete your own resources");
                return;
            }
            
            // Delete the resource
            boolean deleted = resourceDAO.delete(resourceId);
            
            if (deleted) {
                // Redirect to resources page with success message
                resp.sendRedirect(req.getContextPath() + "/student/resources?delete=success");
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete resource");
            }
            
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource ID");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while deleting the resource");
        }
    }
}
