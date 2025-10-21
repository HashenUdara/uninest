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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "uploadResource", urlPatterns = "/student/resources/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 60    // 60MB
)
public class UploadResourceServlet extends HttpServlet {
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

        // Get subjects for the user's community
        List<Subject> subjects = subjectDAO.findByCommunityId(user.getCommunityId());
        List<ResourceCategory> categories = categoryDAO.findAll();
        
        // Get all topics for the user's community subjects
        List<Topic> allTopics = topicDAO.findByCommunityId(user.getCommunityId());

        req.setAttribute("subjects", subjects);
        req.setAttribute("categories", categories);
        req.setAttribute("allTopics", allTopics);

        req.getRequestDispatcher("/WEB-INF/views/student/upload-resource.jsp").forward(req, resp);
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
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String topicIdStr = req.getParameter("topicId");
            String categoryIdStr = req.getParameter("categoryId");
            String uploadMode = req.getParameter("uploadMode");
            
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
            
            String fileUrl;
            String fileType;
            
            if ("link".equals(uploadMode)) {
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
                if (filePart == null || filePart.getSize() == 0) {
                    req.setAttribute("error", "File is required");
                    doGet(req, resp);
                    return;
                }
                
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
            
            // Create resource object
            Resource resource = new Resource();
            resource.setTopicId(topicId);
            resource.setUploadedBy(user.getId());
            resource.setCategoryId(categoryId);
            resource.setTitle(title);
            resource.setDescription(description);
            resource.setFileUrl(fileUrl);
            resource.setFileType(fileType);
            resource.setStatus("pending");
            resource.setVisibility("private");
            
            // Save to database
            resourceDAO.create(resource);
            
            // Redirect to resources page with success message
            resp.sendRedirect(req.getContextPath() + "/student/resources?upload=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to upload resource: " + e.getMessage());
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
