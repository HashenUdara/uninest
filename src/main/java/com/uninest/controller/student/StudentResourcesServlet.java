package com.uninest.controller.student;

import com.uninest.model.Resource;
import com.uninest.model.ResourceCategory;
import com.uninest.model.Subject;
import com.uninest.model.Topic;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceCategoryDAO;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import com.uninest.model.dao.SubjectDAO;
import com.uninest.model.dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "studentResources", urlPatterns = "/student/resources")
public class StudentResourcesServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final ResourceCategoryDAO categoryDAO = new ResourceCategoryDAO();
    private final TopicDAO topicDAO = new TopicDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Check if this is a topic-specific view
        String topicIdParam = req.getParameter("topicId");
        Integer topicId = null;
        Topic topic = null;
        Subject subject = null;
        
        if (topicIdParam != null && !topicIdParam.isEmpty()) {
            try {
                topicId = Integer.parseInt(topicIdParam);
                Optional<Topic> topicOpt = topicDAO.findById(topicId);
                if (topicOpt.isPresent()) {
                    topic = topicOpt.get();
                    // Fetch the subject for breadcrumbs
                    Optional<Subject> subjectOpt = subjectDAO.findById(topic.getSubjectId());
                    if (subjectOpt.isPresent()) {
                        subject = subjectOpt.get();
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid topic ID
            }
        }

        // Get category filter if provided
        String categoryIdParam = req.getParameter("category");
        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid category ID
            }
        }

        // Get resources based on view type
        List<Resource> resources;
        if (topicId != null) {
            // Topic-specific view: show approved resources for this topic
            if (categoryId != null) {
                resources = resourceDAO.findByTopicIdAndCategory(topicId, categoryId);
            } else {
                resources = resourceDAO.findByTopicId(topicId);
            }
        } else {
            // User-specific view: show user's own resources
            if (categoryId != null) {
                resources = resourceDAO.findByUserIdAndCategory(user.getId(), categoryId);
            } else {
                resources = resourceDAO.findByUserId(user.getId());
            }
        }

        // Get all categories for the filter tabs
        List<ResourceCategory> categories = categoryDAO.findAll();

        // Check if user is coordinator for this subject (if topic view)
        boolean isCoordinatorForSubject = false;
        if (subject != null) {
            isCoordinatorForSubject = coordinatorDAO.isCoordinatorForSubject(user.getId(), subject.getSubjectId());
        }

        req.setAttribute("resources", resources);
        req.setAttribute("categories", categories);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("topic", topic);
        req.setAttribute("topicId", topicId);
        req.setAttribute("subject", subject);
        req.setAttribute("isCoordinatorForSubject", isCoordinatorForSubject);

        req.getRequestDispatcher("/WEB-INF/views/student/resources.jsp").forward(req, resp);
    }
}
