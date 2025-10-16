package com.uninest.model;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private String roleName; // Role name as string (student, subject_coordinator, moderator, admin)
    private boolean isApproved;
    private Integer academicYear;
    private Integer universityId;
    private String universityName;

    public User() {}
    
    public User(int id, String email, String passwordHash, String roleName) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleName = roleName;
        this.isApproved = true;
    }
    
    public User(int id, String email, String passwordHash, String roleName, boolean isApproved, 
                Integer academicYear, Integer universityId, String universityName) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleName = roleName;
        this.isApproved = isApproved;
        this.academicYear = academicYear;
        this.universityId = universityId;
        this.universityName = universityName;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getRole() { return roleName; }
    public void setRole(String roleName) { this.roleName = roleName; }
    
    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }
    
    public Integer getAcademicYear() { return academicYear; }
    public void setAcademicYear(Integer academicYear) { this.academicYear = academicYear; }
    
    public Integer getUniversityId() { return universityId; }
    public void setUniversityId(Integer universityId) { this.universityId = universityId; }
    
    public String getUniversityName() { return universityName; }
    public void setUniversityName(String universityName) { this.universityName = universityName; }
    
    // Helper methods for role checking
    public boolean isStudent() { return hasRole("student"); }
    public boolean isSubjectCoordinator() { return hasRole("subject_coordinator"); }
    public boolean isModerator() { return hasRole("moderator"); }
    public boolean isAdmin() { return hasRole("admin"); }
    
    public boolean hasRole(String r) { 
        return r != null && roleName != null && roleName.equalsIgnoreCase(r); 
    }
}
