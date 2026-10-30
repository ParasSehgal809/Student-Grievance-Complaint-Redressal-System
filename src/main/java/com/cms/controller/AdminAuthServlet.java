package com.cms.controller;

import com.cms.dao.ComplaintDAO;
import com.cms.model.AdminUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin-auth")
public class AdminAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("login".equals(action)) {
            String u = req.getParameter("username");
            String p = req.getParameter("password");
            AdminUser admin = complaintDAO.validateAdmin(u, p);

            if (admin != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("adminUser", admin);
                resp.sendRedirect("admin/dashboard");
            } else {
                req.setAttribute("loginError", "Invalid username or password. (Hint: admin / admin123)");
                req.getRequestDispatcher("admin-login.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect("admin-login.jsp?loggedOut=true");
        } else {
            resp.sendRedirect("admin-login.jsp");
        }
    }
}
