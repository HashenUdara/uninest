package com.uninest.model;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private String roleName; // Role name as string (student, subject_coordinator, moderator, admin)

    public User() {}
    
    public User(int id, String email, String passwordHash, String roleName) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleName = roleName;
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
}
