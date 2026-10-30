package com.cms.controller;

import com.cms.dao.ComplaintDAO;
import com.cms.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("track".equals(action)) {
            String cid = req.getParameter("complaintId");
            Complaint found = complaintDAO.getByComplaintId(cid != null ? cid.trim() : "");
            req.setAttribute("trackedComplaint", found);
            req.setAttribute("searchedId", cid);
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Auto-generate Complaint ID e.g., CMP-5821
        String generatedId = "CMP-" + (1000 + new Random().nextInt(9000));

        Complaint complaint = new Complaint(
            generatedId,
            req.getParameter("studentName"),
            req.getParameter("studentEmail"),
            req.getParameter("category"),
            req.getParameter("title"),
            req.getParameter("description")
        );

        boolean success = complaintDAO.createComplaint(complaint);
        if (success) {
            req.setAttribute("successMessage", "Grievance registered successfully! Your tracking ID is: " + generatedId);
            req.setAttribute("newComplaintId", generatedId);
        } else {
            req.setAttribute("errorMessage", "Error submitting grievance. Please check your inputs.");
        }

        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }
}
