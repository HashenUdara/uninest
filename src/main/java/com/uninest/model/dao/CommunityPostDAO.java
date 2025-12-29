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
}
