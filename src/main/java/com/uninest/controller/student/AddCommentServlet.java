package com.uninest.controller.student;

import com.uninest.model.PostComment;
import com.uninest.model.User;
import com.uninest.model.dao.PostCommentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AddComment", urlPatterns = "/student/community/comments/add")
public class AddCommentServlet extends HttpServlet {
    private PostCommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        commentDAO = new PostCommentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            int postId = Integer.parseInt(req.getParameter("postId"));
            String content = req.getParameter("content");
            String parentIdStr = req.getParameter("parentId");

            if (content == null || content.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/community/post?id=" + postId + "&error=empty_comment");
                return;
            }

            PostComment comment = new PostComment();
            comment.setPostId(postId);
            comment.setUserId(user.getId());
            comment.setContent(content.trim());

            if (parentIdStr != null && !parentIdStr.isEmpty()) {
                comment.setParentId(Integer.parseInt(parentIdStr));
            }

            commentDAO.create(comment);

            // Redirect back to the post, possibly with a success fragment or message
            resp.sendRedirect(req.getContextPath() + "/student/community/post?id=" + postId + "#comments");

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/community");
        }
    }
}
