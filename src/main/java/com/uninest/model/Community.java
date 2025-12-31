package com.uninest.model;

import java.sql.Timestamp;

public class Community {
    private int id;
    private String title;
    private String description;
    private int createdByUserId;
    private String status; // pending, approved, rejected
    private boolean approved;
    private Timestamp approvedAt;
    private Integer approvedByUserId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(int createdByUserId) { this.createdByUserId = createdByUserId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isApproved() { return approved; }
    public void setApproved(boolean approved) { this.approved = approved; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

    public Integer getApprovedByUserId() { return approvedByUserId; }
    public void setApprovedByUserId(Integer approvedByUserId) { this.approvedByUserId = approvedByUserId; }
}
