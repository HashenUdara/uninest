package com.uninest.controller.moderator;

import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "subjectCreate", urlPatterns = "/moderator/subjects/create")
public class SubjectCreateServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/moderator/subject-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String code = req.getParameter("code");
        String academicYearStr = req.getParameter("academicYear");
        String semesterStr = req.getParameter("semester");
        String status = req.getParameter("status");

        if (name == null || name.trim().isEmpty() || 
            academicYearStr == null || semesterStr == null) {
            req.setAttribute("error", "Please fill in all required fields");
            req.getRequestDispatcher("/WEB-INF/views/moderator/subject-form.jsp").forward(req, resp);
            return;
        }

        try {
            Subject subject = new Subject();
            subject.setCommunityId(moderator.getCommunityId());
            subject.setName(name.trim());
            subject.setDescription(description != null ? description.trim() : null);
            subject.setCode(code != null ? code.trim() : null);
            subject.setAcademicYear(Integer.parseInt(academicYearStr));
            subject.setSemester(Integer.parseInt(semesterStr));
            subject.setStatus(status != null ? status : "upcoming");

            subjectDAO.create(subject);
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?success=created");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid academic year or semester");
            req.getRequestDispatcher("/WEB-INF/views/moderator/subject-form.jsp").forward(req, resp);
        }
    }
}
