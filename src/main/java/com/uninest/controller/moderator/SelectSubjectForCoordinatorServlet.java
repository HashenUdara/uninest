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

@WebServlet(name = "selectSubjectForCoordinator", urlPatterns = "/moderator/coordinators/select-subject")
public class SelectSubjectForCoordinatorServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        List<Subject> subjects = subjectDAO.findByCommunityId(moderator.getCommunityId());

        // Track the return URL (defaults to all-coordinators page)
        String returnTo = req.getParameter("returnTo");
        if (returnTo == null || returnTo.isEmpty()) {
            returnTo = "all";
        }

        req.setAttribute("subjects", subjects);
        req.setAttribute("returnTo", returnTo);
        req.getRequestDispatcher("/WEB-INF/views/moderator/select-subject-for-coordinator.jsp").forward(req, resp);
    }
}
