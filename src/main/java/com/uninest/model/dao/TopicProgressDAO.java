package com.uninest.model.dao;

import com.uninest.model.TopicProgress;
import com.uninest.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.Optional;

public class TopicProgressDAO {

    private TopicProgress map(ResultSet rs) throws SQLException {
        TopicProgress progress = new TopicProgress();
        progress.setProgressId(rs.getInt("progress_id"));
        progress.setTopicId(rs.getInt("topic_id"));
        progress.setUserId(rs.getInt("user_id"));
        progress.setProgressPercent(rs.getBigDecimal("progress_percent"));
        progress.setLastAccessed(rs.getTimestamp("last_accessed"));
        return progress;
    }

    public Optional<TopicProgress> findByUserAndTopic(int userId, int topicId) {
        String sql = "SELECT * FROM topic_progress WHERE user_id = ? AND topic_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, topicId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching topic progress", e);
        }
        return Optional.empty();
    }

    public int create(TopicProgress progress) {
        String sql = "INSERT INTO topic_progress(topic_id, user_id, progress_percent) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, progress.getTopicId());
            ps.setInt(2, progress.getUserId());
            ps.setBigDecimal(3, progress.getProgressPercent());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    progress.setProgressId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating topic progress", e);
        }
        return 0;
    }

    public boolean update(TopicProgress progress) {
        String sql = "UPDATE topic_progress SET progress_percent = ?, last_accessed = CURRENT_TIMESTAMP WHERE progress_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, progress.getProgressPercent());
            ps.setInt(2, progress.getProgressId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating topic progress", e);
        }
    }

    public boolean upsertProgress(int userId, int topicId, BigDecimal progressPercent) {
        String sql = "INSERT INTO topic_progress(topic_id, user_id, progress_percent) " +
                     "VALUES(?,?,?) " +
                     "ON DUPLICATE KEY UPDATE progress_percent = ?, last_accessed = CURRENT_TIMESTAMP";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, progressPercent);
            ps.setBigDecimal(4, progressPercent);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error upserting topic progress", e);
        }
    }
}
