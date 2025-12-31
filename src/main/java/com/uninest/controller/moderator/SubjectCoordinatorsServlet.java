package com.uninest.controller.moderator;

import com.uninest.model.Subject;
import com.uninest.model.SubjectCoordinator;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "subjectCoordinators", urlPatterns = "/moderator/subject-coordinators")
public class SubjectCoordinatorsServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String subjectIdParam = req.getParameter("subjectId");
        if (subjectIdParam == null || subjectIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        int subjectId = Integer.parseInt(subjectIdParam);
        
        // Verify subject belongs to moderator's community
        Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
        if (!subjectOpt.isPresent() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        Subject subject = subjectOpt.get();
        List<SubjectCoordinator> coordinators = coordinatorDAO.findBySubjectId(subjectId);

        req.setAttribute("subject", subject);
        req.setAttribute("coordinators", coordinators);
        req.getRequestDispatcher("/WEB-INF/views/moderator/subject-coordinators.jsp").forward(req, resp);
    }
}
