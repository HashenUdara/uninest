package com.uninest.model.dao;

import com.uninest.util.DBConnection;
import java.sql.*;

public class ModeratorActionDAO {

    public boolean logAction(int moderatorId, Integer postId, String actionType, String reason) {
        String sql = "INSERT INTO moderator_actions (moderator_id, post_id, action_type, reason) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, moderatorId);
            if (postId != null) {
                stmt.setInt(2, postId);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, actionType);
            stmt.setString(4, reason);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
