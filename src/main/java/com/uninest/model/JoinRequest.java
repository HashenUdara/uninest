package com.uninest.model;

import java.sql.Timestamp;

public class JoinRequest {
    private int id;
    private int userId;
    private String userName;
    private String userEmail;
    private Integer userAcademicYear;
    private String universityName;
    private int communityId;
    private String communityTitle;
    private String status; // pending, approved, rejected
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private Integer processedByUserId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public Integer getUserAcademicYear() { return userAcademicYear; }
    public void setUserAcademicYear(Integer userAcademicYear) { this.userAcademicYear = userAcademicYear; }

    public String getUniversityName() { return universityName; }
    public void setUniversityName(String universityName) { this.universityName = universityName; }

    public int getCommunityId() { return communityId; }
    public void setCommunityId(int communityId) { this.communityId = communityId; }

    public String getCommunityTitle() { return communityTitle; }
    public void setCommunityTitle(String communityTitle) { this.communityTitle = communityTitle; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRequestedAt() { return requestedAt; }
    public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }

    public Integer getProcessedByUserId() { return processedByUserId; }
    public void setProcessedByUserId(Integer processedByUserId) { this.processedByUserId = processedByUserId; }
}
