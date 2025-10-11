package com.uninest.model;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private Role role; // ENUM based role

    public User() {}
    public User(int id, String email, String passwordHash, String role) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role == null ? null : Role.valueOf(role.toUpperCase());
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
    public boolean isAdmin() { return hasRole(Role.ADMIN); }
    public boolean isManager() { return hasRole(Role.MANAGER); }
    public boolean isStaff() { return hasRole(Role.STAFF); }
    public boolean hasRole(Role r) { return r != null && r == role; }
    public boolean hasRole(String r) { return r != null && role != null && role.name().equalsIgnoreCase(r); }
}
