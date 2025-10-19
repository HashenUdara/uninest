package com.uninest.controller.moderator;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "moderatorStudents", urlPatterns = "/moderator/students")
public class ModeratorStudentsServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        // Moderator must have a community assigned
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        List<User> students = userDAO.findByCommunityId(moderator.getCommunityId());
        req.setAttribute("students", students);
        req.getRequestDispatcher("/WEB-INF/views/moderator/students.jsp").forward(req, resp);
    }
}
