package com.uninest.model.dao;

import com.uninest.model.Organization;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class OrganizationDAO {

    private Organization map(ResultSet rs) throws SQLException {
        Organization org = new Organization();
        org.setId(rs.getInt("id"));
        org.setTitle(rs.getString("title"));
        org.setDescription(rs.getString("description"));
        org.setCreatedByUserId(rs.getInt("created_by_user_id"));
        org.setApproved(rs.getBoolean("approved"));
        org.setApprovedAt(rs.getTimestamp("approved_at"));
        int apBy = rs.getInt("approved_by_user_id");
        org.setApprovedByUserId(rs.wasNull() ? null : apBy);
        return org;
    }

    public Optional<Organization> findByCreatorUserId(int userId) {
        String sql = "SELECT * FROM organizations WHERE created_by_user_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching organization by creator", e);
        }
        return Optional.empty();
    }

    public Optional<Organization> findById(int id) {
        String sql = "SELECT * FROM organizations WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching organization", e);
        }
        return Optional.empty();
    }

    public int create(Organization org) {
        String sql = "INSERT INTO organizations(title, description, created_by_user_id, approved) VALUES(?,?,?,0)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, org.getTitle());
            ps.setString(2, org.getDescription());
            ps.setInt(3, org.getCreatedByUserId());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    org.setId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating organization", e);
        }
        return 0;
    }

    public boolean approve(int organizationId, int adminUserId) {
        String sql = "UPDATE organizations SET approved = 1, approved_at = NOW(), approved_by_user_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminUserId);
            ps.setInt(2, organizationId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error approving organization", e);
        }
    }

    public List<Organization> findAll() {
        String sql = "SELECT * FROM organizations ORDER BY created_at DESC";
        List<Organization> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error listing organizations", e);
        }
        return list;
    }
}
