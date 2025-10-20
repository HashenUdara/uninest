package com.uninest.controller.coordinator;

import com.uninest.model.Resource;
import com.uninest.model.SubjectCoordinator;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "coordinatorResourceApprovals", urlPatterns = "/coordinator/resource-approvals")
public class ResourceApprovalsServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Check if user is a coordinator for any subject
        boolean isCoordinator = coordinatorDAO.isCoordinator(user.getId());
        if (!isCoordinator) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        // Get subjects this user coordinates
        List<Integer> coordinatedSubjectIds = coordinatorDAO.findByUserId(user.getId())
                .stream()
                .map(SubjectCoordinator::getSubjectId)
                .collect(Collectors.toList());

        // Get pending resources for these subjects
        List<Resource> pendingResources = resourceDAO.findPendingBySubjectIds(coordinatedSubjectIds);

        req.setAttribute("resources", pendingResources);
        req.getRequestDispatcher("/WEB-INF/views/coordinator/resource-approvals.jsp").forward(req, resp);
    }
}
