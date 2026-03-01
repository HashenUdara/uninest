package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.PollDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "pollVote", urlPatterns = "/student/community/polls/vote")
public class PollVoteServlet extends HttpServlet {

    private final PollDAO pollDAO = new PollDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            int pollId = Integer.parseInt(req.getParameter("pollId"));
            String action = req.getParameter("action"); // "vote" or "undo"
            String returnUrl = req.getParameter("returnUrl");
            if (returnUrl == null || returnUrl.isEmpty()) {
                returnUrl = req.getContextPath() + "/student/community";
            }

            // Handle vote removal
            if ("undo".equals(action)) {
                boolean removed = pollDAO.removeVote(pollId, user.getId());
                if (removed) {
                    resp.sendRedirect(returnUrl + "?vote=removed");
                } else {
                    resp.sendRedirect(returnUrl + "?error=no_vote_found");
                }
                return;
            }

            // Handle normal voting
            String[] optionIds = req.getParameterValues("optionId");
            if (optionIds != null && optionIds.length > 0) {
                List<Integer> selectedOptions = new ArrayList<>();
                for (String optId : optionIds) {
                    selectedOptions.add(Integer.parseInt(optId));
                }

                pollDAO.vote(pollId, user.getId(), selectedOptions);
            }

            resp.sendRedirect(returnUrl);

        } catch (Exception e) {
            e.printStackTrace();
            // In a real app, handle error nicer
            resp.sendRedirect(req.getContextPath() + "/student/community?error=vote_failed");
        }
    }
}
