package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet(name = "studentProfileSettings", urlPatterns = "/student/profile-settings")
public class StudentSettingsServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Just forward to the JSP. The JSP will read 'authUser' from the session scope.
        req.getRequestDispatcher("/WEB-INF/views/student/profile-settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");

        // Update fields
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String yearStr = req.getParameter("academicYear");
        String phone = req.getParameter("phone");
        
        // We generally shouldn't let students change their email or university ID without verification,
        // but for this task, the request is about filling values. We'll allow name/year updates.
        
        if (firstName != null && !firstName.isBlank()) {
            user.setFirstName(firstName.trim());
        }
        
        if (lastName != null && !lastName.isBlank()) {
            user.setLastName(lastName.trim());
        }

        if (phone != null) {
            String trimmedPhone = phone.trim();
            if (trimmedPhone.length() > 10) {
                 resp.sendRedirect(req.getContextPath() + "/student/profile-settings?error=Phone number too long");
                 return;
            }
            user.setPhoneNumber(trimmedPhone);
        }

        if (yearStr != null && !yearStr.isBlank()) {
            try {
                int year = Integer.parseInt(yearStr);
                user.setAcademicYear(year);
            } catch (NumberFormatException e) {
                // Ignore invalid year
            }
        }

        // Handle Profile Image Upload
        try {
            jakarta.servlet.http.Part filePart = req.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                 // Save to DB as BLOB
                 try (java.io.InputStream inputStream = filePart.getInputStream()) {
                     userDAO.updateProfileImage(user.getId(), inputStream);
                 }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/profile-settings?error=Image Upload Failed: " + e.getMessage());
            return;
        }

        // Save other fields to DB
        userDAO.update(user);
        
        // Update session - re-fetch to ensure consistency if needed, 
        // but for profile pic, the URL generation is dynamic now.
        // We might want to reload the user from DB to be safe, or just update the current object fields.
        session.setAttribute("authUser", user);

        // Redirect with success
        resp.sendRedirect(req.getContextPath() + "/student/profile-settings?success=true");
    }
}
