package com.uninest.model.dao;

import com.uninest.model.University;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UniversityDAO {

    public List<University> findAll() {
        String sql = "SELECT id, name FROM universities ORDER BY name ASC";
        List<University> universities = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                universities.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching universities", e);
        }
        return universities;
    }

    public Optional<University> findById(int id) {
        String sql = "SELECT id, name FROM universities WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching university by id", e);
        }
        return Optional.empty();
    }

    public Optional<University> findByName(String name) {
        String sql = "SELECT id, name FROM universities WHERE name = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching university by name", e);
        }
        return Optional.empty();
    }

    private University map(ResultSet rs) throws SQLException {
        return new University(
            rs.getInt("id"),
            rs.getString("name")
        );
    }
}
