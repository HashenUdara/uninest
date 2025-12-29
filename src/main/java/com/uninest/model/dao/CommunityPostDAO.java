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
                p.community_id,
                p.title,
                p.content,
                p.image_url,
                p.created_at,
                p.updated_at,
                u.name AS user_name,
                c.title AS community_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments cm WHERE cm.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            JOIN communities c ON p.community_id = c.id
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
            if (e.getMessage().contains("doesn't exist") || e.getMessage().contains("Unknown column")) {
                System.err.println("Community posts tables not migrated yet. Run community_posts_migration.sql");
                return posts;
            }
            throw new RuntimeException("Error fetching community posts", e);
        }
        return posts;
    }

    /**
     * Fetches posts for a specific community.
     * 
     * @param communityId The community ID
     * @return List of CommunityPost objects for the community
     */
    public List<CommunityPost> findByCommunityId(int communityId) {
        String sql = """
            SELECT 
                p.id,
                p.user_id,
                p.community_id,
                p.title,
                p.content,
                p.image_url,
                p.created_at,
                p.updated_at,
                u.name AS user_name,
                c.title AS community_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments cm WHERE cm.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            JOIN communities c ON p.community_id = c.id
            WHERE p.community_id = ?
            ORDER BY p.created_at DESC
            LIMIT 50
            """;
        
        List<CommunityPost> posts = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts by community", e);
        }
        return posts;
    }

    /**
     * Fetches posts by a specific user.
     * 
     * @param userId The user ID
     * @return List of CommunityPost objects by the user
     */
    public List<CommunityPost> findByUserId(int userId) {
        String sql = """
            SELECT 
                p.id,
                p.user_id,
                p.community_id,
                p.title,
                p.content,
                p.image_url,
                p.created_at,
                p.updated_at,
                u.name AS user_name,
                c.title AS community_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments cm WHERE cm.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            JOIN communities c ON p.community_id = c.id
            WHERE p.user_id = ?
            ORDER BY p.created_at DESC
            """;
        
        List<CommunityPost> posts = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts by user", e);
        }
        return posts;
    }

    /**
     * Creates a new community post.
     * 
     * @param post CommunityPost object with required fields set
     * @return The created post with generated ID
     */
    public CommunityPost create(CommunityPost post) {
        String sql = """
            INSERT INTO community_posts (user_id, community_id, title, content, image_url) 
            VALUES (?, ?, ?, ?, ?)
            """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, post.getUserId());
            ps.setInt(2, post.getCommunityId());
            ps.setString(3, post.getTitle());
            ps.setString(4, post.getContent());
            ps.setString(5, post.getImageUrl()); // Can be null
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
     * Updates an existing community post.
     * 
     * @param post The post to update
     * @return true if updated, false otherwise
     */
    public boolean update(CommunityPost post) {
        String sql = """
            UPDATE community_posts 
            SET title = ?, content = ?, image_url = ?
            WHERE id = ? AND user_id = ?
            """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getImageUrl());
            ps.setInt(4, post.getId());
            ps.setInt(5, post.getUserId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating community post", e);
        }
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
                p.community_id,
                p.title,
                p.content,
                p.image_url,
                p.created_at,
                p.updated_at,
                u.name AS user_name,
                c.title AS community_name,
                (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                (SELECT COUNT(*) FROM post_comments cm WHERE cm.post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            JOIN communities c ON p.community_id = c.id
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
        post.setCommunityId(rs.getInt("community_id"));
        post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setImageUrl(rs.getString("image_url"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUpdatedAt(rs.getTimestamp("updated_at"));
        post.setUserName(rs.getString("user_name"));
        post.setCommunityName(rs.getString("community_name"));
        post.setLikeCount(rs.getInt("like_count"));
        post.setCommentCount(rs.getInt("comment_count"));
        return post;
    }
}
