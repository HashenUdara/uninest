package com.uninest.model.dao;

import com.uninest.model.CommunityPost;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for CommunityPost.
 * Provides methods to interact with the community_posts table.
 */
public class CommunityPostDAO {

    /**
     * Fetches all community posts with user name, like count, and comment count.
     * Results are ordered by created_at DESC (newest first).
     * 
     * @return List of CommunityPost objects with all display fields populated
     */
    public List<CommunityPost> findAll() {
        String sql = """
            SELECT 
                p.id,
                p.user_id,
                p.content,
                p.created_at,
                u.name AS user_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments c WHERE c.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            ORDER BY p.created_at DESC
            LIMIT 20
            """;
        
        List<CommunityPost> posts = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                posts.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            // If table doesn't exist yet, return empty list instead of crashing
            if (e.getMessage().contains("doesn't exist") || e.getMessage().contains("Unknown column")) {
                System.err.println("Community posts tables not migrated yet. Run community_posts_migration.sql");
                return posts;
            }
            throw new RuntimeException("Error fetching community posts", e);
        }
        return posts;
    }

    /**
     * Creates a new community post.
     * 
     * @param post CommunityPost object with userId and content set
     * @return The created post with generated ID
     */
    public CommunityPost create(CommunityPost post) {
        String sql = "INSERT INTO community_posts (user_id, content) VALUES (?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getContent());
            ps.executeUpdate();
            
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    post.setId(keys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating community post", e);
        }
        return post;
    }

    /**
     * Finds a community post by its ID.
     * 
     * @param id The post ID
     * @return The CommunityPost or null if not found
     */
    public CommunityPost findById(int id) {
        String sql = """
            SELECT 
                p.id,
                p.user_id,
                p.content,
                p.created_at,
                u.name AS user_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments c WHERE c.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            WHERE p.id = ?
            """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching community post by id", e);
        }
        return null;
    }

    /**
     * Deletes a community post by its ID.
     * 
     * @param id The post ID to delete
     * @return true if deleted, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM community_posts WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting community post", e);
        }
    }

    /**
     * Maps a ResultSet row to a CommunityPost object.
     */
    private CommunityPost mapResultSet(ResultSet rs) throws SQLException {
        CommunityPost post = new CommunityPost();
        post.setId(rs.getInt("id"));
        post.setUserId(rs.getInt("user_id"));
        post.setContent(rs.getString("content"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUserName(rs.getString("user_name"));
        post.setLikeCount(rs.getInt("like_count"));
        post.setCommentCount(rs.getInt("comment_count"));
        return post;
    }
}
