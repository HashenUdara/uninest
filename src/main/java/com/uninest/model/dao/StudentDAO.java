package com.uninest.model.dao;

import com.uninest.model.Student;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC DAO for Student entity.
 */
public class StudentDAO {

    public List<Student> findAll() {
        String sql = "SELECT id, name, email FROM student ORDER BY id";
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error loading students", e);
        }
        return list;
    }

    public Student findById(int id) {
        String sql = "SELECT id, name, email FROM student WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding student " + id, e);
        }
    }

    public Student save(Student s) {
        if (s.getId() == 0) {
            return insert(s);
        } else {
            return update(s);
        }
    }

    private Student insert(Student s) {
        String sql = "INSERT INTO student(name, email) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    s.setId(keys.getInt(1));
                }
            }
            return s;
        } catch (SQLException e) {
            throw new RuntimeException("Error inserting student", e);
        }
    }

    private Student update(Student s) {
        String sql = "UPDATE student SET name = ?, email = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setInt(3, s.getId());
            ps.executeUpdate();
            return s;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating student " + s.getId(), e);
        }
    }

    private Student map(ResultSet rs) throws SQLException {
        return new Student(rs.getInt("id"), rs.getString("name"), rs.getString("email"));
    }
}
