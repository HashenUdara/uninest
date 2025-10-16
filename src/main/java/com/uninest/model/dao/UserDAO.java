package com.uninest.model.dao;

import com.uninest.model.User;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.Optional;

public class UserDAO {

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT u.id, u.email, u.password_hash, r.name AS role_name, u.organization_id, u.academic_year, u.university " +
                "FROM users u JOIN roles r ON u.role_id = r.id WHERE u.email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user", e);
        }
        return Optional.empty();
    }

    public void create(User user) {
        String sql = "INSERT INTO users(email, password_hash, role_id, organization_id, academic_year, university) VALUES(?,?,(SELECT id FROM roles WHERE name = ?),?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getRole());
            if (user.getOrganizationId() != null) {
                ps.setInt(4, user.getOrganizationId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (user.getAcademicYear() != null) {
                ps.setInt(5, user.getAcademicYear());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, user.getUniversity());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) user.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating user", e);
        }
    }

    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating password", e);
        }
    }

    public String createResetToken(int userId, long ttlMinutes) {
        String token = java.util.UUID.randomUUID().toString().replaceAll("-", "");
        String sql = "INSERT INTO password_reset_tokens(token,user_id,expires_at) VALUES(?,?,DATE_ADD(NOW(), INTERVAL ? MINUTE))";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.setLong(3, ttlMinutes);
            ps.executeUpdate();
            return token;
        } catch (SQLException e) {
            throw new RuntimeException("Error creating reset token", e);
        }
    }

    public Optional<Integer> validateResetToken(String token) {
        String sql = "SELECT user_id FROM password_reset_tokens WHERE token=? AND used=0 AND expires_at > NOW()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error validating token", e);
        }
        return Optional.empty();
    }

    public void markTokenUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used=1 WHERE token=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking token used", e);
        }
    }

    public boolean updateOrganization(int userId, int organizationId) {
        String sql = "UPDATE users SET organization_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, organizationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating user organization", e);
        }
    }

    public Optional<User> findById(int userId) {
        String sql = "SELECT u.id, u.email, u.password_hash, r.name AS role_name, u.organization_id, u.academic_year, u.university " +
                "FROM users u JOIN roles r ON u.role_id = r.id WHERE u.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user by id", e);
        }
        return Optional.empty();
    }

    private User map(ResultSet rs) throws SQLException {
        Integer orgId = rs.getInt("organization_id");
        if (rs.wasNull()) orgId = null;
        Integer academicYear = rs.getInt("academic_year");
        if (rs.wasNull()) academicYear = null;
        
        return new User(
                rs.getInt("id"),
                rs.getString("email"),
                rs.getString("password_hash"),
                rs.getString("role_name"),
                orgId,
                academicYear,
                rs.getString("university")
        );
    }
}
