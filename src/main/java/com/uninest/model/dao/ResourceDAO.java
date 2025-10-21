package com.uninest.model.dao;

import com.uninest.model.Resource;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ResourceDAO {

    private Resource map(ResultSet rs) throws SQLException {
        Resource resource = new Resource();
        resource.setResourceId(rs.getInt("resource_id"));
        resource.setTopicId(rs.getInt("topic_id"));
        resource.setUploadedBy(rs.getInt("uploaded_by"));
        resource.setCategoryId(rs.getInt("category_id"));
        resource.setTitle(rs.getString("title"));
        resource.setDescription(rs.getString("description"));
        resource.setFileUrl(rs.getString("file_url"));
        resource.setFileType(rs.getString("file_type"));
        resource.setUploadDate(rs.getTimestamp("upload_date"));
        resource.setStatus(rs.getString("status"));
        resource.setVisibility(rs.getString("visibility"));
        
        try {
            int approvedBy = rs.getInt("approved_by");
            resource.setApprovedBy(rs.wasNull() ? null : approvedBy);
        } catch (SQLException e) {}
        
        try {
            resource.setApprovalDate(rs.getTimestamp("approval_date"));
        } catch (SQLException e) {}
        
        // Optional joined fields
        try { resource.setUploaderName(rs.getString("uploader_name")); } catch (SQLException e) {}
        try { resource.setUploaderEmail(rs.getString("uploader_email")); } catch (SQLException e) {}
        try { resource.setTopicName(rs.getString("topic_title")); } catch (SQLException e) {}
        try { resource.setSubjectName(rs.getString("subject_name")); } catch (SQLException e) {}
        try { resource.setSubjectCode(rs.getString("subject_code")); } catch (SQLException e) {}
        try { resource.setCategoryName(rs.getString("category_name")); } catch (SQLException e) {}
        try { resource.setApproverName(rs.getString("approver_name")); } catch (SQLException e) {}
        
        return resource;
    }

    public Optional<Resource> findById(int resourceId) {
        String sql = "SELECT r.*, " +
                "u.name AS uploader_name, u.email AS uploader_email, " +
                "t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, " +
                "rc.category_name, a.name AS approver_name " +
                "FROM resources r " +
                "JOIN users u ON r.uploaded_by = u.id " +
                "JOIN topics t ON r.topic_id = t.topic_id " +
                "JOIN subjects s ON t.subject_id = s.subject_id " +
                "JOIN resource_categories rc ON r.category_id = rc.category_id " +
                "LEFT JOIN users a ON r.approved_by = a.id " +
                "WHERE r.resource_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resource", e);
        }
        return Optional.empty();
    }

    public List<Resource> findByUserId(int userId) {
        String sql = "SELECT r.*, " +
                "u.name AS uploader_name, u.email AS uploader_email, " +
                "t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, " +
                "rc.category_name, a.name AS approver_name " +
                "FROM resources r " +
                "JOIN users u ON r.uploaded_by = u.id " +
                "JOIN topics t ON r.topic_id = t.topic_id " +
                "JOIN subjects s ON t.subject_id = s.subject_id " +
                "JOIN resource_categories rc ON r.category_id = rc.category_id " +
                "LEFT JOIN users a ON r.approved_by = a.id " +
                "WHERE r.uploaded_by = ? " +
                "ORDER BY r.upload_date DESC";
        List<Resource> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resources by user", e);
        }
        return list;
    }

    public List<Resource> findByUserIdAndCategory(int userId, int categoryId) {
        String sql = "SELECT r.*, " +
                "u.name AS uploader_name, u.email AS uploader_email, " +
                "t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, " +
                "rc.category_name, a.name AS approver_name " +
                "FROM resources r " +
                "JOIN users u ON r.uploaded_by = u.id " +
                "JOIN topics t ON r.topic_id = t.topic_id " +
                "JOIN subjects s ON t.subject_id = s.subject_id " +
                "JOIN resource_categories rc ON r.category_id = rc.category_id " +
                "LEFT JOIN users a ON r.approved_by = a.id " +
                "WHERE r.uploaded_by = ? AND r.category_id = ? " +
                "ORDER BY r.upload_date DESC";
        List<Resource> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resources by user and category", e);
        }
        return list;
    }

    public List<Resource> findPendingBySubjectIds(List<Integer> subjectIds) {
        if (subjectIds == null || subjectIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, ");
        sql.append("u.name AS uploader_name, u.email AS uploader_email, ");
        sql.append("t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, ");
        sql.append("rc.category_name, a.name AS approver_name ");
        sql.append("FROM resources r ");
        sql.append("JOIN users u ON r.uploaded_by = u.id ");
        sql.append("JOIN topics t ON r.topic_id = t.topic_id ");
        sql.append("JOIN subjects s ON t.subject_id = s.subject_id ");
        sql.append("JOIN resource_categories rc ON r.category_id = rc.category_id ");
        sql.append("LEFT JOIN users a ON r.approved_by = a.id ");
        sql.append("WHERE r.status = 'pending' AND s.subject_id IN (");
        
        for (int i = 0; i < subjectIds.size(); i++) {
            sql.append("?");
            if (i < subjectIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY r.upload_date DESC");
        
        List<Resource> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < subjectIds.size(); i++) {
                ps.setInt(i + 1, subjectIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching pending resources", e);
        }
        return list;
    }

    public int create(Resource resource) {
        String sql = "INSERT INTO resources(topic_id, uploaded_by, category_id, title, description, file_url, file_type, status, visibility) " +
                "VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, resource.getTopicId());
            ps.setInt(2, resource.getUploadedBy());
            ps.setInt(3, resource.getCategoryId());
            ps.setString(4, resource.getTitle());
            ps.setString(5, resource.getDescription());
            ps.setString(6, resource.getFileUrl());
            ps.setString(7, resource.getFileType());
            ps.setString(8, resource.getStatus() != null ? resource.getStatus() : "pending");
            ps.setString(9, resource.getVisibility() != null ? resource.getVisibility() : "private");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    resource.setResourceId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating resource", e);
        }
        return 0;
    }

    public boolean approve(int resourceId, int approverId) {
        String sql = "UPDATE resources SET status = 'approved', approved_by = ?, approval_date = CURRENT_TIMESTAMP, visibility = 'public' " +
                "WHERE resource_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, approverId);
            ps.setInt(2, resourceId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error approving resource", e);
        }
    }

    public boolean reject(int resourceId, int approverId) {
        String sql = "UPDATE resources SET status = 'rejected', approved_by = ?, approval_date = CURRENT_TIMESTAMP " +
                "WHERE resource_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, approverId);
            ps.setInt(2, resourceId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error rejecting resource", e);
        }
    }

    public boolean delete(int resourceId) {
        String sql = "DELETE FROM resources WHERE resource_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting resource", e);
        }
    }

    public List<Resource> findByTopicId(int topicId) {
        String sql = "SELECT r.*, " +
                "u.name AS uploader_name, u.email AS uploader_email, " +
                "t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, " +
                "rc.category_name, a.name AS approver_name " +
                "FROM resources r " +
                "JOIN users u ON r.uploaded_by = u.id " +
                "JOIN topics t ON r.topic_id = t.topic_id " +
                "JOIN subjects s ON t.subject_id = s.subject_id " +
                "JOIN resource_categories rc ON r.category_id = rc.category_id " +
                "LEFT JOIN users a ON r.approved_by = a.id " +
                "WHERE r.topic_id = ? AND r.status = 'approved' AND r.visibility = 'public' " +
                "ORDER BY r.upload_date DESC";
        List<Resource> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resources by topic", e);
        }
        return list;
    }

    public List<Resource> findByTopicIdAndCategory(int topicId, int categoryId) {
        String sql = "SELECT r.*, " +
                "u.name AS uploader_name, u.email AS uploader_email, " +
                "t.title AS topic_title, s.name AS subject_name, s.code AS subject_code, " +
                "rc.category_name, a.name AS approver_name " +
                "FROM resources r " +
                "JOIN users u ON r.uploaded_by = u.id " +
                "JOIN topics t ON r.topic_id = t.topic_id " +
                "JOIN subjects s ON t.subject_id = s.subject_id " +
                "JOIN resource_categories rc ON r.category_id = rc.category_id " +
                "LEFT JOIN users a ON r.approved_by = a.id " +
                "WHERE r.topic_id = ? AND r.category_id = ? AND r.status = 'approved' AND r.visibility = 'public' " +
                "ORDER BY r.upload_date DESC";
        List<Resource> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topicId);
            ps.setInt(2, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching resources by topic and category", e);
        }
        return list;
    }
}
