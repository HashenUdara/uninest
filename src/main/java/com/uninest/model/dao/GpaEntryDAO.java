package com.uninest.model.dao;

import com.uninest.model.GpaEntry;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GpaEntryDAO {

    private GpaEntry map(ResultSet rs) throws SQLException {
        GpaEntry entry = new GpaEntry();
        entry.setId(rs.getInt("id"));
        entry.setStudentId(rs.getInt("student_id"));
        entry.setAcademicYear(rs.getInt("academic_year"));
        entry.setSemester(rs.getInt("semester"));
        entry.setCourseName(rs.getString("course_name"));
        entry.setGrade(rs.getString("grade"));
        entry.setCredits(rs.getInt("credits"));
        entry.setCreatedAt(rs.getTimestamp("created_at"));
        entry.setUpdatedAt(rs.getTimestamp("updated_at"));
        return entry;
    }

    public List<GpaEntry> findByStudentYearSemester(int studentId, int year, int semester) {
        String sql = "SELECT * FROM gpa_entries WHERE student_id = ? AND academic_year = ? AND semester = ?";
        List<GpaEntry> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, year);
            ps.setInt(3, semester);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching GPA entries", e);
        }
        return list;
    }

    public List<GpaEntry> findAllByStudent(int studentId) {
        String sql = "SELECT * FROM gpa_entries WHERE student_id = ? ORDER BY academic_year, semester";
        List<GpaEntry> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching student GPA history", e);
        }
        return list;
    }

    public boolean saveOrUpdate(GpaEntry entry) {
        // Robust UPSERT logic: Check if exists, then UPDATE or INSERT
        // This handles cases where the UNIQUE constraint might be missing in the
        // database

        String checkSql = "SELECT id FROM gpa_entries WHERE student_id = ? AND academic_year = ? AND semester = ? AND course_name = ?";
        String updateSql = "UPDATE gpa_entries SET grade = ?, credits = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        String insertSql = "INSERT INTO gpa_entries (student_id, academic_year, semester, course_name, grade, credits) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            // 1. Check if exists
            int existingId = -1;
            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                checkPs.setInt(1, entry.getStudentId());
                checkPs.setInt(2, entry.getAcademicYear());
                checkPs.setInt(3, entry.getSemester());
                checkPs.setString(4, entry.getCourseName());

                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        existingId = rs.getInt("id");
                    }
                }
            }

            // 2. Update or Insert
            if (existingId != -1) {
                // UPDATE
                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                    updatePs.setString(1, entry.getGrade());
                    updatePs.setInt(2, entry.getCredits());
                    updatePs.setInt(3, existingId);

                    int rows = updatePs.executeUpdate();
                    if (rows > 0) {
                        entry.setId(existingId);
                        return true;
                    }
                }
            } else {
                // INSERT
                try (PreparedStatement insertPs = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertPs.setInt(1, entry.getStudentId());
                    insertPs.setInt(2, entry.getAcademicYear());
                    insertPs.setInt(3, entry.getSemester());
                    insertPs.setString(4, entry.getCourseName());
                    insertPs.setString(5, entry.getGrade());
                    insertPs.setInt(6, entry.getCredits());

                    int rows = insertPs.executeUpdate();
                    if (rows > 0) {
                        try (ResultSet keys = insertPs.getGeneratedKeys()) {
                            if (keys.next()) {
                                entry.setId(keys.getInt(1));
                            }
                        }
                        return true;
                    }
                }
            }
            return false;

        } catch (SQLException e) {
            throw new RuntimeException("Error saving GPA entry", e);
        }
    }

    public boolean deleteEntry(int id) {
        String sql = "DELETE FROM gpa_entries WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting GPA entry", e);
        }
    }
}
