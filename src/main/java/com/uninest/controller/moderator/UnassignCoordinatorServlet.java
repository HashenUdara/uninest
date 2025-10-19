package com.uninest.controller.moderator;

import com.uninest.model.User;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "unassignCoordinator", urlPatterns = "/moderator/subject-coordinators/unassign")
public class UnassignCoordinatorServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String coordinatorIdParam = req.getParameter("coordinatorId");
        String subjectIdParam = req.getParameter("subjectId");

        if (coordinatorIdParam == null || subjectIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        int coordinatorId = Integer.parseInt(coordinatorIdParam);
        int subjectId = Integer.parseInt(subjectIdParam);

        coordinatorDAO.unassign(coordinatorId);

        resp.sendRedirect(req.getContextPath() + "/moderator/subject-coordinators?subjectId=" + subjectId + "&success=unassigned");
    }
}
