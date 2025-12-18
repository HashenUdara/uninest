package com.uninest.controller.subjectcoordinator;

import com.uninest.model.Resource;
import com.uninest.model.SubjectCoordinator;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import com.uninest.model.dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet(name = "deleteResourceCoordinator", urlPatterns = "/subject-coordinator/resource-approvals/delete")
public class DeleteResourceServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    private final TopicDAO topicDAO = new TopicDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Check if user is a coordinator
        boolean isCoordinator = coordinatorDAO.isCoordinator(user.getId());
        if (!isCoordinator) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=unauthorized");
            return;
        }

        String resourceIdStr = req.getParameter("resourceId");
        if (resourceIdStr == null || resourceIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=invalid");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=notfound");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Get the subject ID for this resource via its topic
            int topicId = resource.getTopicId();
            Optional<com.uninest.model.Topic> topic = topicDAO.findById(topicId);
            if (topic.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=notfound");
                return;
            }
            int subjectId = topic.get().getSubjectId();
            
            // Check if user is coordinator for this resource's subject
            boolean isCoordinatorForSubject = coordinatorDAO.isCoordinatorForSubject(user.getId(), subjectId);
            if (!isCoordinatorForSubject) {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=unauthorized");
                return;
            }
            
            // Delete the resource
            boolean deleted = resourceDAO.delete(resourceId);
            
            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?delete=success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=failed");
            }
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/subject-coordinator/resource-approvals?error=invalid");
        }
    }
}
