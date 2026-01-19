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
            user.setPhoneNumber(phone.trim());
        }

        if (yearStr != null && !yearStr.isBlank()) {
            try {
                int year = Integer.parseInt(yearStr);
                user.setAcademicYear(year);
            } catch (NumberFormatException e) {
                // Ignore invalid year
            }
        }

        // Save to DB
        userDAO.update(user);
        
        // Update session
        session.setAttribute("authUser", user);

        // Redirect with success
        resp.sendRedirect(req.getContextPath() + "/student/profile-settings?success=true");
    }
}
