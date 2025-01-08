<%-- 
    Document   : addItems
    Created on : 4 Dec 2024, 10.32.10
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Main Menu - InvenTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet"> 
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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
        
        .header-bg{
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
             animation: fadeIn 0.8s ease-out;
        }

        .header img {
            height: 70px;
        }

        .header h1, .header h2 {
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

        .sidebar {
            position: fixed; 
            top: 70px; 
            left: 0;
            height: calc(100vh - 70px); 
            width: 250px; 
            padding: 20px;
            background: linear-gradient(90deg, #ffffff, #fefaf1); 
            border-right: 1px solid #ddd;
            box-shadow: 4px 0 6px rgba(0, 0, 0, 0.1);
            overflow-y: auto; 
            z-index: 1000; 
        }

       .sidebar a {
           display: block;
           padding: 15px;
           margin: 10px 0;
           font-size: 16px;
           font-weight: 500;
           background: linear-gradient(90deg, #ffffff, #d4b99b);
           color: #333;
           text-decoration: none;
           border-radius: 5px;
           transition: all 0.3s ease; 
       }

       .sidebar a:hover {
           background: linear-gradient(90deg, #2c3e50, #4ca1af);
           color: white;
           transform: scale(1.05); 
           box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
       }

        .content {
            flex: 3 1 700px; 
            width: 100%;
            padding: 30px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .content h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
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
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>Main Menu</h1>
        <h2>Halo  
            <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Guest" %>!
        </h2>
    </div>
    
 <div class="container">
        <div class="row">
            <div class="sidebar col-md-3">
                <a href="addItems.jsp" class="add">Add Items</a>
                <a href="printReport.jsp" class="button report">Print Report Inventory</a>
                <a href="bugReport.jsp" class="button report">Bug Report</a>
                <a href="LogoutServlet" class="button login">Logout</a>
            </div>
            <div class="content">
                <h2 class="header-bg">List of Items</h2>
                <div class="search-bar">
                    <!-- Arahkan form ke SearchItemServlet -->
                    <form action="SearchItemServlet" method="get">
                        <!-- Tampilkan kembali searchQuery (jika ada) di input -->
                        <input type="text" name="search" class="search-input"
                               placeholder="item's ID or Name..."
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>
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
                        <button class="search-bar">All Items</button>
                    </a>
                </div>
                
                <table class="table table-bordered">
                    <thead class="table-primary">
                        <tr>
                            <th>ID Item</th>
                            <th>Item Name</th>
                            <th>Quantity</th>
                            <th>Category</th>
                            <th>Supplier</th>
                            <th>Date</th>
                            <th>Updated By</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Ambil ResultSet yang sudah diforward oleh SearchItemServlet
                            ResultSet rs = (ResultSet) request.getAttribute("resultSet");

                            // Jika masih null, fallback dengan menampilkan semua data
                            if (rs == null) {
                                jdbc db = new jdbc();
                                rs = db.runQuery("SELECT * FROM mengeloladatainventory");
                            }
                            int rowCount = 0;
                        %>
                        <tbody>
                            <% while (rs != null && rs.next()) { %>
                            <tr>
                                <td><%= rs.getString("id_barang") %></td>
                                <td><%= rs.getString("nama_barang") %></td>
                                <td><%= rs.getInt("quantity") %></td>
                                <td><%= rs.getString("kategori") %></td>
                                <td><%= rs.getString("supplier") %></td>
                                <td><%= rs.getTimestamp("date") %></td>
                                <td><%= rs.getString("id_karyawan_input") %></td>
                                <td>
                                    <form action="edit.jsp" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id_barang" value="<%= rs.getString("id_barang") %>">
                                        <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                                    </form>
                                    <form action="inventoryServlet" method="post" style="display:inline;" onsubmit="return confirmDelete();">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id_barang" value="<%= rs.getString("id_barang") %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% rowCount++; } %>
                            <% if (rowCount == 0) { %>
                            <tr>
                                <td colspan="8">No data available.</td>
                            </tr>
                            <% } %>
                        </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        function confirmDelete() {
            const isConfirmed = confirm("Are u sure want to delete this data?");
            }
        window.addEventListener("load", function() {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get("deleteStatus") === "success") {
                    alert("Data berhasil dihapus.");
            }
        });
    </script>




</body>
</html>