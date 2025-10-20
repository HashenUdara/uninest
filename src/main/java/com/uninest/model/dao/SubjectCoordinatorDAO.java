package com.uninest.model.dao;

import com.uninest.model.SubjectCoordinator;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SubjectCoordinatorDAO {

    /**
     * Map ResultSet to SubjectCoordinator with joined data
     */
    private SubjectCoordinator map(ResultSet rs) throws SQLException {
        SubjectCoordinator sc = new SubjectCoordinator();
        sc.setCoordinatorId(rs.getInt("coordinator_id"));
        sc.setUserId(rs.getInt("user_id"));
        sc.setSubjectId(rs.getInt("subject_id"));
        sc.setAssignedAt(rs.getTimestamp("assigned_at"));
        
        // Optional joined fields
        try { sc.setUserName(rs.getString("user_name")); } catch (SQLException e) {}
        try { sc.setUserEmail(rs.getString("user_email")); } catch (SQLException e) {}
        try { sc.setSubjectName(rs.getString("subject_name")); } catch (SQLException e) {}
        try { sc.setSubjectCode(rs.getString("subject_code")); } catch (SQLException e) {}
        try { 
            int ay = rs.getInt("academic_year");
            sc.setAcademicYear(rs.wasNull() ? null : ay);
        } catch (SQLException e) {}
        try { sc.setUniversityName(rs.getString("university_name")); } catch (SQLException e) {}
        
        return sc;
    }

    /**
     * Find all coordinators for a specific subject
     */
    public List<SubjectCoordinator> findBySubjectId(int subjectId) {
        String sql = "SELECT sc.coordinator_id, sc.user_id, sc.subject_id, sc.assigned_at, " +
                "u.name AS user_name, u.email AS user_email, u.academic_year, " +
                "uni.name AS university_name " +
                "FROM subject_coordinators sc " +
                "JOIN users u ON sc.user_id = u.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE sc.subject_id = ? " +
                "ORDER BY sc.assigned_at DESC";
        List<SubjectCoordinator> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching coordinators for subject " + subjectId, e);
        }
        return list;
    }

    /**
     * Find all coordinators in a community (for global view)
     */
    public List<SubjectCoordinator> findByCommunityId(int communityId) {
        String sql = "SELECT sc.coordinator_id, sc.user_id, sc.subject_id, sc.assigned_at, " +
                "u.name AS user_name, u.email AS user_email, u.academic_year, " +
                "uni.name AS university_name, " +
                "s.name AS subject_name, s.code AS subject_code " +
                "FROM subject_coordinators sc " +
                "JOIN users u ON sc.user_id = u.id " +
                "JOIN subjects s ON sc.subject_id = s.subject_id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE s.community_id = ? " +
                "ORDER BY sc.assigned_at DESC";
        List<SubjectCoordinator> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching coordinators for community " + communityId, e);
        }
        return list;
    }

    /**
     * Assign a user as coordinator for a subject
     */
    public boolean assign(int userId, int subjectId) {
        String sql = "INSERT INTO subject_coordinators(user_id, subject_id) VALUES(?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error assigning coordinator", e);
        }
    }

    /**
     * Unassign a coordinator
     */
    public boolean unassign(int coordinatorId) {
        String sql = "DELETE FROM subject_coordinators WHERE coordinator_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, coordinatorId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error unassigning coordinator", e);
        }
    }

    /**
     * Check if a user is already a coordinator for any subject
     */
    public boolean isCoordinator(int userId) {
        String sql = "SELECT COUNT(*) FROM subject_coordinators WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking coordinator status", e);
        }
        return false;
    }

    /**
     * Check if a user is coordinator for a specific subject
     */
    public boolean isCoordinatorForSubject(int userId, int subjectId) {
        String sql = "SELECT COUNT(*) FROM subject_coordinators WHERE user_id = ? AND subject_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking coordinator for subject", e);
        }
        return false;
    }

    /**
     * Find a coordinator by ID
     */
    public Optional<SubjectCoordinator> findById(int coordinatorId) {
        String sql = "SELECT sc.coordinator_id, sc.user_id, sc.subject_id, sc.assigned_at, " +
                "u.name AS user_name, u.email AS user_email, u.academic_year, " +
                "uni.name AS university_name, " +
                "s.name AS subject_name, s.code AS subject_code " +
                "FROM subject_coordinators sc " +
                "JOIN users u ON sc.user_id = u.id " +
                "JOIN subjects s ON sc.subject_id = s.subject_id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE sc.coordinator_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, coordinatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching coordinator by ID", e);
        }
        return Optional.empty();
    }

    /**
     * Update the subject assigned to a coordinator
     */
    public boolean updateSubject(int coordinatorId, int newSubjectId) {
        String sql = "UPDATE subject_coordinators SET subject_id = ? WHERE coordinator_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newSubjectId);
            ps.setInt(2, coordinatorId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating coordinator subject", e);
        }
    }
}
