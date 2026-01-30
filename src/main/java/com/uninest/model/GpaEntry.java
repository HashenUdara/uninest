package com.uninest.model;

import java.sql.Timestamp;

public class GpaEntry {
    private int id;
    private int studentId;
    private int academicYear;
    private int semester;
    private String courseName;
    private String grade;
    private int credits;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public GpaEntry() {
    }

    public GpaEntry(int studentId, int academicYear, int semester, String courseName, String grade, int credits) {
        this.studentId = studentId;
        this.academicYear = academicYear;
        this.semester = semester;
        this.courseName = courseName;
        this.grade = grade;
        this.credits = credits;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(int academicYear) {
        this.academicYear = academicYear;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
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
}
