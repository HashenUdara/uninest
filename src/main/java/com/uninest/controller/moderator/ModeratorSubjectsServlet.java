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
import java.util.List;

@WebServlet(name = "moderatorSubjects", urlPatterns = "/moderator/subjects")
public class ModeratorSubjectsServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String view = req.getParameter("view");
        List<Subject> subjects = subjectDAO.findByCommunityId(moderator.getCommunityId());
        req.setAttribute("subjects", subjects);
        
        // Default to grid view
        if ("list".equals(view)) {
            req.getRequestDispatcher("/WEB-INF/views/moderator/subjects-list.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/moderator/subjects-grid.jsp").forward(req, resp);
        }
    }
}
