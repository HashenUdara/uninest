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

@WebServlet(name = "resourceDetail", urlPatterns = "/student/resources/*")
public class ResourceDetailServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Get resource ID from path
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/upload")) {
            // Not a resource detail request, let other servlets handle it
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            // Remove leading slash and parse resource ID
            String resourceIdStr = pathInfo.substring(1);
            int resourceId = Integer.parseInt(resourceIdStr);
            
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if user has access to this resource
            // Users can view their own resources or approved public resources
            boolean hasAccess = resource.getUploadedBy() == user.getId() || 
                              (resource.getStatus().equals("approved") && resource.getVisibility().equals("public"));
            
            if (!hasAccess) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            req.setAttribute("resource", resource);
            req.getRequestDispatcher("/WEB-INF/views/student/resource-detail.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource ID");
        }
    }
}
