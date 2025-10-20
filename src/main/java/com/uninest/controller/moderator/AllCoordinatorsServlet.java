package com.uninest.controller.moderator;

import com.uninest.model.SubjectCoordinator;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "allCoordinators", urlPatterns = "/moderator/coordinators")
public class AllCoordinatorsServlet extends HttpServlet {
    private final SubjectCoordinatorDAO coordinatorDAO = new SubjectCoordinatorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");

        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        List<SubjectCoordinator> coordinators = coordinatorDAO.findByCommunityId(moderator.getCommunityId());

        req.setAttribute("coordinators", coordinators);
        req.getRequestDispatcher("/WEB-INF/views/moderator/all-coordinators.jsp").forward(req, resp);
    }
}
