package com.uninest.controller.student;

import com.uninest.model.Resource;
import com.uninest.model.ResourceCategory;
import com.uninest.model.Subject;
import com.uninest.model.Topic;
import com.uninest.model.User;
import com.uninest.model.dao.ResourceCategoryDAO;
import com.uninest.model.dao.ResourceDAO;
import com.uninest.model.dao.SubjectDAO;
import com.uninest.model.dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "editResource", urlPatterns = "/student/resources/edit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 60    // 60MB
)
public class EditResourceServlet extends HttpServlet {
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final ResourceCategoryDAO categoryDAO = new ResourceCategoryDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final TopicDAO topicDAO = new TopicDAO();
    
    // Store uploads outside the webapp to survive redeployments
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + "/uninest-uploads";
    private static final String UPLOAD_DIRECTORY = "resources";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String resourceIdStr = req.getParameter("resourceId");
        if (resourceIdStr == null || resourceIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/resources");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if user owns this resource
            if (resource.getUploadedBy() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources");
                return;
            }
            
            // Only allow editing of approved resources or pending/rejected ones before approval
            if (!resource.getStatus().equals("approved") && 
                !resource.getStatus().equals("pending") && 
                !resource.getStatus().equals("rejected")) {
                req.setAttribute("error", "This resource cannot be edited at this time");
                resp.sendRedirect(req.getContextPath() + "/student/resources/" + resourceId);
                return;
            }

            // Get subjects for the user's community
            List<Subject> subjects = subjectDAO.findByCommunityId(user.getCommunityId());
            List<ResourceCategory> categories = categoryDAO.findAll();
            
            // Get all topics for the user's community subjects
            List<Topic> allTopics = topicDAO.findByCommunityId(user.getCommunityId());

            req.setAttribute("resource", resource);
            req.setAttribute("subjects", subjects);
            req.setAttribute("categories", categories);
            req.setAttribute("allTopics", allTopics);

            req.getRequestDispatcher("/WEB-INF/views/student/edit-resource.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/resources");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Get form parameters
            String resourceIdStr = req.getParameter("resourceId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String topicIdStr = req.getParameter("topicId");
            String categoryIdStr = req.getParameter("categoryId");
            String uploadMode = req.getParameter("uploadMode");
            
            if (resourceIdStr == null || resourceIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources");
                return;
            }
            
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> existingResourceOpt = resourceDAO.findById(resourceId);
            
            if (existingResourceOpt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources");
                return;
            }
            
            Resource existingResource = existingResourceOpt.get();
            
            // Check if user owns this resource
            if (existingResource.getUploadedBy() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/student/resources");
                return;
            }
            
            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Title is required");
                doGet(req, resp);
                return;
            }
            
            if (topicIdStr == null || topicIdStr.trim().isEmpty()) {
                req.setAttribute("error", "Topic is required");
                doGet(req, resp);
                return;
            }
            
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                req.setAttribute("error", "Category is required");
                doGet(req, resp);
                return;
            }

            int topicId = Integer.parseInt(topicIdStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // If resource is approved, create a new version for approval
            if (existingResource.getStatus().equals("approved")) {
                String fileUrl;
                String fileType;
                
                if ("link".equals(uploadMode)) {
                    // Handle link upload
                    fileUrl = req.getParameter("link");
                    if (fileUrl == null || fileUrl.trim().isEmpty()) {
                        fileUrl = existingResource.getFileUrl();
                        fileType = existingResource.getFileType();
                    } else {
                        fileType = "link";
                    }
                } else {
                    // Handle file upload
                    Part filePart = req.getPart("file");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = getSubmittedFileName(filePart);
                        fileType = getFileExtension(fileName);
                        
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
                        
                        // Store relative path for database
                        fileUrl = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                    } else {
                        // Keep existing file
                        fileUrl = existingResource.getFileUrl();
                        fileType = existingResource.getFileType();
                    }
                }
                
                // Create new version as pending_edit
                Resource newVersion = new Resource();
                newVersion.setTopicId(topicId);
                newVersion.setUploadedBy(user.getId());
                newVersion.setCategoryId(categoryId);
                newVersion.setTitle(title);
                newVersion.setDescription(description);
                newVersion.setFileUrl(fileUrl);
                newVersion.setFileType(fileType);
                newVersion.setStatus("pending_edit");
                newVersion.setVisibility("private");
                newVersion.setParentResourceId(resourceId);
                newVersion.setVersion(existingResource.getVersion() + 1);
                newVersion.setEditType("edit");
                
                // Save to database
                resourceDAO.create(newVersion);
                
                // Redirect to resources page with success message
                resp.sendRedirect(req.getContextPath() + "/student/resources?edit=pending");
            } else {
                // For pending/rejected resources, just update in place
                existingResource.setTopicId(topicId);
                existingResource.setCategoryId(categoryId);
                existingResource.setTitle(title);
                existingResource.setDescription(description);
                
                // Handle file/link update
                if ("link".equals(uploadMode)) {
                    String link = req.getParameter("link");
                    if (link != null && !link.trim().isEmpty()) {
                        existingResource.setFileUrl(link);
                        existingResource.setFileType("link");
                    }
                } else {
                    Part filePart = req.getPart("file");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = getSubmittedFileName(filePart);
                        String fileType = getFileExtension(fileName);
                        
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
                        
                        // Store relative path for database
                        existingResource.setFileUrl(UPLOAD_DIRECTORY + "/" + uniqueFileName);
                        existingResource.setFileType(fileType);
                    }
                }
                
                // Update in database
                resourceDAO.update(existingResource);
                
                // Redirect to resources page with success message
                resp.sendRedirect(req.getContextPath() + "/student/resources?edit=success");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to update resource: " + e.getMessage());
            doGet(req, resp);
        }
    }
    
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
    
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0 && lastDot < fileName.length() - 1) {
            return fileName.substring(lastDot + 1).toLowerCase();
        }
        return "unknown";
    }
}
