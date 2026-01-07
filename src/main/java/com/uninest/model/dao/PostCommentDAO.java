package com.uninest.model.dao;

import com.uninest.model.PostComment;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for post comments.
 * Handles CRUD operations and hierarchical tree building for comments.
 */
public class PostCommentDAO {

    /**
     * Maps a ResultSet row to a PostComment object.
     */
    private PostComment map(ResultSet rs) throws SQLException {
        PostComment comment = new PostComment();
        comment.setId(rs.getInt("id"));
        comment.setPostId(rs.getInt("post_id"));
        comment.setUserId(rs.getInt("user_id"));
        
        int parentId = rs.getInt("parent_id");
        if (!rs.wasNull()) {
            comment.setParentId(parentId);
        }
        
        comment.setContent(rs.getString("content"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Optional: Map author info if joined
        try {
            comment.setAuthorName(rs.getString("author_name"));
        } catch (SQLException e) {
            // Column might not exist in simple queries
        }
        
        return comment;
    }

    /**
     * Creates a new comment.
     * @param comment The comment to create
     * @return The generated comment ID
     */
    public int create(PostComment comment) {
        String sql = "INSERT INTO post_comments(post_id, user_id, parent_id, content) VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, comment.getPostId());
            ps.setInt(2, comment.getUserId());
            
            if (comment.getParentId() != null) {
                ps.setInt(3, comment.getParentId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            ps.setString(4, comment.getContent());
            
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    comment.setId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating comment", e);
        }
        return 0;
    }

    /**
     * Finds all comments for a post, organized in a hierarchical tree structure.
     * @param postId The ID of the post
     * @return List of top-level comments (with replies populated)
     */
    public List<PostComment> findByPostId(int postId) {
        String sql = """
            SELECT c.*, u.name AS author_name
            FROM post_comments c
            JOIN users u ON c.user_id = u.id
            WHERE c.post_id = ?
            ORDER BY c.created_at ASC
            """;
            
        List<PostComment> allComments = new ArrayList<>();
        Map<Integer, PostComment> commentMap = new HashMap<>();
        List<PostComment> rootComments = new ArrayList<>();
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PostComment comment = map(rs);
                    allComments.add(comment);
                    commentMap.put(comment.getId(), comment);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching comments", e);
        }
        
        // Build the tree
        for (PostComment comment : allComments) {
            if (comment.getParentId() == null) {
                rootComments.add(comment);
            } else {
                PostComment parent = commentMap.get(comment.getParentId());
                if (parent != null) {
                    parent.addReply(comment);
                } else {
                    // Parent not found (maybe deleted?), treat as root or handle gracefully
                    // For now, allow it to float if parent is missing from result set
                    // But with Cascade delete, this shouldn't happen often
                    rootComments.add(comment);
                }
            }
        }
        
        return rootComments;
    }
    
    /**
     * Deletes a comment by its ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM post_comments WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting comment", e);
        }
    }
}
