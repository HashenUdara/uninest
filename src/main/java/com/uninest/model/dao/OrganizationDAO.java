package com.uninest.model.dao;

import com.uninest.model.Organization;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class OrganizationDAO {

    public int create(Organization org) {
        String sql = "INSERT INTO organizations(title, description, moderator_id, status) VALUES(?, ?, ?, 'pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, org.getTitle());
            ps.setString(2, org.getDescription());
            ps.setInt(3, org.getModeratorId());
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
        return -1;
    }

    public Optional<Organization> findById(int id) {
        String sql = "SELECT * FROM organizations WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching organization", e);
        }
        return Optional.empty();
    }

    public Optional<Organization> findByModeratorId(int moderatorId) {
        String sql = "SELECT * FROM organizations WHERE moderator_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, moderatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching organization by moderator", e);
        }
        return Optional.empty();
    }

    public List<Organization> findAll() {
        String sql = "SELECT * FROM organizations ORDER BY created_at DESC";
        List<Organization> organizations = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                organizations.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching organizations", e);
        }
        return organizations;
    }

    public List<Organization> findPending() {
        String sql = "SELECT * FROM organizations WHERE status = 'pending' ORDER BY created_at DESC";
        List<Organization> organizations = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                organizations.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching pending organizations", e);
        }
        return organizations;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE organizations SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating organization status", e);
        }
    }

    private Organization map(ResultSet rs) throws SQLException {
        return new Organization(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getInt("moderator_id"),
                rs.getString("status"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at")
        );
    }
}
