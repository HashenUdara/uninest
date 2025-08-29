package com.uninest.model;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private boolean enabled;
    private Set<String> roles = new HashSet<>();

    public User() {}

    public User(int id, String email, String passwordHash, boolean enabled, Set<String> roles) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.enabled = enabled;
        if (roles != null) this.roles.addAll(roles);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    public Set<String> getRoles() { return Collections.unmodifiableSet(roles); }
    public void setRoles(Set<String> roles) { this.roles = new HashSet<>(roles); }
    public void addRole(String role) { this.roles.add(role); }
}
