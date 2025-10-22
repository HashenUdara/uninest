package com.uninest.controller.subjectcoordinator;

import com.uninest.model.Resource;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "approveResource", urlPatterns = "/subject-coordinator/resource-approvals/approve")
public class ApproveResourceServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Check if user is a coordinator
        if (!coordinatorDAO.isCoordinator(user.getId())) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        String resourceIdStr = req.getParameter("resourceId");
        if (resourceIdStr == null || resourceIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=invalid");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            
            // Get the resource to check if it's an edit
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            if (resourceOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=notfound");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if this is an edit approval (pending_edit status)
            if ("pending_edit".equals(resource.getStatus()) && resource.getParentResourceId() != null) {
                // Approve edit (this will replace the old version)
                resourceDAO.approveEdit(resourceId, user.getId());
            } else {
                // Regular approval for new uploads
                resourceDAO.approve(resourceId, user.getId());
            }
            
            resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?success=approved");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=failed");
        }
    }
}
