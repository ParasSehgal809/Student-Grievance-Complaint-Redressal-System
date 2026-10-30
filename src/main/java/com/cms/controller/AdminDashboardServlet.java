package com.cms.controller;

import com.cms.dao.ComplaintDAO;
import com.cms.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect("../admin-login.jsp?error=unauthorized");
            return;
        }

        List<Complaint> complaints = complaintDAO.getAllComplaints();

        // Calculate dynamic dashboard KPIs
        long total = complaints.size();
        long pending = complaints.stream().filter(c -> "Pending".equalsIgnoreCase(c.getStatus())).count();
        long inProgress = complaints.stream().filter(c -> "In Progress".equalsIgnoreCase(c.getStatus())).count();
        long resolved = complaints.stream().filter(c -> "Resolved".equalsIgnoreCase(c.getStatus())).count();

        req.setAttribute("complaints", complaints);
        req.setAttribute("totalCount", total);
        req.setAttribute("pendingCount", pending);
        req.setAttribute("inProgressCount", inProgress);
        req.setAttribute("resolvedCount", resolved);

        req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect("../admin-login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String complaintId = req.getParameter("complaintId");

        if ("update".equals(action)) {
            String status = req.getParameter("status");
            String remark = req.getParameter("adminRemark");
            complaintDAO.updateStatusAndRemark(complaintId, status, remark);
        } else if ("delete".equals(action)) {
            complaintDAO.deleteComplaint(complaintId);
        }

        resp.sendRedirect("dashboard");
    }
}
