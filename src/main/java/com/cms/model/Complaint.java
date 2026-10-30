package com.cms.model;

import java.sql.Timestamp;

public class Complaint {
    private int id;
    private String complaintId;
    private String studentName;
    private String studentEmail;
    private String category;
    private String title;
    private String description;
    private String status;        // Pending, In Progress, Resolved, Rejected
    private String adminRemark;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Complaint() {}

    public Complaint(String complaintId, String studentName, String studentEmail, 
                     String category, String title, String description) {
        this.complaintId = complaintId;
        this.studentName = studentName;
        this.studentEmail = studentEmail;
        this.category = category;
        this.title = title;
        this.description = description;
        this.status = "Pending";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getComplaintId() { return complaintId; }
    public void setComplaintId(String complaintId) { this.complaintId = complaintId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminRemark() { return adminRemark; }
    public void setAdminRemark(String adminRemark) { this.adminRemark = adminRemark; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
