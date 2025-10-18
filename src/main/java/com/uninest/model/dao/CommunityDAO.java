package com.uninest.model.dao;

import com.uninest.model.Community;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CommunityDAO {

    private Community map(ResultSet rs) throws SQLException {
        Community comm = new Community();
        comm.setId(rs.getInt("id"));
        comm.setTitle(rs.getString("title"));
        comm.setDescription(rs.getString("description"));
        comm.setCreatedByUserId(rs.getInt("created_by_user_id"));
        comm.setStatus(rs.getString("status"));
        comm.setApproved(rs.getBoolean("approved"));
        comm.setApprovedAt(rs.getTimestamp("approved_at"));
        int apBy = rs.getInt("approved_by_user_id");
        comm.setApprovedByUserId(rs.wasNull() ? null : apBy);
        return comm;
    }

    public Optional<Community> findByCreatorUserId(int userId) {
        String sql = "SELECT * FROM communities WHERE created_by_user_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching community by creator", e);
        }
        return Optional.empty();
    }

    public Optional<Community> findById(int id) {
        String sql = "SELECT * FROM communities WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching community", e);
        }
        return Optional.empty();
    }

    public int create(Community comm) {
        String sql = "INSERT INTO communities(title, description, created_by_user_id, status, approved) VALUES(?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, comm.getTitle());
            ps.setString(2, comm.getDescription());
            ps.setInt(3, comm.getCreatedByUserId());
            ps.setString(4, comm.getStatus() != null ? comm.getStatus() : "pending");
            ps.setBoolean(5, comm.isApproved());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    comm.setId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating community", e);
        }
        return 0;
    }

    public boolean approve(int communityId, int adminUserId) {
        String sql = "UPDATE communities SET status = 'approved', approved = 1, approved_at = NOW(), approved_by_user_id = ? WHERE id = ?";
        String updateModeratorSql = "UPDATE users SET community_id = ? WHERE id = (SELECT created_by_user_id FROM communities WHERE id = ?)";
        try (Connection con = DBConnection.getConnection()) {
            // Start transaction
            con.setAutoCommit(false);
            try {
                // Update community status
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, adminUserId);
                    ps.setInt(2, communityId);
                    ps.executeUpdate();
                }
                
                // Update moderator's community_id
                try (PreparedStatement ps = con.prepareStatement(updateModeratorSql)) {
                    ps.setInt(1, communityId);
                    ps.setInt(2, communityId);
                    ps.executeUpdate();
                }
                
                // Commit transaction
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error approving community", e);
        }
    }

    public boolean reject(int communityId, int adminUserId) {
        String sql = "UPDATE communities SET status = 'rejected', approved = 0, approved_at = NOW(), approved_by_user_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminUserId);
            ps.setInt(2, communityId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error rejecting community", e);
        }
    }

    public boolean update(Community comm) {
        String sql = "UPDATE communities SET title = ?, description = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, comm.getTitle());
            ps.setString(2, comm.getDescription());
            ps.setInt(3, comm.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating community", e);
        }
    }

    public boolean delete(int communityId) {
        String sql = "DELETE FROM communities WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting community", e);
        }
    }

    public List<Community> findAll() {
        String sql = "SELECT * FROM communities ORDER BY created_at DESC";
        List<Community> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error listing communities", e);
        }
        return list;
    }

    public List<Community> findByStatus(String status) {
        String sql = "SELECT * FROM communities WHERE status = ? ORDER BY created_at DESC";
        List<Community> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error listing communities by status", e);
        }
        return list;
    }
}
