package com.uninest.model.dao;

import com.uninest.model.User;
import com.uninest.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.HashSet;
import java.util.Set;

public class UserDAO {

    public User findByEmail(String email) {
        String sql = "SELECT u.id, u.email, u.password_hash, u.enabled, r.role FROM users u " +
                "LEFT JOIN user_roles r ON u.id = r.user_id WHERE u.email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                User user = null;
                Set<String> roles = new HashSet<>();
                while (rs.next()) {
                    if (user == null) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setEmail(rs.getString("email"));
                        user.setPasswordHash(rs.getString("password_hash"));
                        user.setEnabled(rs.getBoolean("enabled"));
                    }
                    String role = rs.getString("role");
                    if (role != null) roles.add(role);
                }
                if (user != null) user.setRoles(roles);
                return user;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding user by email", e);
        }
    }

    public boolean verifyPassword(String raw, String hash) {
        return raw != null && hash != null && BCrypt.checkpw(raw, hash);
    }

    public String hashPassword(String raw) {
        return BCrypt.hashpw(raw, BCrypt.gensalt());
    }
}
