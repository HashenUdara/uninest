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
        String sql = "SELECT * FROM community_posts WHERE id = ?";
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
     * Finds all posts by a specific user (for My Posts page).
     */
    public List<CommunityPost> findByUserId(int userId) {
        String sql = "SELECT * FROM community_posts WHERE user_id = ? ORDER BY created_at DESC";
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
        String sql = "SELECT * FROM community_posts WHERE community_id = ? ORDER BY created_at DESC";
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
     * @param sort The sort order ("recent" or "upvoted")
     */
    /**
     * Finds all posts for a community with author info.
     * Includes author name, total vote score, and comment count.
     * Also checks if the current user has voted on each post.
     * @param userId The ID of the currently logged-in user (to check their vote)
     * @param sort The sort order ("recent" or "upvoted")
     */
    public List<CommunityPost> findByCommunityIdWithAuthor(int communityId, int userId, String sort) {
        String orderBy = "p.created_at DESC";
        if ("upvoted".equals(sort)) {
            orderBy = "like_count DESC, p.created_at DESC";
        }

        String sql = """
            SELECT p.*, 
                   u.name AS author_name,
                   COALESCE((SELECT SUM(vote_type) FROM post_likes WHERE post_id = p.id), 0) AS like_count,
                   (SELECT COUNT(*) FROM post_comments WHERE post_id = p.id) AS comment_count,
                   (SELECT vote_type FROM post_likes WHERE post_id = p.id AND user_id = ?) AS user_vote
            FROM community_posts p
            JOIN users u ON p.user_id = u.id
            WHERE p.community_id = ?
            ORDER BY\s""" + orderBy;
            
        List<CommunityPost> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, communityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommunityPost post = map(rs);
                    post.setAuthorName(rs.getString("author_name"));
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    int userVote = rs.getObject("user_vote") != null ? rs.getInt("user_vote") : 0;
                    post.setUserVote(userVote); 
                    list.add(post);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts with author", e);
        }
        return list;
    }

    /**
     * Handles voting logic (Upvote/Downvote/Toggle).
     * @param userId The user casting the vote.
     * @param postId The ID of the post.
     * @param type 1 for Upvote, -1 for Downvote.
     * @return The new vote type of the user (1, -1, or 0 if removed).
     */
    public int vote(int userId, int postId, int type) {
        String checkSql = "SELECT vote_type FROM post_likes WHERE user_id = ? AND post_id = ?";
        int currentType = 0;
        boolean hasVote = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    hasVote = true;
                    currentType = rs.getInt("vote_type");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking vote status", e);
        }

        try (Connection con = DBConnection.getConnection()) {
            if (!hasVote) {
                // Insert new vote
                String insertSql = "INSERT INTO post_likes (user_id, post_id, vote_type) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, postId);
                    ps.setInt(3, type);
                    ps.executeUpdate();
                    return type;
                }
            } else if (currentType == type) {
                // Toggle OFF (delete vote)
                String deleteSql = "DELETE FROM post_likes WHERE user_id = ? AND post_id = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, postId);
                    ps.executeUpdate();
                    return 0; // Vote removed
                }
            } else {
                // Switch vote (e.g., Up -> Down)
                String updateSql = "UPDATE post_likes SET vote_type = ? WHERE user_id = ? AND post_id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setInt(1, type);
                    ps.setInt(2, userId);
                    ps.setInt(3, postId);
                    ps.executeUpdate();
                    return type;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating vote", e);
        }
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
     * @param id The ID of the post to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM community_posts WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting community post", e);
        }
    }
}
