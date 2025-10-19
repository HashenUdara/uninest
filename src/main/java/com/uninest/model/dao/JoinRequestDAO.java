package com.uninest.model.dao;

import com.uninest.model.JoinRequest;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JoinRequestDAO {

    private JoinRequest map(ResultSet rs) throws SQLException {
        JoinRequest jr = new JoinRequest();
        jr.setId(rs.getInt("id"));
        jr.setUserId(rs.getInt("user_id"));
        jr.setUserName(rs.getString("user_name"));
        jr.setUserEmail(rs.getString("user_email"));
        int ay = rs.getInt("user_academic_year");
        jr.setUserAcademicYear(rs.wasNull() ? null : ay);
        jr.setUniversityName(rs.getString("university_name"));
        jr.setCommunityId(rs.getInt("community_id"));
        jr.setCommunityTitle(rs.getString("community_title"));
        jr.setStatus(rs.getString("status"));
        jr.setRequestedAt(rs.getTimestamp("requested_at"));
        jr.setProcessedAt(rs.getTimestamp("processed_at"));
        int pBy = rs.getInt("processed_by_user_id");
        jr.setProcessedByUserId(rs.wasNull() ? null : pBy);
        return jr;
    }

    public int create(int userId, int communityId) {
        String sql = "INSERT INTO community_join_requests(user_id, community_id, status) VALUES(?, ?, 'pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, communityId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating join request", e);
        }
        return 0;
    }

    public Optional<JoinRequest> findById(int id) {
        String sql = "SELECT jr.*, u.name AS user_name, u.email AS user_email, u.academic_year AS user_academic_year, " +
                "uni.name AS university_name, c.title AS community_title " +
                "FROM community_join_requests jr " +
                "JOIN users u ON jr.user_id = u.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "JOIN communities c ON jr.community_id = c.id " +
                "WHERE jr.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching join request", e);
        }
        return Optional.empty();
    }

    public List<JoinRequest> findByCommunityAndStatus(int communityId, String status) {
        String sql = "SELECT jr.*, u.name AS user_name, u.email AS user_email, u.academic_year AS user_academic_year, " +
                "uni.name AS university_name, c.title AS community_title " +
                "FROM community_join_requests jr " +
                "JOIN users u ON jr.user_id = u.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "JOIN communities c ON jr.community_id = c.id " +
                "WHERE jr.community_id = ? AND jr.status = ? " +
                "ORDER BY jr.requested_at DESC";
        List<JoinRequest> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching join requests", e);
        }
        return list;
    }

    public boolean approve(int requestId, int moderatorUserId) {
        String sql = "UPDATE community_join_requests SET status = 'approved', processed_at = NOW(), processed_by_user_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moderatorUserId);
            ps.setInt(2, requestId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error approving join request", e);
        }
    }

    public boolean reject(int requestId, int moderatorUserId) {
        String sql = "UPDATE community_join_requests SET status = 'rejected', processed_at = NOW(), processed_by_user_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moderatorUserId);
            ps.setInt(2, requestId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error rejecting join request", e);
        }
    }

    public Optional<JoinRequest> findPendingRequestByUserAndCommunity(int userId, int communityId) {
        String sql = "SELECT jr.*, u.name AS user_name, u.email AS user_email, u.academic_year AS user_academic_year, " +
                "uni.name AS university_name, c.title AS community_title " +
                "FROM community_join_requests jr " +
                "JOIN users u ON jr.user_id = u.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "JOIN communities c ON jr.community_id = c.id " +
                "WHERE jr.user_id = ? AND jr.community_id = ? AND jr.status = 'pending'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking pending request", e);
        }
        return Optional.empty();
    }

    public Optional<JoinRequest> findPendingRequestByUser(int userId) {
        String sql = "SELECT jr.*, u.name AS user_name, u.email AS user_email, u.academic_year AS user_academic_year, " +
                "uni.name AS university_name, c.title AS community_title " +
                "FROM community_join_requests jr " +
                "JOIN users u ON jr.user_id = u.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "JOIN communities c ON jr.community_id = c.id " +
                "WHERE jr.user_id = ? AND jr.status = 'pending'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding pending request for user", e);
        }
        return Optional.empty();
    }

    public boolean delete(int requestId) {
        String sql = "DELETE FROM community_join_requests WHERE id = ? AND status = 'pending'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting join request", e);
        }
    }
}
