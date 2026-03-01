package com.uninest.controller.moderator;

import com.uninest.model.CommunityPost;
import com.uninest.model.PostComment;
import com.uninest.model.User;
import com.uninest.model.dao.CommunityPostDAO;
import com.uninest.model.dao.PostCommentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ModeratorPostDetail", urlPatterns = "/moderator/community/post")
public class ModeratorPostDetailServlet extends HttpServlet {
    private CommunityPostDAO postDAO;
    private PostCommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new CommunityPostDAO();
        commentDAO = new PostCommentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("authUser");
        
        // 1. Auth Check
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // 2. Role Check (Moderator Only)
        if (!"moderator".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community");
            return;
        }

        try {
            int postId = Integer.parseInt(idStr);
            Optional<CommunityPost> postOpt = postDAO.findByIdWithAuthor(postId);

            if (postOpt.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Post not found");
                return;
            }

            CommunityPost post = postOpt.get();
            // TODO: Optional - Check if post belongs to moderator's community if strict isolation is needed.
            
            List<PostComment> comments = commentDAO.findByPostId(postId);

            req.setAttribute("post", post);
            req.setAttribute("comments", comments);
            req.getRequestDispatcher("/WEB-INF/views/moderator/community/post-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/community");
        }
    }
}
