<%-- 
    Document   : printReport
    Created on : 4 Dec 2024, 22.49.11
    Author     : nbpav
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="JDBC.jdbc"%>
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
    <title>Inventory Table</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
            background: linear-gradient(90deg, #4b6cb7, #182848); /* Gradien warna menarik */
            color: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 500;
        }
        
        .content .header {
            position:static;
            text-align: center;
            background: linear-gradient(90deg, #ffffff, #f4e8dc);
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: inline-block;
            width: auto;
        }

        body {
            background-color: #f8f9fa;
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
        }

        @media print {
            .no-print {
                display: none;
            }
        }

        .back-button {
            background-color: #dc3545;
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            justify-content: space-between;
        }

        .back-button:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .back-button:active {
            transform: translateY(2px);
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        .content h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        
        .container .content-h2{
            position:static;
            text-align: center;
            background: linear-gradient(90deg, #ffffff, #f4e8dc);
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: inline-block;
            width: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
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

        .buttons-container {
            justify-content: space-between;
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        #printButton {
            padding: 12px 20px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        #printButton:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - Print Inventory Management</h1>
    </div>
    <div class="container">
        <div class="content">
            <h2 class="content-h2">List of Items</h2>
            <table class="table table-bordered">
                <thead class="table-primary">
                    <tr>
                        <th>ID Item</th>
                        <th>Item Name</th>
                        <th>Quantity</th>
                        <th>Category</th>
                        <th>Supplier</th>
                        <th>Date</th>
                        <th>Updated by</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        jdbc db = new jdbc();
                        ResultSet rs = db.runQuery("SELECT * FROM mengeloladatainventory"); // Query database
                        if (rs != null) {
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("id_barang") %></td>
                        <td><%= rs.getString("nama_barang") %></td>
                        <td><%= rs.getInt("quantity") %></td>
                        <td><%= rs.getString("kategori") %></td>
                        <td><%= rs.getString("supplier") %></td>
                        <td><%= rs.getTimestamp("date") %></td>
                        <td><%= rs.getString("id_karyawan_input") %></td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7">No data available.</td>
                    </tr>
                    <% 
                        }
                        db.disconnect();
                    %>

                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Aligning both buttons side by side -->
        <div class="buttons-container">
            <button id="printButton" class="btn btn-primary no-print">
                <i class="bi bi-printer"></i> Print PDF
            </button>
            <a href="<%= session.getAttribute("role").equals("owner") ? "mainMenuOwner.jsp" : "mainMenu.jsp" %>">
                <button class="back-button">Back to Main Menu</button>
            </a>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

    <script>
        document.getElementById('printButton').addEventListener('click', function() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF('l', 'mm', 'a4');
            const element = document.querySelector('table');

            html2canvas(element).then((canvas) => {
                const imgData = canvas.toDataURL('image/png');
                const imgProps = doc.getImageProperties(imgData);
                const pdfWidth = doc.internal.pageSize.getWidth();
                const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

                doc.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);

                const logo = document.querySelector('.header img');
                const logoSrc = logo.src;
                const logoHeight = 20; 
                const logoWidth = 40;  
                const logoYPosition = doc.internal.pageSize.height - logoHeight - 10; 
                doc.addImage(logoSrc, 'PNG', 10, logoYPosition, logoWidth, logoHeight); 

                const currentDate = new Date();
                const dateString = currentDate.getFullYear() + '-' +
                                    (currentDate.getMonth() + 1) + '-' +
                                    currentDate.getDate() + ' ' +
                                    currentDate.getHours() + ':' +
                                    currentDate.getMinutes() + ':' +
                                    currentDate.getSeconds();
                doc.setFontSize(12); 
                doc.setTextColor(0, 0, 0); 

                const dateYPosition = logoYPosition - 5; 
                doc.text('Printed on: ' + dateString, 10, dateYPosition); 

                doc.save('List-Item.pdf');
             });
         });




    </script>
</body>
</html>
