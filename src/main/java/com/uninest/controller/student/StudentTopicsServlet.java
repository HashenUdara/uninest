package com.uninest.controller.student;

import com.uninest.model.Subject;
import com.uninest.model.Topic;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectDAO;
import com.uninest.model.dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "studentTopics", urlPatterns = "/student/topics")
public class StudentTopicsServlet extends HttpServlet {
    private final TopicDAO topicDAO = new TopicDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User student = (User) req.getSession().getAttribute("authUser");
        
        if (student.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/join-community");
            return;
        }

        String subjectIdStr = req.getParameter("subjectId");
        if (subjectIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(subjectIdStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != student.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/student/subjects?error=notfound");
                return;
            }

            Subject subject = subjectOpt.get();
            List<Topic> topics = topicDAO.findBySubjectIdWithProgress(subjectId, student.getId());
            
            req.setAttribute("subject", subject);
            req.setAttribute("topics", topics);

            String view = req.getParameter("view");
            if ("list".equals(view)) {
                req.getRequestDispatcher("/WEB-INF/views/student/topics-list.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/WEB-INF/views/student/topics-grid.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/subjects");
        }
    }
}
