package com.uninest.model;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private String roleName; // Role name as string (student, subject_coordinator, moderator, admin)
    private Integer organizationId;
    private Integer academicYear;
    private String university;

    public User() {}
    
    public User(int id, String email, String passwordHash, String roleName) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleName = roleName;
    }
    
    public User(int id, String email, String passwordHash, String roleName, Integer organizationId, Integer academicYear, String university) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleName = roleName;
        this.organizationId = organizationId;
        this.academicYear = academicYear;
        this.university = university;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getRole() { return roleName; }
    public void setRole(String roleName) { this.roleName = roleName; }
    
    // Helper methods for role checking
    public boolean isStudent() { return hasRole("student"); }
    public boolean isSubjectCoordinator() { return hasRole("subject_coordinator"); }
    public boolean isModerator() { return hasRole("moderator"); }
    public boolean isAdmin() { return hasRole("admin"); }
    
    public boolean hasRole(String r) { 
        return r != null && roleName != null && roleName.equalsIgnoreCase(r); 
    }
    
    public Integer getOrganizationId() { return organizationId; }
    public void setOrganizationId(Integer organizationId) { this.organizationId = organizationId; }
    
    public Integer getAcademicYear() { return academicYear; }
    public void setAcademicYear(Integer academicYear) { this.academicYear = academicYear; }
    
    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }
}
