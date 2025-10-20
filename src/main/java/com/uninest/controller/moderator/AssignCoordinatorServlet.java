package com.uninest.controller.moderator;

import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import com.uninest.model.dao.SubjectDAO;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet(name = "assignCoordinator", urlPatterns = "/moderator/subject-coordinators/assign")
public class AssignCoordinatorServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

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
        
        // Get all students in the community
        List<User> students = userDAO.findByCommunityId(moderator.getCommunityId());
        
        // Filter out students who are already coordinators for ANY subject
        List<User> availableStudents = students.stream()
            .filter(student -> !coordinatorDAO.isCoordinator(student.getId()))
            .collect(Collectors.toList());

        // Get returnTo parameter (defaults to subject-specific view)
        String returnTo = req.getParameter("returnTo");

        req.setAttribute("subject", subject);
        req.setAttribute("students", availableStudents);
        req.setAttribute("returnTo", returnTo);
        req.getRequestDispatcher("/WEB-INF/views/moderator/assign-coordinator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String subjectIdParam = req.getParameter("subjectId");
        String[] selectedStudentIds = req.getParameterValues("studentIds");
        String returnTo = req.getParameter("returnTo");

        if (subjectIdParam == null || selectedStudentIds == null || selectedStudentIds.length == 0) {
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

        // Assign each selected student as coordinator
        for (String studentIdStr : selectedStudentIds) {
            int studentId = Integer.parseInt(studentIdStr);
            // Only assign if not already a coordinator
            if (!coordinatorDAO.isCoordinator(studentId)) {
                coordinatorDAO.assign(studentId, subjectId);
            }
        }

        // Redirect based on returnTo parameter
        if ("all".equals(returnTo)) {
            resp.sendRedirect(req.getContextPath() + "/moderator/coordinators?success=assigned");
        } else {
            resp.sendRedirect(req.getContextPath() + "/moderator/subject-coordinators?subjectId=" + subjectId + "&success=assigned");
        }
    }
}
