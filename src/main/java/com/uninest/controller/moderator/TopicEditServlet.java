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

@WebServlet(name = "topicEdit", urlPatterns = "/moderator/topics/edit")
public class TopicEditServlet extends HttpServlet {
    private final TopicDAO topicDAO = new TopicDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String idStr = req.getParameter("id");
        String subjectIdStr = req.getParameter("subjectId");
        
        if (idStr == null || subjectIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int topicId = Integer.parseInt(idStr);
            int subjectId = Integer.parseInt(subjectIdStr);
            
            Optional<Topic> topicOpt = topicDAO.findById(topicId);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (topicOpt.isEmpty() || subjectOpt.isEmpty() || 
                topicOpt.get().getSubjectId() != subjectId ||
                subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            req.setAttribute("topic", topicOpt.get());
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

        String idStr = req.getParameter("id");
        String subjectIdStr = req.getParameter("subjectId");
        
        if (idStr == null || subjectIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int topicId = Integer.parseInt(idStr);
            int subjectId = Integer.parseInt(subjectIdStr);
            
            Optional<Topic> topicOpt = topicDAO.findById(topicId);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (topicOpt.isEmpty() || subjectOpt.isEmpty() || 
                topicOpt.get().getSubjectId() != subjectId ||
                subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            String title = req.getParameter("title");
            String description = req.getParameter("description");

            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Please fill in all required fields");
                req.setAttribute("topic", topicOpt.get());
                req.setAttribute("subject", subjectOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/moderator/topic-form.jsp").forward(req, resp);
                return;
            }

            Topic topic = topicOpt.get();
            topic.setTitle(title.trim());
            topic.setDescription(description != null ? description.trim() : null);

            topicDAO.update(topic);
            resp.sendRedirect(req.getContextPath() + "/moderator/topics?subjectId=" + subjectId + "&success=updated");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=invalid");
        }
    }
}
