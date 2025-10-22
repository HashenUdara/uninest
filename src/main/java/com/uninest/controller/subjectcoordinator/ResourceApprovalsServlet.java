package com.uninest.controller.subjectcoordinator;

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
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "subjectCoordinatorResourceApprovals", urlPatterns = "/subject-coordinator/resource-approvals")
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

        // Get the active tab (default to "new")
        String activeTab = req.getParameter("tab");
        if (activeTab == null || activeTab.isEmpty()) {
            activeTab = "new";
        }

        List<Resource> resources;
        if ("edits".equals(activeTab)) {
            // Get pending edit resources
            resources = resourceDAO.findPendingEditsBySubjectIds(coordinatedSubjectIds);
        } else {
            // Get pending new upload resources
            resources = resourceDAO.findPendingNewUploadsBySubjectIds(coordinatedSubjectIds);
        }

        req.setAttribute("resources", resources);
        req.setAttribute("activeTab", activeTab);
        req.getRequestDispatcher("/WEB-INF/views/subject-coordinator/resource-approvals.jsp").forward(req, resp);
    }
}
