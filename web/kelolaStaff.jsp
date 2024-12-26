<%-- 
    Document   : kelolaStaff
    Created on : 4 Dec 2024, 11.31.49
    Author     : nbpav
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="JDBC.jdbc"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.reset(); // Hapus output buffer
        response.sendRedirect("LOGINpage.jsp?error=You must log in first.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f7f9fc;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
            background: linear-gradient(90deg, #4b6cb7, #182848); 
            color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 28px;
        }
        .content {
            margin-top: 100px;
            text-align: center;
        }
        .text-center mb-4 title-bg {
            background: linear-gradient(90deg, #F2E8CF, #DDB892); 
            color: #333; 
            text-align: center; 
            font-weight: bold;
            font-size: 28px; 
            padding: 15px 0; 
            border-radius: 8px; 
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
            margin: 20px auto; 
            width: 80%; 
        }

        .container {
            background: #ffffff; /* Warna latar container */
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background: linear-gradient(90deg, #4b6cb7, #182848); 
            border: none;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
            text-decoration: none;
            transition: background 0.3s ease;
        }

        .btn-primary:hover {
            background: #182848;
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - User Management</h1>
    </div>

    <div class="container mt-4">
        <h2 class="text-center mb-4 title-bg">List of Users</h2>
        <a href="addStaff.jsp" class="btn btn-primary mb-3">Add New User</a>

        <table class="table table-bordered">
            <thead class="table-primary">
                <tr>
                    <th>ID Pengguna</th>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Address</th>
                    <th>Jenis Kelamin</th>
                    <th>No Telp</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    jdbc db = new jdbc();
                    ResultSet rs = db.runQuery("SELECT * FROM pengguna");
                    while (rs != null && rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("id_pengguna") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("password") %></td>
                    <td><%= rs.getString("address") %></td>
                    <td><%= rs.getString("jenis_kelamin") %></td>
                    <td><%= rs.getString("no_telp") %></td>
                    <td><%= rs.getInt("role") %></td>
                    <td>
                        <form action="editStaff.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id_pengguna" value="<%= rs.getString("id_pengguna") %>">
                            <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                        </form>

                        <form action="kelolaStaffServlet" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id_pengguna" value="<%= rs.getString("id_pengguna") %>">
                            <button type="submit" class="btn btn-danger btn-sm" 
                                    onclick="return confirm('Are you sure you want to delete this staff?');">
                                Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <a href="<%= session.getAttribute("role").equals("owner") ? "mainMenuOwner.jsp" : "mainMenu.jsp" %>">
            <button class="back-button">Back to Main Menu</button>
        </a>
    </div>
</body>
</html>