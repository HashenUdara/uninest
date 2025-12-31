package com.uninest.controller.student;

import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "studentSubjects", urlPatterns = "/student/subjects")
public class StudentSubjectsServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User student = (User) req.getSession().getAttribute("authUser");
        
        // Student must have a community assigned
        if (student.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }

        String view = req.getParameter("view");
        List<Subject> subjects = subjectDAO.findByCommunityId(student.getCommunityId());
        req.setAttribute("subjects", subjects);
        
        // Default to grid view
        if ("list".equals(view)) {
            req.getRequestDispatcher("/WEB-INF/views/student/subjects-list.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/student/subjects-grid.jsp").forward(req, resp);
        }
    }
}
