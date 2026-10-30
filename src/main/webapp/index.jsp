<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cms.model.Complaint" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Complaint Management Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-gray-800 p-4 md:p-6 font-sans">
    <div class="max-w-6xl mx-auto space-y-6">

        <!-- Top Header Banner -->
        <div class="bg-indigo-900 text-white p-6 rounded-2xl shadow-lg flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <h1 class="text-2xl md:text-3xl font-extrabold tracking-tight">Student Grievance & Complaint Redressal</h1>
                <p class="text-indigo-200 text-xs md:text-sm mt-1">Submit issues, obtain unique complaint IDs, and track real-time resolution status.</p>
            </div>
            <a href="admin-login.jsp" class="bg-indigo-700 hover:bg-indigo-600 px-4 py-2.5 rounded-xl text-xs font-semibold transition border border-indigo-500/30">
                Admin Portal Login &rarr;
            </a>
        </div>

        <%-- Notification alerts --%>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-xl shadow-sm text-emerald-800 text-sm font-medium">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-rose-50 border-l-4 border-rose-500 p-4 rounded-xl shadow-sm text-rose-800 text-sm font-medium">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            
            <!-- Section 1: Complaint Submission Form (Servlet POST) -->
            <div class="lg:col-span-7 bg-white p-6 rounded-2xl shadow border border-slate-200">
                <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Submit a New Complaint</h2>
                <form action="complaint" method="POST" class="space-y-4 text-sm">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Student Name</label>
                            <input type="text" name="studentName" placeholder="e.g. Rahul Sharma" required 
                                   class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Student Email</label>
                            <input type="email" name="studentEmail" placeholder="rahul@university.edu" required 
                                   class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Category</label>
                            <select name="category" class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
                                <option value="Academic">Academic & Faculty</option>
                                <option value="Hostel">Hostel & Mess</option>
                                <option value="Infrastructure">Infrastructure & Labs</option>
                                <option value="Accounts">Fee & Scholarship</option>
                                <option value="Library">Library & Resources</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Subject / Title</label>
                            <input type="text" name="title" placeholder="Brief summary of your grievance" required 
                                   class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Detailed Description</label>
                        <textarea name="description" rows="4" placeholder="Elaborate your complaint clearly..." required 
                                  class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none"></textarea>
                    </div>

                    <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 rounded-xl transition shadow-md shadow-indigo-600/20">
                        Submit Grievance
                    </button>
                </form>
            </div>

            <!-- Section 2: Live Status Tracking (Servlet GET) -->
            <div class="lg:col-span-5 space-y-6">
                <div class="bg-white p-6 rounded-2xl shadow border border-slate-200">
                    <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Track Existing Complaint</h2>
                    <form action="complaint" method="GET" class="flex gap-2">
                        <input type="hidden" name="action" value="track">
                        <input type="text" name="complaintId" placeholder="Complaint ID (e.g. CMP-1001)" 
                               value="<%= request.getAttribute("searchedId") != null ? request.getAttribute("searchedId") : "" %>" required
                               class="flex-1 p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none text-sm">
                        <button type="submit" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-2.5 rounded-xl font-medium text-sm">
                            Search
                        </button>
                    </form>
                </div>

                <% 
                    Complaint tracked = (Complaint) request.getAttribute("trackedComplaint");
                    if (tracked != null) { 
                %>
                    <div class="bg-white p-6 rounded-2xl shadow border-l-4 
                        <%= "Resolved".equalsIgnoreCase(tracked.getStatus()) ? "border-emerald-500" : 
                            "In Progress".equalsIgnoreCase(tracked.getStatus()) ? "border-blue-500" : "border-amber-500" %>">
                        <div class="flex justify-between items-start mb-3">
                            <span class="text-xs font-bold uppercase tracking-wider text-gray-400">Tracking Result</span>
                            <span class="px-3 py-1 rounded-full text-xs font-bold 
                                <%= "Resolved".equalsIgnoreCase(tracked.getStatus()) ? "bg-emerald-100 text-emerald-800" :
                                    "In Progress".equalsIgnoreCase(tracked.getStatus()) ? "bg-blue-100 text-blue-800" : "bg-amber-100 text-amber-800" %>">
                                <%= tracked.getStatus() %>
                            </span>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900"><%= tracked.getTitle() %></h3>
                        <p class="text-xs text-gray-500 mb-4">ID: <%= tracked.getComplaintId() %> | Category: <%= tracked.getCategory() %></p>
                        
                        <div class="space-y-3 text-sm">
                            <div>
                                <strong class="text-gray-700">Description:</strong>
                                <p class="text-gray-600 bg-slate-50 p-3 rounded-xl mt-1"><%= tracked.getDescription() %></p>
                            </div>
                            <div>
                                <strong class="text-gray-700">Administrator Remark / Resolution:</strong>
                                <p class="text-indigo-900 bg-indigo-50 p-3 rounded-xl mt-1 italic font-medium">
                                    <%= tracked.getAdminRemark() != null ? tracked.getAdminRemark() : "Under review by the department." %>
                                </p>
                            </div>
                            <div class="text-xs text-gray-400">
                                Lodged on: <%= tracked.getCreatedAt() %>
                            </div>
                        </div>
                    </div>
                <% } else if (request.getAttribute("searchedId") != null) { %>
                    <div class="bg-rose-50 border border-rose-200 text-rose-700 p-4 rounded-2xl text-center text-sm">
                        No grievance record found matching ID: <strong><%= request.getAttribute("searchedId") %></strong>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</body>
</html>
