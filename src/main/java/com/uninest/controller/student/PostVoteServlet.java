package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Handles AJAX requests for voting on posts.
 */
@WebServlet(name = "PostVoteServlet", urlPatterns = "/student/community/vote")
public class PostVoteServlet extends HttpServlet {

    private final CommunityPostDAO postDAO = new CommunityPostDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        // 1. Auth check
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Unauthorized\", \"success\": false}");
            return;
        }

        try {
            // 2. Parse parameters
            String postIdParam = req.getParameter("postId");
            String typeParam = req.getParameter("type");
            
            if (postIdParam == null || typeParam == null) {
                 throw new IllegalArgumentException("Missing parameters");
            }

            int postId = Integer.parseInt(postIdParam);
            int type = Integer.parseInt(typeParam); // 1 or -1

            if (type != 1 && type != -1) {
                throw new IllegalArgumentException("Invalid vote type");
            }

            // 3. Process vote
            int newUserVote = postDAO.vote(user.getId(), postId, type);

            // 4. Send success response
            out.print("{\"success\": true, \"userVote\": " + newUserVote + "}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            // Simple escaping for error message
            String errorMsg = e.getMessage().replace("\"", "'");
            out.print("{\"error\": \"" + errorMsg + "\", \"success\": false}");
        }
    }
}
