<%-- 
    Document   : addItems
    Created on : 4 Dec 2024, 10.32.10
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>
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
    <title>Add Items - InvenTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        .header {
            position: fixed;
            top: 0%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
            background: linear-gradient(90deg, #4b6cb7, #182848); 
            color: white;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 28px;
            color: white;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background: #f7f9fc;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 100px;
            background-size: cover; 
        }
        
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: inherit; 
            filter: blur(3px); 
            z-index: -1; 
            padding-top: 100px;
        }

        .form-container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
            animation: fadeIn 1s ease-out;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-size: 16px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #4b6cb7;
            box-shadow: 0 0 8px rgba(75, 108, 183, 0.3);
        }

        .btn-submit {
            background: #4b6cb7;
            color: white;
            padding: 12px;
            width: 100%;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.2s;
        }

        .btn-submit:hover {
            background-color: #3e5c8f;
            transform: translateY(-2px);
        }

        .btn-submit:active {
            background-color: #2d4376;
            transform: translateY(2px);
        }
        
        .back-button {
            background-color: #dc3545;
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            margin-top: 30px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .back-button:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .back-button:active {
            transform: translateY(2px);
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
        <h1>InvenTrack - Add Item</h1>
    </div>
    <div class="form-container">
        <h1>Add Item</h1>
        <!-- Form diarahkan ke servlet -->
        <form method="post" action="inventoryServlet">
            <!-- Hidden input untuk menentukan aksi -->
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label for="id_barang">Item's ID</label>
                <input type="text" id="id_barang" name="id_barang" required>
            </div>
            <div class="form-group">
                <label for="nama_barang">Item's Name</label>
                <input type="text" id="nama_barang" name="nama_barang" required>
            </div>
            <div class="form-group">
                <label for="quantity">Quantity</label>
                <input type="number" id="quantity" name="quantity" required>
            </div>
            <div class="form-group">
                <label for="kategori">Category</label>
                <input type="text" id="kategori" name="kategori" required>
            </div>
            <div class="form-group">
                <label for="supplier">Supplier</label>
                <input type="text" id="supplier" name="supplier" required>
            </div>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const now = new Date();
                    const formattedDate = now.toISOString().slice(0, 16); // Format sesuai dengan input datetime-local
                    document.getElementById('date').value = formattedDate;
                });
            </script>
            <input type="hidden" id="id_karyawan_input" name="id_karyawan_input" value="<%= session.getAttribute("username") %>">
            <button type="submit" class="btn-submit">Submit</button>
        </form>

        <% if (request.getParameter("status") != null) { %>
            <% if (request.getParameter("status").equals("success")) { %>
                <p style="color: green;">Item added successfully!</p>
            <% } else { %>
                <p style="color: red;">Error adding item!</p>
            <% } %>
        <% } %>

        <a href="mainMenu.jsp">
            <button class="back-button">Back to Main Menu</button>
        </a>
    </div>
</body>
</html>

