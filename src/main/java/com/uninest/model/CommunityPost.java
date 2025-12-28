package com.uninest.model;

import java.sql.Timestamp;

/**
 * Model class representing a community post.
 * Maps to the community_posts table with additional display fields.
 */
public class CommunityPost {
    private int id;
    private int userId;
    private String content;
    private Timestamp createdAt;
    
    // Display fields (populated via JOIN)
    private String userName;
    private int likeCount;
    private int commentCount;
    
    public CommunityPost() {}
    
    public CommunityPost(int userId, String content) {
        this.userId = userId;
        this.content = content;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    
    /**
     * Gets the user's initials for avatar display.
     * @return Two-letter initials from the user name
     */
    public String getUserInitials() {
        if (userName == null || userName.isEmpty()) {
            return "??";
        }
        String[] parts = userName.trim().split("\\s+");
        if (parts.length >= 2) {
            return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
        } else if (parts.length == 1 && parts[0].length() >= 2) {
            return parts[0].substring(0, 2).toUpperCase();
        } else {
            return parts[0].substring(0, 1).toUpperCase();
        }
    }
    
    /**
     * Gets a relative time string for display (e.g., "2 hours ago").
     * @return Formatted relative time string
     */
    public String getRelativeTime() {
        if (createdAt == null) {
            return "Unknown";
        }
        
        long diffMillis = System.currentTimeMillis() - createdAt.getTime();
        long diffSeconds = diffMillis / 1000;
        long diffMinutes = diffSeconds / 60;
        long diffHours = diffMinutes / 60;
        long diffDays = diffHours / 24;
        
        if (diffSeconds < 60) {
            return "Just now";
        } else if (diffMinutes < 60) {
            return diffMinutes + (diffMinutes == 1 ? " minute ago" : " minutes ago");
        } else if (diffHours < 24) {
            return diffHours + (diffHours == 1 ? " hour ago" : " hours ago");
        } else if (diffDays < 7) {
            return diffDays + (diffDays == 1 ? " day ago" : " days ago");
        } else {
            return new java.text.SimpleDateFormat("MMM d, yyyy").format(createdAt);
        }
    }
}
