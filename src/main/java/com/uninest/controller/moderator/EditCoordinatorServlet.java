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

@WebServlet(name = "editCoordinator", urlPatterns = "/moderator/subject-coordinators/edit")
public class EditCoordinatorServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String coordinatorIdParam = req.getParameter("coordinatorId");
        if (coordinatorIdParam == null || coordinatorIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        int coordinatorId = Integer.parseInt(coordinatorIdParam);

        // Get the coordinator details
        Optional<SubjectCoordinator> coordinatorOpt = coordinatorDAO.findById(coordinatorId);
        if (!coordinatorOpt.isPresent()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        SubjectCoordinator coordinator = coordinatorOpt.get();
        
        // Verify the coordinator's subject belongs to moderator's community
        Optional<Subject> currentSubjectOpt = subjectDAO.findById(coordinator.getSubjectId());
        if (!currentSubjectOpt.isPresent() || currentSubjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        // Get all subjects in the community
        List<Subject> subjects = subjectDAO.findByCommunityId(moderator.getCommunityId());

        // Get returnTo parameter
        String returnTo = req.getParameter("returnTo");

        req.setAttribute("coordinator", coordinator);
        req.setAttribute("subjects", subjects);
        req.setAttribute("returnTo", returnTo);
        req.getRequestDispatcher("/WEB-INF/views/moderator/edit-coordinator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String coordinatorIdParam = req.getParameter("coordinatorId");
        String newSubjectIdParam = req.getParameter("subjectId");
        String returnTo = req.getParameter("returnTo");

        if (coordinatorIdParam == null || newSubjectIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        int coordinatorId = Integer.parseInt(coordinatorIdParam);
        int newSubjectId = Integer.parseInt(newSubjectIdParam);

        // Get the coordinator details
        Optional<SubjectCoordinator> coordinatorOpt = coordinatorDAO.findById(coordinatorId);
        if (!coordinatorOpt.isPresent()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        SubjectCoordinator coordinator = coordinatorOpt.get();
        
        // Verify the new subject belongs to moderator's community
        Optional<Subject> newSubjectOpt = subjectDAO.findById(newSubjectId);
        if (!newSubjectOpt.isPresent() || newSubjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators");
            return;
        }

        // Update the coordinator's subject
        coordinatorDAO.updateSubject(coordinatorId, newSubjectId);

        // Redirect based on returnTo parameter
        if ("all".equals(returnTo)) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators?success=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/moderator/subject-coordinators?subjectId=" + newSubjectId + "&success=updated");
        }
    }
}
