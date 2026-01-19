package com.uninest.model;

public class User {
    private int id;
    private String email;
    private String firstName;
    private String lastName;
    private String passwordHash;
    private String roleName; // Role name as string (student, moderator, admin)
    private Integer communityId; // null until student joins or moderator's community approved
    private String communityName; // Community title for display
    private Integer academicYear; // 1..4
    private Integer universityId; // Foreign key to universities table
    private String universityName; // University name for display
    private String universityIdNumber; // Student/Staff ID (e.g., 2013/CS/025)
    private String faculty; // Faculty name (e.g., Faculty of Arts)
    private String phoneNumber;

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
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    // Compatibility method for existing views
    public String getName() { 
        if (firstName == null && lastName == null) return "";
        if (firstName == null) return lastName;
        if (lastName == null) return firstName;
        return firstName + " " + lastName; 
    }
    
    // Explicit setter removed favor of setFirstName/setLastName
    // If needed for legacy mapping, can parse, but better to fix call sites.
    @Deprecated
    public void setName(String name) {
        if (name == null) {
            this.firstName = null;
            this.lastName = null;
            return;
        }
        int idx = name.lastIndexOf(' ');
        if (idx == -1) {
            this.firstName = name;
            this.lastName = "";
        } else {
            this.firstName = name.substring(0, idx);
            this.lastName = name.substring(idx + 1);
        }
    }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getRole() { return roleName; }
    public void setRole(String roleName) { this.roleName = roleName; }
    
    // Helper methods for role checking
    public boolean isStudent() { return hasRole("student"); }
    public boolean isModerator() { return hasRole("moderator"); }
    public boolean isAdmin() { return hasRole("admin"); }
    
    // Subject coordinator is not a role - check subject_coordinators table using SubjectCoordinatorDAO
    @Deprecated
    public boolean isSubjectCoordinator() { 
        return false; // Always false - use SubjectCoordinatorDAO.isCoordinator(userId) instead
    }
    
    public boolean hasRole(String r) { 
        return r != null && roleName != null && roleName.equalsIgnoreCase(r); 
    }

    public Integer getCommunityId() { return communityId; }
    public void setCommunityId(Integer communityId) { this.communityId = communityId; }

    public String getCommunityName() { return communityName; }
    public void setCommunityName(String communityName) { this.communityName = communityName; }

    public Integer getAcademicYear() { return academicYear; }
    public void setAcademicYear(Integer academicYear) { this.academicYear = academicYear; }

    public Integer getUniversityId() { return universityId; }
    public void setUniversityId(Integer universityId) { this.universityId = universityId; }

    public String getUniversityName() { return universityName; }
    public void setUniversityName(String universityName) { this.universityName = universityName; }

    public String getUniversityIdNumber() { return universityIdNumber; }
    public void setUniversityIdNumber(String universityIdNumber) { this.universityIdNumber = universityIdNumber; }

    public String getFaculty() { return faculty; }
    public void setFaculty(String faculty) { this.faculty = faculty; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
}
