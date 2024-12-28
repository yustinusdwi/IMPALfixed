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
            background: #f4f7fa;
            color: #333;
            background-size: cover;
            margin: 0;
        }

        .header {
            position: fixed; 
            top: 0;
            left: 0;
            width: 100%;
            height: 70px; 
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            background: linear-gradient(90deg, #4b6cb7, #182848);
            color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1100;
        }

        .header img {
            height: 70px;
        }
        
        .header h1 {
            text-align: center; 
            margin: 5px 0;
        }

        .container {
            display: flex;
            margin-left: 250px;
            margin-top: 70px;
            flex-direction: column; 
            align-items: center; 
            justify-content: center; 
            padding: 20px;
            background: #f4f7fa;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%; 
            max-width: 1200px; 
            min-height: calc(100vh - 70px);
            margin: 0 auto;
        }

        .title-bg {
            background: linear-gradient(90deg, #F2E8CF, #DDB892);
            color: #333;
            font-weight: bold;
            font-size: 28px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            overflow-x: auto;
        }

        .table th, .table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        table th {
            background: #4b6cb7;
            color: white;
        }

        table tbody tr:hover {
            background-color: #f1f1f1;
            transform: translateY(-2px);
            transition: all 0.3s ease;
        }

        .message {
            background: #e0f7fa;
            color: #00796b;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            font-size: 16px;
        }
        
        @media screen and (max-width: 768px) {
            .container {
                padding: 10px; 
            }

            .content {
                padding: 10px;
            }

            table {
                font-size: 14px; 
            }
        }

        @media screen and (max-width: 576px) {
            .header h1, .header h2 {
                font-size: 18px;
            }

            .search-input {
                min-width: 150px;
            }

            table th, table td {
                font-size: 12px;
            }
        }
        
        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(30px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .back-button {
            background-color: #dc3545; /* Warna merah */
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 50px; /* Membuat sudut melengkung */
            cursor: pointer;
            font-weight: bold; /* Teks lebih tebal */
            text-transform: uppercase; /* Huruf besar semua */
            transition: all 0.3s ease; /* Animasi transisi */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* Bayangan untuk efek mengambang */
            display: inline-block;
            margin-top: 20px; /* Jarak dari elemen lain */
            text-align: center;
        }

        .back-button:hover {
            background-color: #c82333; /* Warna lebih gelap saat hover */
            transform: translateY(-3px); /* Efek mengangkat */
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.3); /* Bayangan lebih besar saat hover */
        }

        .back-button:active {
            transform: translateY(1px); /* Efek klik */
            box-shadow: 0 3px 5px rgba(0, 0, 0, 0.2); /* Bayangan lebih kecil saat aktif */
        }
        .search-bar {
            display: flex;
            flex-wrap: nowrap;
            gap: 10px;
            justify-content: flex-start; 
            width: 100%;
        }
        .search-bar form {
            display: flex; 
            flex-wrap: nowrap;
            align-items: center; 
            width: 100%; 
        }

        .search-input {
            flex: 1; 
            padding: 12px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
        }

        .search-input:focus {
            border-color: #4b6cb7;
            box-shadow: 0 0 10px rgba(75, 108, 183, 0.3);
        }

        .search-bar button {
            padding: 12px 20px; 
            border: none;
            border-radius: 5px;
            background-color: #4b6cb7;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-bar button:hover {
            background-color: #182848;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
        
        <!-- Link Tambah User -->
        <a href="addStaff.jsp" class="btn btn-primary mb-3">Add New User</a>

        <!-- Form Search -> Arahkan ke SearchStaffServlet dengan action=search -->
        <div class="search-bar">
            <form action="SearchStaffServlet" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="search" class="search-input" 
                       placeholder="user's name..."
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>

        <!-- Tabel Data -->
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
                    // Di sini kita ambil resultSet dari servlet
                    ResultSet rs = (ResultSet) request.getAttribute("resultSet");
                    if (rs == null) {
                        jdbc db = new jdbc();
                        rs = db.runQuery("SELECT * FROM pengguna");
                    }
                    int rowCount = 0;
                    if(rs != null) {
                        while (rs.next()) {
                        rowCount++;
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
                        <!-- Edit -->
                        <form action="editStaff.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id_pengguna" value="<%= rs.getString("id_pengguna") %>">
                            <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                        </form>

                        <!-- Delete -->
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
                <%
                        } // end while
                    }     if (rowCount == 0) {
                %>
                    <tr>
                        <td colspan="8">No data available.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Tombol Back to Main Menu -->
        <%
            // Asumsi role di session = "owner" atau "karyawan"
            String role = (String) session.getAttribute("role");
            if(role == null) {
                role = "karyawan"; // fallback
            }
            String backPage = "mainMenu.jsp";
            if("owner".equalsIgnoreCase(role)) {
                backPage = "mainMenuOwner.jsp";
            }
        %>
        <a href="<%= backPage %>">
            <button class="back-button">Back to Main Menu</button>
        </a>
    </div>
</body>
</html>