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

/**
 * Servlet for creating new community posts.
 * Handles the form submission from new-post.jsp.
 */
@WebServlet(name = "createPost", urlPatterns = "/student/community/posts/create")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB max per image
    maxRequestSize = 1024 * 1024 * 15     // 15MB total
)
public class CreatePostServlet extends HttpServlet {
    
    private final CommunityPostDAO postDAO = new CommunityPostDAO();
    
    // Store uploads outside webapp to survive redeployments
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + "/uninest-uploads";
    private static final String UPLOAD_DIRECTORY = "post-images";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redirect GET requests to the new-post page
        resp.sendRedirect(req.getContextPath() + "/student/community/new-post");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        
        // Check authentication
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Check community membership
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
                req.getRequestDispatcher("/WEB-INF/views/student/community/new-post.jsp").forward(req, resp);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                req.setAttribute("error", "Content is required");
                req.getRequestDispatcher("/WEB-INF/views/student/community/new-post.jsp").forward(req, resp);
                return;
            }
            
            // Handle optional image upload
            String imageUrl = null;
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                imageUrl = saveImage(imagePart);
            }
            
            // Create the post
            CommunityPost post = new CommunityPost();
            post.setUserId(user.getId());
            post.setCommunityId(user.getCommunityId());
            post.setTitle(title.trim());
            post.setContent(content.trim());
            post.setImageUrl(imageUrl);
            
            postDAO.create(post);
            
            // Redirect to community feed with success message
            resp.sendRedirect(req.getContextPath() + "/student/community?posted=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to create post: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/student/community/new-post.jsp").forward(req, resp);
        }
    }
    
    /**
     * Saves an uploaded image and returns the relative URL.
     */
    private String saveImage(Part imagePart) throws IOException {
        String fileName = getSubmittedFileName(imagePart);
        String fileExtension = getFileExtension(fileName);
        
        // Validate it's an image
        String contentType = imagePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IOException("Invalid file type. Only images are allowed.");
        }
        
        // Create upload directory if needed
        String uploadPath = UPLOAD_BASE_PATH + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Generate unique filename
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;
        
        // Save the file
        imagePart.write(filePath);
        
        // Return relative path for database
        return UPLOAD_DIRECTORY + "/" + uniqueFileName;
    }
    
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
    
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0 && lastDot < fileName.length() - 1) {
            return fileName.substring(lastDot + 1).toLowerCase();
        }
        return "unknown";
    }
}
