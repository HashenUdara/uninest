package com.uninest.controller.student;

import com.uninest.model.Quiz;
import com.uninest.model.dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/quizzes")
public class StudentQuizServlet extends HttpServlet {
    private QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String filter = req.getParameter("filter");
        List<Quiz> quizzes;
        
        if ("mine".equals(filter)) {
            com.uninest.model.User user = (com.uninest.model.User) req.getSession().getAttribute("authUser");
            quizzes = quizDAO.findByAuthorId(user.getId());
            req.setAttribute("activeTab", "mine");
        } else {
            quizzes = quizDAO.findAllPublished();
            req.setAttribute("activeTab", "all");
        }
        
        req.setAttribute("quizzes", quizzes);
        req.getRequestDispatcher("/WEB-INF/views/student/quizzes.jsp").forward(req, resp);
    }
}
