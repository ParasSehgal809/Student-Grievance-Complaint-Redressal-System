package com.cms.dao;

import com.cms.model.AdminUser;
import com.cms.model.Complaint;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    // CREATE: Save new complaint
    public boolean createComplaint(Complaint c) {
        String sql = "INSERT INTO complaints (complaint_id, student_name, student_email, category, title, description, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getComplaintId());
            ps.setString(2, c.getStudentName());
            ps.setString(3, c.getStudentEmail());
            ps.setString(4, c.getCategory());
            ps.setString(5, c.getTitle());
            ps.setString(6, c.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ: Get Complaint by ID (Student tracking)
    public Complaint getByComplaintId(String complaintId) {
        String sql = "SELECT * FROM complaints WHERE complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // READ: Get All Complaints (Admin console)
    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE: Update status and administrative remarks
    public boolean updateStatusAndRemark(String complaintId, String status, String remark) {
        String sql = "UPDATE complaints SET status = ?, admin_remark = ? WHERE complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remark);
            ps.setString(3, complaintId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE: Delete complaint record
    public boolean deleteComplaint(String complaintId) {
        String sql = "DELETE FROM complaints WHERE complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, complaintId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // AUTH: Validate Administrator Login
    public AdminUser validateAdmin(String username, String password) {
        String sql = "SELECT id, username, full_name FROM admin_users WHERE username = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AdminUser(rs.getInt("id"), rs.getString("username"), rs.getString("full_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Complaint mapRow(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setComplaintId(rs.getString("complaint_id"));
        c.setStudentName(rs.getString("student_name"));
        c.setStudentEmail(rs.getString("student_email"));
        c.setCategory(rs.getString("category"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setAdminRemark(rs.getString("admin_remark"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
