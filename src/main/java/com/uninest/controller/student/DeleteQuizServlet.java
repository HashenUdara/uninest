package com.uninest.controller.student;

import com.uninest.model.User;
import com.uninest.model.dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/quizzes/delete")
public class DeleteQuizServlet extends HttpServlet {
    private QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        String idStr = req.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                quizDAO.deleteQuiz(id, user.getId());
                resp.sendRedirect(req.getContextPath() + "/student/quizzes?success=delete");
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/student/quizzes?error=delete_failed");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/quizzes");
        }
    }
}
