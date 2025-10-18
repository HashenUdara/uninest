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
import java.util.Optional;

@WebServlet(name = "communityWaiting", urlPatterns = "/moderator/community/waiting")
public class CommunityWaitingServlet extends HttpServlet {
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        Optional<Community> commOpt = communityDAO.findByCreatorUserId(user.getId());
        commOpt.ifPresent(comm -> req.setAttribute("community", comm));
        req.getRequestDispatcher("/WEB-INF/views/moderator/community-waiting.jsp").forward(req, resp);
    }
}
