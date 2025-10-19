package com.uninest.controller.moderator;

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
import java.util.Optional;

@WebServlet(name = "topicCreate", urlPatterns = "/moderator/topics/create")
public class TopicCreateServlet extends HttpServlet {
    private final TopicDAO topicDAO = new TopicDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String subjectIdStr = req.getParameter("subjectId");
        if (subjectIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(subjectIdStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            req.setAttribute("subject", subjectOpt.get());
            req.getRequestDispatcher("/WEB-INF/views/moderator/topic-form.jsp").forward(req, resp);
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

        String subjectIdStr = req.getParameter("subjectId");
        if (subjectIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(subjectIdStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            String title = req.getParameter("title");
            String description = req.getParameter("description");

            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Please fill in all required fields");
                req.setAttribute("subject", subjectOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/moderator/topic-form.jsp").forward(req, resp);
                return;
            }

            Topic topic = new Topic();
            topic.setSubjectId(subjectId);
            topic.setTitle(title.trim());
            topic.setDescription(description != null ? description.trim() : null);

            topicDAO.create(topic);
            resp.sendRedirect(req.getContextPath() + "/moderator/topics?subjectId=" + subjectId + "&success=created");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=invalid");
        }
    }
}
