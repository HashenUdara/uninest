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

    public boolean saveOrUpdate(GpaEntry entry) {
        // Uses ON DUPLICATE KEY UPDATE to handle UPSERT since we have a unique key on
        // (student, year, sem, course)
        String sql = "INSERT INTO gpa_entries (student_id, academic_year, semester, course_name, grade, credits) " +
                "VALUES (?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE grade = VALUES(grade), credits = VALUES(credits)";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, entry.getStudentId());
            ps.setInt(2, entry.getAcademicYear());
            ps.setInt(3, entry.getSemester());
            ps.setString(4, entry.getCourseName());
            ps.setString(5, entry.getGrade());
            ps.setInt(6, entry.getCredits());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // If inserted, we might want to get the ID, but for bulk save it's less
                // critical
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        entry.setId(keys.getInt(1));
                    }
                }
                return true;
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
