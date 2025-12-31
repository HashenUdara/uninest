package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "adminModerators", urlPatterns = "/admin/moderators")
public class ModeratorsServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String searchTerm = req.getParameter("search");
        List<User> moderators;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            moderators = userDAO.searchUsers("moderator", searchTerm.trim());
            req.setAttribute("searchTerm", searchTerm);
        } else {
            moderators = userDAO.findByRole("moderator");
        }
        
        req.setAttribute("moderators", moderators);
        req.getRequestDispatcher("/WEB-INF/views/admin/moderators.jsp").forward(req, resp);
    }
}
