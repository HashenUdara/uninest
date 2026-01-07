package com.uninest.model.dao;

import com.uninest.model.CommunityPost;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for community posts.
 * Handles CRUD operations for the community_posts table.
 */
public class CommunityPostDAO {
    /**
     * Maps a ResultSet row to a CommunityPost object.
     */
    private CommunityPost map(ResultSet rs) throws SQLException {
        CommunityPost post = new CommunityPost();
        post.setId(rs.getInt("id"));
        post.setUserId(rs.getInt("user_id"));
        post.setCommunityId(rs.getInt("community_id"));
        post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setImageUrl(rs.getString("image_url"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUpdatedAt(rs.getTimestamp("updated_at"));
        post.setDeleted(rs.getBoolean("is_deleted"));
        post.setDeletedAt(rs.getTimestamp("deleted_at"));
        return post;
    }

    /**
     * Creates a new community post.
     * @param post The post to create
     * @return The generated post ID
     */
    public int create(CommunityPost post) {
        String sql = "INSERT INTO community_posts(user_id, community_id, title, content, image_url) VALUES(?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, post.getUserId());
            ps.setInt(2, post.getCommunityId());
            ps.setString(3, post.getTitle());
            ps.setString(4, post.getContent());
            ps.setString(5, post.getImageUrl());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    post.setId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating community post", e);
        }
        return 0;
    }

    /**
     * Finds a post by its ID.
     */
    public Optional<CommunityPost> findById(int id) {
        String sql = "SELECT * FROM community_posts WHERE id = ? AND is_deleted = FALSE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching community post", e);
        }
        return Optional.empty();
    }

    /**
     * Finds a post by its ID with full author and stat details.
     */
    public Optional<CommunityPost> findByIdWithAuthor(int id) {
        String sql = """
            SELECT p.*, 
                   u.name AS author_name,
                   (SELECT COUNT(*) FROM post_likes WHERE post_id = p.id) AS like_count,
                   (SELECT COUNT(*) FROM post_comments WHERE post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            WHERE p.id = ? AND p.is_deleted = FALSE
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CommunityPost post = map(rs);
                    post.setAuthorName(rs.getString("author_name"));
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    return Optional.of(post);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching community post with details", e);
        }
        return Optional.empty();
    }

    /**
     * Finds all posts by a specific user (for My Posts page).
     */
    public List<CommunityPost> findByUserId(int userId) {
        String sql = "SELECT * FROM community_posts WHERE user_id = ? AND is_deleted = FALSE ORDER BY created_at DESC";
        List<CommunityPost> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts by user", e);
        }
        return list;
    }

    /**
     * Finds all posts for a community (for community feed).
     */
    public List<CommunityPost> findByCommunityId(int communityId) {
        String sql = "SELECT * FROM community_posts WHERE community_id = ? AND is_deleted = FALSE ORDER BY created_at DESC";
        List<CommunityPost> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts by community", e);
        }
        return list;
    }

    /**
     * Finds all posts for a community with author info.
     * Includes author name, like count, and comment count via JOINs and subqueries.
     */
    public List<CommunityPost> findByCommunityIdWithAuthor(int communityId) {
        String sql = """
            SELECT p.*, 
                   u.name AS author_name,
                   (SELECT COUNT(*) FROM post_likes WHERE post_id = p.id) AS like_count,
                   (SELECT COUNT(*) FROM post_comments WHERE post_id = p.id) AS comment_count
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            WHERE p.community_id = ? AND p.is_deleted = FALSE
            ORDER BY p.created_at DESC
            """;
        List<CommunityPost> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommunityPost post = map(rs);
                    post.setAuthorName(rs.getString("author_name"));
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    list.add(post);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts with author", e);
        }
        return list;
    }

    /**
     * Updates an existing community post.
     * Updates title, content, image_url, and sets updated_at to current timestamp.
     * @param post The post with updated values (must have valid id)
     * @return true if update was successful, false otherwise
     */
    public boolean update(CommunityPost post) {
        String sql = "UPDATE community_posts SET title = ?, content = ?, image_url = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getImageUrl());
            ps.setInt(4, post.getId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating community post", e);
        }
    }

    /**
     * Deletes a community post by its ID.
     * Also deletes associated likes and comments due to CASCADE constraint.
     * @param postId The ID of the post to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean delete(int postId) {
        String sql = "UPDATE community_posts SET is_deleted = TRUE, deleted_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting community post", e);
        }
    }

    /**
     * Finds deleted posts for a community with deletion reason.
     */
    public List<CommunityPost> findDeletedByCommunityId(int communityId) {
        String sql = """
            SELECT p.*, 
                   u.name AS author_name,
                   ma.reason AS deletion_reason
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            LEFT JOIN moderator_actions ma ON ma.post_id = p.id AND ma.action_type = 'POST_DELETE'
            WHERE p.community_id = ? AND p.is_deleted = TRUE
            ORDER BY p.deleted_at DESC
            """;
        List<CommunityPost> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommunityPost post = map(rs);
                    post.setAuthorName(rs.getString("author_name"));
                    post.setDeletionReason(rs.getString("deletion_reason"));
                    list.add(post);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching deleted posts", e);
        }
        return list;
    }
}
