<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - CMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 flex items-center justify-center min-h-screen p-4">
    <div class="max-w-md w-full bg-white rounded-2xl shadow-lg border border-slate-200 p-8 space-y-6">
        <div class="text-center">
            <div class="w-12 h-12 bg-indigo-50 text-indigo-600 rounded-2xl flex items-center justify-center mx-auto text-xl font-bold mb-3">🛡️</div>
            <h2 class="text-2xl font-bold text-gray-900">Admin Resolution Portal</h2>
            <p class="text-xs text-gray-500 mt-1">Manage and resolve registered student grievances</p>
        </div>

        <% if (request.getAttribute("loginError") != null) { %>
            <div class="bg-rose-50 border-l-4 border-rose-500 p-3 text-xs text-rose-700 rounded-lg">
                <%= request.getAttribute("loginError") %>
            </div>
        <% } %>
        <% if ("true".equals(request.getParameter("loggedOut"))) { %>
            <div class="bg-emerald-50 border-l-4 border-emerald-500 p-3 text-xs text-emerald-700 rounded-lg">
                You have been signed out successfully.
            </div>
        <% } %>

        <form action="admin-auth" method="POST" class="space-y-4 text-sm">
            <input type="hidden" name="action" value="login">
            <div>
                <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Username</label>
                <input type="text" name="username" value="admin" required 
                       class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
            </div>
            <div>
                <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Password</label>
                <input type="password" name="password" value="admin123" required 
                       class="w-full p-2.5 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none">
            </div>
            <div class="text-xs text-gray-500 bg-slate-50 p-2.5 rounded-lg border">
                Default credentials: <strong class="text-indigo-600">admin / admin123</strong>
            </div>
            <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 rounded-xl transition shadow-md shadow-indigo-600/20">
                Sign In to Admin Session
            </button>
        </form>

        <div class="text-center">
            <a href="index.jsp" class="text-xs text-indigo-600 hover:underline">&larr; Back to Student Portal</a>
        </div>
    </div>
</body>
</html>
