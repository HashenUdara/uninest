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

@WebServlet(name = "DeleteComment", urlPatterns = "/student/community/comments/delete")
public class DeleteCommentServlet extends HttpServlet {
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
            int commentId = Integer.parseInt(req.getParameter("id"));
            int postId = Integer.parseInt(req.getParameter("postId"));

            PostComment comment = commentDAO.findById(commentId);
            
            if (comment != null && comment.getUserId() == user.getId()) {
                commentDAO.delete(commentId);
            }
            
            resp.sendRedirect(req.getContextPath() + "/student/community/post?id=" + postId);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/community");
        }
    }
}
