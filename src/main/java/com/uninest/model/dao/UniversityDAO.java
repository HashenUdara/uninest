package com.uninest.model.dao;

import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UniversityDAO {

    public List<Map<String, Object>> findAll() {
        String sql = "SELECT id, name FROM universities ORDER BY name";
        List<Map<String, Object>> universities = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> university = new HashMap<>();
                university.put("id", rs.getInt("id"));
                university.put("name", rs.getString("name"));
                universities.add(university);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching universities", e);
        }
        return universities;
    }
}
