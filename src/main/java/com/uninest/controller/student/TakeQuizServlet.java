package com.uninest.controller.student;

import com.uninest.model.Quiz;
import com.uninest.model.dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/student/quizzes/take")
public class TakeQuizServlet extends HttpServlet {
    private QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/quizzes");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Optional<Quiz> quizOpt = quizDAO.findById(id);
            if (quizOpt.isPresent()) {
                req.setAttribute("quiz", quizOpt.get());
                req.getRequestDispatcher("/WEB-INF/views/student/take-quiz.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/quizzes?error=not_found");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/student/quizzes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Simple scoring logic for now (Read-only for details, but we can do a quick score)
        String idStr = req.getParameter("quizId");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/quizzes");
            return;
        }

        try {
            int quizId = Integer.parseInt(idStr);
            Optional<Quiz> quizOpt = quizDAO.findById(quizId);
            if (quizOpt.isPresent()) {
                Quiz quiz = quizOpt.get();
                int score = 0;
                int totalPoints = 0;

                for (int i = 0; i < quiz.getQuestions().size(); i++) {
                    com.uninest.model.QuizQuestion q = quiz.getQuestions().get(i);
                    totalPoints += q.getPoints();
                    String answer = req.getParameter("q" + q.getId());
                    
                    // In a real app, we'd compare the answer text or ID
                    // For now, let's assume the parameter value is the option ID
                    if (answer != null) {
                        int selectedOptId = Integer.parseInt(answer);
                        if (q.getOptions().stream().anyMatch(o -> o.getId() == selectedOptId && o.isCorrect())) {
                            score += q.getPoints();
                        }
                    }
                }

                req.setAttribute("score", score);
                req.setAttribute("totalPoints", totalPoints);
                req.setAttribute("quiz", quiz);
                req.getRequestDispatcher("/WEB-INF/views/student/quiz-result.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/student/quizzes");
        }
    }
}
