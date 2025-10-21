package com.uninest.model.dao;

import com.uninest.model.Topic;
import com.uninest.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class TopicDAO {

    private Topic map(ResultSet rs) throws SQLException {
        Topic topic = new Topic();
        topic.setTopicId(rs.getInt("topic_id"));
        topic.setSubjectId(rs.getInt("subject_id"));
        topic.setTitle(rs.getString("title"));
        topic.setDescription(rs.getString("description"));
        topic.setCreatedAt(rs.getTimestamp("created_at"));
        return topic;
    }

    private Topic mapWithProgress(ResultSet rs) throws SQLException {
        Topic topic = map(rs);
        BigDecimal progress = rs.getBigDecimal("progress_percent");
        topic.setProgressPercent(progress != null ? progress : BigDecimal.ZERO);
        return topic;
    }

    public Optional<Topic> findById(int topicId) {
        String sql = "SELECT * FROM topics WHERE topic_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching topic", e);
        }
        return Optional.empty();
    }

    public List<Topic> findBySubjectId(int subjectId) {
        String sql = "SELECT * FROM topics WHERE subject_id = ? ORDER BY created_at DESC";
        List<Topic> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error listing topics", e);
        }
        return list;
    }

    public List<Topic> findByCommunityId(int communityId) {
        String sql = "SELECT t.* FROM topics t " +
                     "INNER JOIN subjects s ON t.subject_id = s.subject_id " +
                     "WHERE s.community_id = ? " +
                     "ORDER BY s.subject_id, t.created_at DESC";
        List<Topic> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error listing topics by community", e);
        }
        return list;
    }

    public List<Topic> findBySubjectIdWithProgress(int subjectId, int userId) {
        String sql = "SELECT t.*, COALESCE(tp.progress_percent, 0.00) as progress_percent " +
                     "FROM topics t " +
                     "LEFT JOIN topic_progress tp ON t.topic_id = tp.topic_id AND tp.user_id = ? " +
                     "WHERE t.subject_id = ? " +
                     "ORDER BY t.created_at DESC";
        List<Topic> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapWithProgress(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error listing topics with progress", e);
        }
        return list;
    }

    public int create(Topic topic) {
        String sql = "INSERT INTO topics(subject_id, title, description) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, topic.getSubjectId());
            ps.setString(2, topic.getTitle());
            ps.setString(3, topic.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    topic.setTopicId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating topic", e);
        }
        return 0;
    }

    public boolean update(Topic topic) {
        String sql = "UPDATE topics SET title = ?, description = ? WHERE topic_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, topic.getTitle());
            ps.setString(2, topic.getDescription());
            ps.setInt(3, topic.getTopicId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating topic", e);
        }
    }

    public boolean delete(int topicId) {
        String sql = "DELETE FROM topics WHERE topic_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting topic", e);
        }
    }
}
