package com.uninest.controller.student;

import com.uninest.model.Community;
import com.uninest.model.CommunityPost;
import com.uninest.model.Resource;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import com.uninest.model.dao.CommunityPostDAO;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet(name = "studentDashboard", urlPatterns = "/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();
    private final CommunityPostDAO communityPostDAO = new CommunityPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }
        
        // Fetch community information
        Optional<Community> communityOpt = communityDAO.findById(user.getCommunityId());
        if (communityOpt.isPresent()) {
            req.setAttribute("community", communityOpt.get());
        }
        
        // Check if user is a coordinator
        boolean isCoordinator = coordinatorDAO.isCoordinator(user.getId());
        req.getSession().setAttribute("isCoordinator", isCoordinator);
        
        // Get student's pending resources
        List<Resource> allResources = resourceDAO.findByUserId(user.getId());
        
        // Filter pending new uploads
        List<Resource> pendingNewUploads = allResources.stream()
                .filter(r -> "pending".equals(r.getStatus()) && "new".equals(r.getEditType()))
                .collect(Collectors.toList());
        
        // Filter pending edits
        List<Resource> pendingEdits = allResources.stream()
                .filter(r -> "pending_edit".equals(r.getStatus()))
                .collect(Collectors.toList());
        
        req.setAttribute("pendingNewUploads", pendingNewUploads);
        req.setAttribute("pendingEdits", pendingEdits);
        
        // Fetch community posts for Community Highlights section
        List<CommunityPost> communityPosts = communityPostDAO.findAll();
        req.setAttribute("communityPosts", communityPosts);
        
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null || user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }
        
        String content = req.getParameter("postContent");
        
        // Validate content
        if (content != null && !content.trim().isEmpty()) {
            // Create new community post (quick post from dashboard - no title)
            CommunityPost newPost = new CommunityPost();
            newPost.setUserId(user.getId());
            newPost.setCommunityId(user.getCommunityId());
            newPost.setTitle("Quick Post"); // Default title for dashboard posts
            newPost.setContent(content.trim());
            communityPostDAO.create(newPost);
        }
        
        // Redirect back to dashboard to show updated posts
        resp.sendRedirect(req.getContextPath() + "/student/dashboard");
    }
}
