package com.uninest.model;

import java.sql.Timestamp;

public class Organization {
    private int id;
    private String title;
    private String description;
    private int moderatorId;
    private String status; // pending, approved, rejected
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Organization() {}

    public Organization(int id, String title, String description, int moderatorId, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.moderatorId = moderatorId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getModeratorId() {
        return moderatorId;
    }

    public void setModeratorId(int moderatorId) {
        this.moderatorId = moderatorId;
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

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isPending() {
        return "pending".equalsIgnoreCase(status);
    }

    public boolean isApproved() {
        return "approved".equalsIgnoreCase(status);
    }

    public boolean isRejected() {
        return "rejected".equalsIgnoreCase(status);
    }
}
