package com.uninest.model;

import java.sql.Timestamp;

/**
 * Model class representing a community post.
 * Maps to the community_posts table with additional display fields.
 */
public class CommunityPost {
    private int id;
    private int userId;
    private int communityId;
    private String title;
    private String content;
    private String imageUrl;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Display fields (populated via JOIN)
    private String userName;
    private String communityName;
    private int likeCount;
    private int commentCount;
    private boolean likedByCurrentUser;
    
    public CommunityPost() {}
    
    public CommunityPost(int userId, int communityId, String title, String content) {
        this.userId = userId;
        this.communityId = communityId;
        this.title = title;
        this.content = content;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getCommunityId() { return communityId; }
    public void setCommunityId(int communityId) { this.communityId = communityId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getCommunityName() { return communityName; }
    public void setCommunityName(String communityName) { this.communityName = communityName; }
    
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    
    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { this.likedByCurrentUser = likedByCurrentUser; }
    
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
