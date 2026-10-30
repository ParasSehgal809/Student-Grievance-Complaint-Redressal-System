<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cms.model.Complaint" %>
<%@ page import="com.cms.model.AdminUser" %>
<%
    AdminUser currentAdmin = (AdminUser) session.getAttribute("adminUser");
    if (currentAdmin == null) {
        response.sendRedirect("../admin-login.jsp");
        return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-gray-800 p-4 md:p-6 font-sans">
    <div class="max-w-7xl mx-auto space-y-6">

        <!-- Top Header & Session Bar -->
        <div class="bg-indigo-900 text-white p-6 rounded-2xl shadow-lg flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <h1 class="text-2xl font-bold">Admin Resolution Control Panel</h1>
                <p class="text-indigo-200 text-xs md:text-sm mt-0.5">
                    Logged in as: <strong><%= currentAdmin.getFullName() %></strong> (<%= currentAdmin.getUsername() %>)
                </p>
            </div>
            <a href="../admin-auth?action=logout" class="bg-rose-600 hover:bg-rose-700 text-white px-4 py-2 rounded-xl text-xs font-semibold transition">
                Sign Out Session
            </a>
        </div>

        <!-- Metric KPI Cards -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <span class="text-xs uppercase font-bold text-gray-400">Total Registered</span>
                <p class="text-2xl md:text-3xl font-extrabold text-indigo-600 mt-1"><%= request.getAttribute("totalCount") %></p>
            </div>
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <span class="text-xs uppercase font-bold text-gray-400">Pending Review</span>
                <p class="text-2xl md:text-3xl font-extrabold text-amber-500 mt-1"><%= request.getAttribute("pendingCount") %></p>
            </div>
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <span class="text-xs uppercase font-bold text-gray-400">In Progress</span>
                <p class="text-2xl md:text-3xl font-extrabold text-blue-500 mt-1"><%= request.getAttribute("inProgressCount") %></p>
            </div>
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <span class="text-xs uppercase font-bold text-gray-400">Resolved</span>
                <p class="text-2xl md:text-3xl font-extrabold text-emerald-600 mt-1"><%= request.getAttribute("resolvedCount") %></p>
            </div>
        </div>

        <!-- Complaints CRUD Table -->
        <div class="bg-white rounded-2xl shadow border border-slate-200 overflow-hidden">
            <div class="p-5 border-b border-slate-200 flex justify-between items-center">
                <h2 class="text-lg font-bold text-gray-900">Registered Student Grievances</h2>
                <span class="text-xs text-gray-400">CRUD: Update Status / Add Remark / Delete</span>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left text-xs border-collapse">
                    <thead class="bg-slate-50 text-slate-600 uppercase font-semibold">
                        <tr>
                            <th class="p-3.5 border-b">ID</th>
                            <th class="p-3.5 border-b">Student</th>
                            <th class="p-3.5 border-b">Category & Subject</th>
                            <th class="p-3.5 border-b">Status</th>
                            <th class="p-3.5 border-b">Update Status & Remark</th>
                            <th class="p-3.5 border-b text-right">Delete</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <% if (complaints != null && !complaints.isEmpty()) { 
                            for (Complaint c : complaints) { %>
                            <tr class="hover:bg-slate-50 transition">
                                <td class="p-3.5 font-mono font-bold text-indigo-700 whitespace-nowrap"><%= c.getComplaintId() %></td>
                                <td class="p-3.5">
                                    <div class="font-semibold text-gray-900"><%= c.getStudentName() %></div>
                                    <div class="text-gray-400 text-[11px]"><%= c.getStudentEmail() %></div>
                                </td>
                                <td class="p-3.5 max-w-xs">
                                    <span class="text-[10px] font-semibold px-2 py-0.5 rounded bg-slate-100 text-slate-700"><%= c.getCategory() %></span>
                                    <div class="font-medium text-gray-800 mt-1"><%= c.getTitle() %></div>
                                    <p class="text-gray-500 truncate text-[11px]"><%= c.getDescription() %></p>
                                </td>
                                <td class="p-3.5 whitespace-nowrap">
                                    <span class="px-2.5 py-1 rounded-full text-[11px] font-bold 
                                        <%= "Resolved".equalsIgnoreCase(c.getStatus()) ? "bg-emerald-100 text-emerald-800" :
                                            "In Progress".equalsIgnoreCase(c.getStatus()) ? "bg-blue-100 text-blue-800" :
                                            "Rejected".equalsIgnoreCase(c.getStatus()) ? "bg-rose-100 text-rose-800" : "bg-amber-100 text-amber-800" %>">
                                        <%= c.getStatus() %>
                                    </span>
                                </td>
                                <td class="p-3.5">
                                    <!-- Inline Status & Remark Update Form -->
                                    <form action="dashboard" method="POST" class="flex flex-col gap-1.5 min-w-[220px]">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                        <div class="flex gap-2">
                                            <select name="status" class="text-xs border rounded-lg p-1 bg-white outline-none">
                                                <option value="Pending" <%= "Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                                <option value="In Progress" <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                                                <option value="Resolved" <%= "Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                                                <option value="Rejected" <%= "Rejected".equals(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                            </select>
                                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs px-2.5 py-1 rounded-lg font-semibold transition">
                                                Save
                                            </button>
                                        </div>
                                        <input type="text" name="adminRemark" placeholder="Resolution remark..." 
                                               value="<%= c.getAdminRemark() != null ? c.getAdminRemark() : "" %>"
                                               class="text-xs border rounded-lg p-1.5 w-full outline-none">
                                    </form>
                                </td>
                                <td class="p-3.5 text-right">
                                    <!-- Delete Record Form -->
                                    <form action="dashboard" method="POST" onsubmit="return confirm('Delete complaint <%= c.getComplaintId() %>?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                        <button type="submit" class="text-rose-600 hover:text-rose-800 text-xs font-semibold hover:underline">
                                            Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <%  } 
                           } else { %>
                            <tr>
                                <td colspan="6" class="p-6 text-center text-gray-400">No complaints logged yet.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
