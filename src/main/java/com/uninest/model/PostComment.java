package com.uninest.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model class representing a post comment.
 * Maps to the post_comments table.
 * Supports nested replies.
 */
public class PostComment {
    private int id;
    private int postId;
    private int userId;
    private Integer parentId; // Nullable for top-level comments
    private String content;
    private Timestamp createdAt;

    // Display fields (populated via JOIN queries)
    private String authorName;
    private String authorAvatar; // Optional, might be used later

    // Nested replies
    private List<PostComment> replies = new ArrayList<>();

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public String getAuthorAvatar() { return authorAvatar; }
    public void setAuthorAvatar(String authorAvatar) { this.authorAvatar = authorAvatar; }

    public List<PostComment> getReplies() { return replies; }
    public void setReplies(List<PostComment> replies) { this.replies = replies; }
    
    public void addReply(PostComment reply) {
        this.replies.add(reply);
    }
}
