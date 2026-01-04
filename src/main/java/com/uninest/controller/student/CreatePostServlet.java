package com.uninest.controller.student;

import com.uninest.model.CommunityPost;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
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

/**
 * Servlet for creating new community posts.
 * Handles both displaying the form (GET) and processing submissions (POST).
 */
@WebServlet(name = "createPost", urlPatterns = "/student/community/posts/create")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold
    maxFileSize = 1024 * 1024 * 10,        // 10MB max
    maxRequestSize = 1024 * 1024 * 15      // 15MB total
)
public class CreatePostServlet extends HttpServlet {
    
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
        
        // Check if user has a community
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/student/community/new-post.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Check if user has a community
        if (user.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }

        try {
            // Get form parameters
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            
            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Title is required");
                doGet(req, resp);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                req.setAttribute("error", "Content is required");
                doGet(req, resp);
                return;
            }

            // Handle optional image upload
            String imageUrl = null;
            Part filePart = req.getPart("image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String extension = getFileExtension(fileName).toLowerCase();
                
                // Validate file extension
                if (!ALLOWED_EXTENSIONS.contains(extension)) {
                    req.setAttribute("error", "Invalid image type. Allowed: JPG, PNG, GIF");
                    doGet(req, resp);
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
                
                // Store relative path for database (served via /uploads/* FileServlet)
                imageUrl = UPLOAD_DIRECTORY + "/" + uniqueFileName;
            }
            
            // Create post object
            CommunityPost post = new CommunityPost();
            post.setUserId(user.getId());
            post.setCommunityId(user.getCommunityId());
            post.setTitle(title.trim()); //.trim() removes leading/trailing spaces from the input string
            post.setContent(content.trim());
            post.setImageUrl(imageUrl);
            
            // Save to database
            postDAO.create(post);
            
            // Redirect to community page with success message
            resp.sendRedirect(req.getContextPath() + "/student/community?post=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to create post: " + e.getMessage());
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
