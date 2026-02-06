package com.uninest.model;

import java.sql.Timestamp;

/**
 * Model class representing a report on a community post.
 * Maps to the community_post_reports table.
 */
public class PostReport {
    private int id;
    private int postId;
    private int reporterUserId;
    private String reason;
    private String status; // pending, reviewed, dismissed
    private Timestamp createdAt;
    private Integer reviewedBy;
    private Timestamp reviewedAt;

    // Display fields
    private String postTitle;
    private String reporterName;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getReporterUserId() {
        return reporterUserId;
    }

    public void setReporterUserId(int reporterUserId) {
        this.reporterUserId = reporterUserId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public String getPostTitle() {
        return postTitle;
    }

    public void setPostTitle(String postTitle) {
        this.postTitle = postTitle;
    }

    public String getReporterName() {
        return reporterName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }
}
