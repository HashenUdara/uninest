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
import java.util.Optional;

@WebServlet(name = "subjectEdit", urlPatterns = "/moderator/subjects/edit")
public class SubjectEditServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(idStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            req.setAttribute("subject", subjectOpt.get());
            req.getRequestDispatcher("/WEB-INF/views/moderator/subject-form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(idStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String code = req.getParameter("code");
            String credits = req.getParameter("credits");
            String academicYearStr = req.getParameter("academicYear");
            String semesterStr = req.getParameter("semester");
            String status = req.getParameter("status");

            if (name == null || name.trim().isEmpty() || 
                academicYearStr == null || semesterStr == null || credits == null || credits.trim().isEmpty()) {
                req.setAttribute("error", "Please fill in all required fields");
                req.setAttribute("subject", subjectOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/moderator/subject-form.jsp").forward(req, resp);
                return;
            }

            Subject subject = subjectOpt.get();
            subject.setName(name.trim());
            subject.setDescription(description != null ? description.trim() : null);
            subject.setCode(code != null ? code.trim() : null);
            subject.setCredits(Integer.parseInt(credits));
            subject.setAcademicYear(Integer.parseInt(academicYearStr));
            subject.setSemester(Integer.parseInt(semesterStr));
            subject.setStatus(status != null ? status : "upcoming");

            subjectDAO.update(subject);
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?success=updated");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=invalid");
        }
    }
}
