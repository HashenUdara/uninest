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

        // Get resource ID from parameter
        String resourceIdStr = req.getParameter("id");
        if (resourceIdStr == null || resourceIdStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Resource ID is required");
            return;
        }

        try {
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> resourceOpt = resourceDAO.findById(resourceId);
            
            if (resourceOpt.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                return;
            }
            
            Resource resource = resourceOpt.get();
            
            // Check if user owns this resource
            if (resource.getUploadedBy() != user.getId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only edit your own resources");
                return;
            }
            
            // Get subjects for the user's community
            List<Subject> subjects = subjectDAO.findByCommunityId(user.getCommunityId());
            List<ResourceCategory> categories = categoryDAO.findAll();
            
            // Get all topics for the user's community subjects
            List<Topic> allTopics = topicDAO.findByCommunityId(user.getCommunityId());
            
            // Get the topic to find the subject ID
            Optional<Topic> topicOpt = topicDAO.findById(resource.getTopicId());
            Integer subjectId = null;
            if (topicOpt.isPresent()) {
                subjectId = topicOpt.get().getSubjectId();
            }

            req.setAttribute("resource", resource);
            req.setAttribute("subjects", subjects);
            req.setAttribute("categories", categories);
            req.setAttribute("allTopics", allTopics);
            req.setAttribute("subjectId", subjectId);

            req.getRequestDispatcher("/WEB-INF/views/student/edit-resource.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource ID");
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
            // Get resource ID
            String resourceIdStr = req.getParameter("resourceId");
            if (resourceIdStr == null || resourceIdStr.isEmpty()) {
                req.setAttribute("error", "Resource ID is required");
                doGet(req, resp);
                return;
            }
            
            int resourceId = Integer.parseInt(resourceIdStr);
            Optional<Resource> existingResourceOpt = resourceDAO.findById(resourceId);
            
            if (existingResourceOpt.isEmpty()) {
                req.setAttribute("error", "Resource not found");
                doGet(req, resp);
                return;
            }
            
            Resource existingResource = existingResourceOpt.get();
            
            // Check if user owns this resource
            if (existingResource.getUploadedBy() != user.getId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only edit your own resources");
                return;
            }
            
            // Get form parameters
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String topicIdStr = req.getParameter("topicId");
            String categoryIdStr = req.getParameter("categoryId");
            String uploadMode = req.getParameter("uploadMode");
            String keepExistingFile = req.getParameter("keepExistingFile");
            
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
            
            String fileUrl = existingResource.getFileUrl();
            String fileType = existingResource.getFileType();
            
            // Check if we need to update the file
            if ("true".equals(keepExistingFile)) {
                // Keep existing file
                fileUrl = existingResource.getFileUrl();
                fileType = existingResource.getFileType();
            } else if ("link".equals(uploadMode)) {
                // Handle link upload
                fileUrl = req.getParameter("link");
                if (fileUrl == null || fileUrl.trim().isEmpty()) {
                    req.setAttribute("error", "Link is required");
                    doGet(req, resp);
                    return;
                }
                fileType = "link";
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
                }
            }
            
            // Update resource object
            Resource resource = new Resource();
            resource.setResourceId(resourceId);
            resource.setTopicId(topicId);
            resource.setUploadedBy(user.getId());
            resource.setCategoryId(categoryId);
            resource.setTitle(title);
            resource.setDescription(description);
            resource.setFileUrl(fileUrl);
            resource.setFileType(fileType);
            
            // Reset status to pending if the resource was approved
            if ("approved".equals(existingResource.getStatus())) {
                resource.setStatus("pending");
                resource.setVisibility("private");
            } else {
                resource.setStatus(existingResource.getStatus());
                resource.setVisibility(existingResource.getVisibility());
            }
            
            // Update in database
            resourceDAO.update(resource);
            
            // Redirect to resources page with success message
            resp.sendRedirect(req.getContextPath() + "/student/resources?edit=success");
            
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
