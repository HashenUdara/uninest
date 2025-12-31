package com.uninest.model.dao;

import com.uninest.model.ResourceCategory;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ResourceCategoryDAO {

    private ResourceCategory map(ResultSet rs) throws SQLException {
        ResourceCategory category = new ResourceCategory();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        return category;
    }

    public List<ResourceCategory> findAll() {
        String sql = "SELECT * FROM resource_categories ORDER BY category_name";
        List<ResourceCategory> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resource categories", e);
        }
        return list;
    }

    public Optional<ResourceCategory> findById(int categoryId) {
        String sql = "SELECT * FROM resource_categories WHERE category_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resource category", e);
        }
        return Optional.empty();
    }

    public Optional<ResourceCategory> findByName(String categoryName) {
        String sql = "SELECT * FROM resource_categories WHERE category_name = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resource category by name", e);
        }
        return Optional.empty();
    }
}
