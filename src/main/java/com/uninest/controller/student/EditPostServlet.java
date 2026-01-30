package com.uninest.controller.student;

import com.uninest.model.CommunityPost;
import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

/**
 * Servlet for editing community posts.
 * Handles GET/POST for /student/community/edit-post
 */
@WebServlet(name = "editPost", urlPatterns = "/student/community/edit-post")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold
    maxFileSize = 1024 * 1024 * 10,        // 10MB max
    maxRequestSize = 1024 * 1024 * 15      // 15MB total
)
public class EditPostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();
    
    // Store uploads OUTSIDE webapp to survive redeployments
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + "/uninest-uploads";
    private static final String UPLOAD_DIRECTORY = "community-posts";
    
    // Allowed image extensions
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Get post ID from request parameter
        String postIdParam = req.getParameter("id");
        if (postIdParam == null || postIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
            return;
        }
        
        int postId;
        try {
            postId = Integer.parseInt(postIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
            return;
        }
        
        // Fetch post by ID
        Optional<CommunityPost> postOpt = postDAO.findById(postId);
        if (postOpt.isEmpty()) {
            req.setAttribute("error", "Post not found");
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
            return;
        }
        
        CommunityPost post = postOpt.get();
        
        // Check if the current user is the owner of this post
        if (post.getUserId() != user.getId()) {
            req.setAttribute("error", "You can only edit your own posts");
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
            return;
        }
        
        // Fetch subjects for the user's community and academic year
        SubjectDAO subjectDAO = new SubjectDAO();
        List<Subject> subjects = subjectDAO.findByCommunityAndYear(
            user.getCommunityId(), 
            user.getAcademicYear()
        );
        req.setAttribute("subjects", subjects);
        req.setAttribute("post", post);
        req.getRequestDispatcher("/WEB-INF/views/student/community/edit-post.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Get post ID
            String postIdParam = req.getParameter("id");
            if (postIdParam == null || postIdParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
                return;
            }
            
            int postId = Integer.parseInt(postIdParam);
            
            // Fetch existing post
            Optional<CommunityPost> postOpt = postDAO.findById(postId);
            if (postOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
                return;
            }
            
            CommunityPost post = postOpt.get();
            
            // Verify ownership
            if (post.getUserId() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/my-posts");
                return;
            }
            
            // Get form parameters
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String topic = req.getParameter("topic");
            
            // If topic is null or empty, default to "Common"
            if (topic == null || topic.trim().isEmpty()) {
                topic = "Common";
            }
            
            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Title is required");
                req.setAttribute("post", post);
                req.getRequestDispatcher("/WEB-INF/views/student/community/edit-post.jsp").forward(req, resp);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                req.setAttribute("error", "Content is required");
                req.setAttribute("post", post);
                req.getRequestDispatcher("/WEB-INF/views/student/community/edit-post.jsp").forward(req, resp);
                return;
            }

            // Handle optional image upload
            Part filePart = req.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String extension = getFileExtension(fileName).toLowerCase();
                
                // Validate file extension
                if (!ALLOWED_EXTENSIONS.contains(extension)) {
                    req.setAttribute("error", "Invalid image type. Allowed: JPG, PNG, GIF");
                    req.setAttribute("post", post);
                    req.getRequestDispatcher("/WEB-INF/views/student/community/edit-post.jsp").forward(req, resp);
                    return;
                }
                
                // Create upload directory if it doesn't exist
                String uploadPath = UPLOAD_BASE_PATH + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Generate unique file name
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                // Save the file
                filePart.write(filePath);
                
                // Update image URL
                post.setImageUrl(UPLOAD_DIRECTORY + "/" + uniqueFileName);
            }
            
            // Update post fields
            post.setTopic(topic);
            post.setTitle(title.trim());
            post.setContent(content.trim());
            
            // Save to database
            postDAO.update(post);
            
            // Redirect to my posts with success message
            resp.sendRedirect(req.getContextPath() + "/student/community/my-posts?update=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to update post: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
    /**
     * Extracts the filename from the Content-Disposition header.
     */
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                String fileName = element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }
        return "unknown";
    }
    
    /**
     * Extracts the file extension from a filename.
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0 && lastDot < fileName.length() - 1) {
            return fileName.substring(lastDot + 1);
        }
        return "";
    }
}
