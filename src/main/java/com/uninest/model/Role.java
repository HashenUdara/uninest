package com.uninest.model;

/**
 * Represents a role in the system with hierarchical inheritance support.
 * Roles: student, subject_coordinator, moderator, admin
 */
public class Role {
    private int id;
    private String name;
    private String description;
    private Integer inheritsFrom;

    public Role() {}

    public Role(int id, String name, String description, Integer inheritsFrom) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.inheritsFrom = inheritsFrom;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Integer getInheritsFrom() { return inheritsFrom; }
    public void setInheritsFrom(Integer inheritsFrom) { this.inheritsFrom = inheritsFrom; }
    
    @Override
    public String toString() { return name; }
}
