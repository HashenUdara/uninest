package com.uninest.controller.moderator;

import com.uninest.model.Community;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "communityCreate", urlPatterns = "/moderator/community/create")
public class CommunityCreateServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/moderator/community-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        String title = req.getParameter("title");
        String description = req.getParameter("description");

        if (title == null || title.trim().isEmpty()) {
            req.setAttribute("error", "Title is required");
            req.getRequestDispatcher("/WEB-INF/views/moderator/community-create.jsp").forward(req, resp);
            return;
        }

        Community comm = new Community();
        comm.setTitle(title.trim());
        comm.setDescription(description == null ? null : description.trim());
        comm.setCreatedByUserId(user.getId());
        communityDAO.create(comm);

        resp.sendRedirect(req.getContextPath() + "/moderator/community/waiting");
    }
}
