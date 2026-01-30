package com.uninest.model.dao;

import com.uninest.model.Quiz;
import com.uninest.model.QuizQuestion;
import com.uninest.model.QuizOption;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class QuizDAO {

    public List<Quiz> findAllPublished() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, u.first_name, u.last_name, s.name as subject_name " +
                     "FROM quizzes q " +
                     "JOIN users u ON q.author_id = u.id " +
                     "LEFT JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE q.is_published = TRUE " +
                     "ORDER BY q.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                quizzes.add(mapQuiz(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching quizzes", e);
        }
        return quizzes;
    }

    public List<Quiz> findByAuthorId(int authorId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, u.first_name, u.last_name, s.name as subject_name " +
                     "FROM quizzes q " +
                     "JOIN users u ON q.author_id = u.id " +
                     "LEFT JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE q.author_id = ? " +
                     "ORDER BY q.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, authorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    quizzes.add(mapQuiz(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching your quizzes", e);
        }
        return quizzes;
    }

    public Optional<Quiz> findById(int id) {
        String sql = "SELECT q.*, u.first_name, u.last_name, s.name as subject_name " +
                     "FROM quizzes q " +
                     "JOIN users u ON q.author_id = u.id " +
                     "LEFT JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE q.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Quiz quiz = mapQuiz(rs);
                    quiz.setQuestions(findQuestionsByQuizId(id, conn));
                    return Optional.of(quiz);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching quiz details", e);
        }
        return Optional.empty();
    }

    private List<QuizQuestion> findQuestionsByQuizId(int quizId, Connection conn) throws SQLException {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_questions WHERE quiz_id = ? ORDER BY order_num";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = new QuizQuestion();
                    q.setId(rs.getInt("id"));
                    q.setQuizId(rs.getInt("quiz_id"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setPoints(rs.getInt("points"));
                    q.setOrderNum(rs.getInt("order_num"));
                    q.setOptions(findOptionsByQuestionId(q.getId(), conn));
                    questions.add(q);
                }
            }
        }
        return questions;
    }

    private List<QuizOption> findOptionsByQuestionId(int questionId, Connection conn) throws SQLException {
        List<QuizOption> options = new ArrayList<>();
        String sql = "SELECT * FROM quiz_options WHERE question_id = ? ORDER BY order_num";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizOption opt = new QuizOption();
                    opt.setId(rs.getInt("id"));
                    opt.setQuestionId(rs.getInt("question_id"));
                    opt.setOptionText(rs.getString("option_text"));
                    opt.setCorrect(rs.getBoolean("is_correct"));
                    opt.setOrderNum(rs.getInt("order_num"));
                    options.add(opt);
                }
            }
        }
        return options;
    }

    public int saveQuiz(Quiz quiz) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Insert Quiz
            String quizSql = "INSERT INTO quizzes (author_id, subject_id, title, description, duration, is_published) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement quizStmt = conn.prepareStatement(quizSql, Statement.RETURN_GENERATED_KEYS);
            quizStmt.setInt(1, quiz.getAuthorId());
            if (quiz.getSubjectId() != null) quizStmt.setInt(2, quiz.getSubjectId());
            else quizStmt.setNull(2, Types.INTEGER);
            quizStmt.setString(3, quiz.getTitle());
            quizStmt.setString(4, quiz.getDescription());
            quizStmt.setInt(5, quiz.getDuration());
            quizStmt.setBoolean(6, quiz.isPublished());
            quizStmt.executeUpdate();
            
            ResultSet rs = quizStmt.getGeneratedKeys();
            if (!rs.next()) throw new SQLException("Failed to get quiz ID");
            int quizId = rs.getInt(1);
            quiz.setId(quizId);
            
            // 2. Insert Questions
            String qSql = "INSERT INTO quiz_questions (quiz_id, question_text, points, order_num) VALUES (?, ?, ?, ?)";
            PreparedStatement qStmt = conn.prepareStatement(qSql, Statement.RETURN_GENERATED_KEYS);
            
            String optSql = "INSERT INTO quiz_options (question_id, option_text, is_correct, order_num) VALUES (?, ?, ?, ?)";
            PreparedStatement optStmt = conn.prepareStatement(optSql);
            
            for (int i = 0; i < quiz.getQuestions().size(); i++) {
                QuizQuestion q = quiz.getQuestions().get(i);
                qStmt.setInt(1, quizId);
                qStmt.setString(2, q.getQuestionText());
                qStmt.setInt(3, q.getPoints());
                qStmt.setInt(4, i + 1);
                qStmt.executeUpdate();
                
                ResultSet qKeys = qStmt.getGeneratedKeys();
                if (!qKeys.next()) throw new SQLException("Failed to get question ID");
                int qId = qKeys.getInt(1);
                
                // 3. Insert Options
                for (int j = 0; j < q.getOptions().size(); j++) {
                    QuizOption opt = q.getOptions().get(j);
                    optStmt.setInt(1, qId);
                    optStmt.setString(2, opt.getOptionText());
                    optStmt.setBoolean(3, opt.isCorrect());
                    optStmt.setInt(4, j + 1);
                    optStmt.executeUpdate();
                }
            }
            
            conn.commit();
            return quizId;
            
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw new RuntimeException("Error saving quiz", e);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean deleteQuiz(int quizId, int authorId) {
        String sql = "DELETE FROM quizzes WHERE id = ? AND author_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            stmt.setInt(2, authorId);
            return stmt.executeUpdate() > 0;
            // Note: Since we have ON DELETE CASCADE in the migration, 
            // the questions and options will be deleted automatically.
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting quiz", e);
        }
    }

    private Quiz mapQuiz(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(rs.getInt("id"));
        quiz.setAuthorId(rs.getInt("author_id"));
        int subjectId = rs.getInt("subject_id");
        if (!rs.wasNull()) quiz.setSubjectId(subjectId);
        quiz.setTitle(rs.getString("title"));
        quiz.setDescription(rs.getString("description"));
        quiz.setDuration(rs.getInt("duration"));
        quiz.setPublished(rs.getBoolean("is_published"));
        quiz.setCreatedAt(rs.getTimestamp("created_at"));
        quiz.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Metadata
        quiz.setAuthorName(rs.getString("first_name") + " " + rs.getString("last_name"));
        quiz.setSubjectName(rs.getString("subject_name"));
        
        return quiz;
    }
}
