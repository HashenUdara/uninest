package com.uninest.controller.coordinator;

import com.uninest.model.User;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "rejectResource", urlPatterns = "/coordinator/resource-approvals/reject")
public class RejectResourceServlet extends HttpServlet {
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
            resp.sendRedirect(req.getContextPath() + "/coordinator/resource-approvals?error=invalid");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            resourceDAO.reject(resourceId, user.getId());
            resp.sendRedirect(req.getContextPath() + "/coordinator/resource-approvals?success=rejected");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/coordinator/resource-approvals?error=failed");
        }
    }
}
