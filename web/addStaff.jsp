<%-- 
    Document   : addStaff
    Created on : 4 Dec 2024, 12.50.24
    Author     : nbpav
--%>

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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff</title>
    <style>
        .header {
            position: fixed;
            top: 0%;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            padding: 15px 30px;
            background: linear-gradient(90deg, #4b6cb7, #182848); 
            color: white;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header img {
            height: 70px;
        }

        .header h1 {
            font-size: 28px;
            color: white;
        }
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-size: cover; 
            padding-top: 200px;
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

        .container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            padding: 30px;
            animation: fadeIn 1s ease-in-out;
            margin-top: 150px;
        }

        h2 {
            text-align: center;
            color: #333;
            font-size: 2em;
            margin-bottom: 20px;
        }

        label {
            font-size: 1.1em;
            color: #555;
            margin-bottom: 8px;
            display: block;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px 0;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        input:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-bottom: 20px; 
        }

        button:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block; 
            width: 96.5%;
            text-align: center;
            padding: 12px;
            background-color: #dc3545;
            color: white;
            font-size: 1.1em;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .back-link:hover {
            background-color: #c82333;
        }

        /* Animation */
        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(-20px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            h2 {
                font-size: 1.8em;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>Add Staff</h1>
    </div>
    <div class="container">
        <h2>Add New Staff</h2>

        <form action="kelolaStaffServlet" method="post">
            <label for="userID">UserID:</label>
            <input type="text" id="id_pengguna" name="id_pengguna" required><br><br>
            
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required><br><br>
            
            <label for="password">Password:</label>
            <input type="text" id="password" name="password" required><br><br>
            
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required><br><br>

            <label for="jenis_kelamin">Gender:</label>
            <input type="text" id="jenis_kelamin" name="jenis_kelamin" required><br><br>

            <label for="no_telp">Phone Number:</label>
            <input type="number" id="no_telp" name="no_telp" required><br><br>
            
            <label for="role">Role:</label>
            <input type="number" id="role" name="role" required><br><br>

            <button type="submit">Add Staff</button>
        </form>
        
        <% if (request.getParameter("status") != null) { %>
        <% if (request.getParameter("status").equals("success")) { %>
            <p style="color: green; text-align: center;">Staff berhasil ditambahkan!</p>
        <% } else if (request.getParameter("status").equals("error")) { %>
            <p style="color: red; text-align: center;">Terjadi kesalahan, staff gagal ditambahkan.</p>
        <% } %>
        <% } %>

        <a href="kelolaStaff.jsp" class="back-link">Back to Staff Management</a>
    </div>
</body>
</html>
