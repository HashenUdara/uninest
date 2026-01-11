package com.uninest.model.dao;

import com.uninest.model.PostReport;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for community post reports.
 */
public class PostReportDAO {

    public void createReport(PostReport report) {
        String sql = "INSERT INTO community_post_reports (post_id, reporter_user_id, reason, status) VALUES (?, ?, ?, 'pending')";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, report.getPostId());
            ps.setInt(2, report.getReporterUserId());
            ps.setString(3, report.getReason());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating report", e);
        }
    }

    public boolean hasUserReported(int postId, int userId) {
        String sql = "SELECT id FROM community_post_reports WHERE post_id = ? AND reporter_user_id = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking existing report", e);
        }
    }

    public int getReportCount(int postId) {
        String sql = "SELECT COUNT(*) FROM community_post_reports WHERE post_id = ? AND status = 'pending'";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting reports", e);
        }
        return 0;
    }

    public List<PostReport> findReportsByPostId(int postId) {
        String sql = "SELECT r.*, u.fullname as reporter_name " +
                "FROM community_post_reports r " +
                "JOIN users u ON r.reporter_user_id = u.id " +
                "WHERE r.post_id = ? ORDER BY r.created_at DESC";
        List<PostReport> reports = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PostReport report = new PostReport();
                    report.setId(rs.getInt("id"));
                    report.setPostId(rs.getInt("post_id"));
                    report.setReporterUserId(rs.getInt("reporter_user_id"));
                    report.setReason(rs.getString("reason"));
                    report.setStatus(rs.getString("status"));
                    report.setCreatedAt(rs.getTimestamp("created_at"));
                    report.setReporterName(rs.getString("reporter_name"));
                    reports.add(report);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching reports", e);
        }
        return reports;
    }

    public void dismissReportsForPost(int postId, int reviewerId) {
        String sql = "UPDATE community_post_reports SET status = 'dismissed', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP WHERE post_id = ? AND status = 'pending'";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setInt(2, postId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error dismissing reports", e);
        }
    }
}
