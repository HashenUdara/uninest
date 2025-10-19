package com.uninest.model.dao;

import com.uninest.model.User;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.Optional;

public class UserDAO {

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT u.id, u.email, u.name, u.password_hash, u.community_id, u.academic_year, u.university_id, " +
                "r.name AS role_name, c.title AS community_name, uni.name AS university_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "LEFT JOIN communities c ON u.community_id = c.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE u.email = ?";
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
        String sql = "INSERT INTO users(email, name, password_hash, role_id, community_id, academic_year, university_id) " +
                "VALUES(?,?,?,(SELECT id FROM roles WHERE name = ?),?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            if (user.getName() == null) ps.setNull(2, Types.VARCHAR); else ps.setString(2, user.getName());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            if (user.getCommunityId() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, user.getCommunityId());
            if (user.getAcademicYear() == null) ps.setNull(6, Types.TINYINT); else ps.setInt(6, user.getAcademicYear());
            if (user.getUniversityId() == null) ps.setNull(7, Types.INTEGER); else ps.setInt(7, user.getUniversityId());
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

    private User map(ResultSet rs) throws SQLException {
        User u = new User(
                rs.getInt("id"),
                rs.getString("email"),
                rs.getString("password_hash"),
                rs.getString("role_name")
        );
        u.setName(rs.getString("name"));
        int commId = rs.getInt("community_id");
        u.setCommunityId(rs.wasNull() ? null : commId);
        u.setCommunityName(rs.getString("community_name"));
        int ay = rs.getInt("academic_year");
        u.setAcademicYear(rs.wasNull() ? null : ay);
        int uniId = rs.getInt("university_id");
        u.setUniversityId(rs.wasNull() ? null : uniId);
        u.setUniversityName(rs.getString("university_name"));
        return u;
    }

    public boolean assignCommunity(int userId, int communityId) {
        String sql = "UPDATE users SET community_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error assigning community", e);
        }
    }

    public java.util.List<User> findByRole(String roleName) {
        String sql = "SELECT u.id, u.email, u.name, u.password_hash, u.community_id, u.academic_year, u.university_id, " +
                "r.name AS role_name, c.title AS community_name, uni.name AS university_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "LEFT JOIN communities c ON u.community_id = c.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE r.name = ? ORDER BY u.id DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching users by role", e);
        }
        return users;
    }

    public java.util.List<User> searchUsers(String roleName, String searchTerm) {
        String sql = "SELECT u.id, u.email, u.name, u.password_hash, u.community_id, u.academic_year, u.university_id, " +
                "r.name AS role_name, c.title AS community_name, uni.name AS university_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "LEFT JOIN communities c ON u.community_id = c.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE r.name = ? AND (u.email LIKE ? OR u.name LIKE ? OR uni.name LIKE ?) ORDER BY u.id DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roleName);
            String pattern = "%" + searchTerm + "%";
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching users", e);
        }
        return users;
    }

    public Optional<User> findById(int id) {
        String sql = "SELECT u.id, u.email, u.name, u.password_hash, u.community_id, u.academic_year, u.university_id, " +
                "r.name AS role_name, c.title AS community_name, uni.name AS university_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "LEFT JOIN communities c ON u.community_id = c.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE u.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
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

    public void update(User user) {
        String sql = "UPDATE users SET email = ?, name = ?, community_id = ?, academic_year = ?, university_id = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            if (user.getName() == null) ps.setNull(2, Types.VARCHAR); else ps.setString(2, user.getName());
            if (user.getCommunityId() == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, user.getCommunityId());
            if (user.getAcademicYear() == null) ps.setNull(4, Types.TINYINT); else ps.setInt(4, user.getAcademicYear());
            if (user.getUniversityId() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, user.getUniversityId());
            ps.setInt(6, user.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating user", e);
        }
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting user", e);
        }
    }

    public boolean removeCommunity(int userId) {
        String sql = "UPDATE users SET community_id = NULL WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error removing community", e);
        }
    }

    public java.util.List<User> findByCommunityId(int communityId) {
        String sql = "SELECT u.id, u.email, u.name, u.password_hash, u.community_id, u.academic_year, u.university_id, " +
                "r.name AS role_name, c.title AS community_name, uni.name AS university_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "LEFT JOIN communities c ON u.community_id = c.id " +
                "LEFT JOIN universities uni ON u.university_id = uni.id " +
                "WHERE u.community_id = ? AND r.name = 'student' ORDER BY u.id DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching users by community", e);
        }
        return users;
    }
}
