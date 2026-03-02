package com.uninest.controller.student;

import com.uninest.model.*;
import com.uninest.model.dao.QuizDAO;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/student/quizzes/create")
public class CreateQuizServlet extends HttpServlet {
    private QuizDAO quizDAO = new QuizDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        Integer communityId = user.getCommunityId();
        List<Subject> subjects = (communityId != null) ? subjectDAO.findByCommunityId(communityId) : new ArrayList<>();
        req.setAttribute("subjects", subjects);
        req.getRequestDispatcher("/WEB-INF/views/student/create-quiz.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        
        try {
            Quiz quiz = new Quiz();
            quiz.setAuthorId(user.getId());
            quiz.setTitle(req.getParameter("title"));
            quiz.setDescription(req.getParameter("description"));
            String subjectIdStr = req.getParameter("subjectId");
            if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
                quiz.setSubjectId(Integer.parseInt(subjectIdStr));
            }
            String durationStr = req.getParameter("duration");
            quiz.setDuration(durationStr != null && !durationStr.isEmpty() ? Integer.parseInt(durationStr) : 30);
            quiz.setPublished(true); // Default to published for now

            // Parse questions from parameters (assuming a naming convention like q1_text, q1_points, q1_opt1_text, etc.)
            // For a production app, this would be better handled with JSON or a more robust form parser
            // Given the time, I'll implement a simple numbered loop based on how many questions the user sent
            
            List<QuizQuestion> questions = new ArrayList<>();
            int qIdx = 1;
            while (req.getParameter("q" + qIdx + "_text") != null) {
                QuizQuestion q = new QuizQuestion();
                q.setQuestionText(req.getParameter("q" + qIdx + "_text"));
                String pointsStr = req.getParameter("q" + qIdx + "_points");
                q.setPoints(pointsStr != null ? Integer.parseInt(pointsStr) : 1);
                
                List<QuizOption> options = new ArrayList<>();
                int oIdx = 1;
                String correctOptValue = req.getParameter("q" + qIdx + "_correct");
                while (req.getParameter("q" + qIdx + "_opt" + oIdx + "_text") != null) {
                    QuizOption opt = new QuizOption();
                    opt.setOptionText(req.getParameter("q" + qIdx + "_opt" + oIdx + "_text"));
                    // Correct answer logic: check if the radio group value matches "optN"
                    opt.setCorrect(("opt" + oIdx).equals(correctOptValue));
                    options.add(opt);
                    oIdx++;
                }
                q.setOptions(options);
                questions.add(q);
                qIdx++;
            }
            quiz.setQuestions(questions);
            
            quizDAO.saveQuiz(quiz);
            resp.sendRedirect(req.getContextPath() + "/student/quizzes?success=create");
            
        } catch (Exception e) {
            req.setAttribute("error", "Error creating quiz: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
