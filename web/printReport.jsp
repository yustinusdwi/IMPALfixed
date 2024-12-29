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
    <title>Print Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            background-size: cover;
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            line-height: 1.6;
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

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            background: linear-gradient(90deg, #4b6cb7, #182848);
            color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            position: fixed;
            top: 0;
            z-index: 1000;
            height: 80px; /* Tinggi tetap header untuk proporsional */
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 500;
            flex: 1;
            text-align: center;
        }

        .content {
            flex: 1;
            padding: 30px;
            margin-top: 100px; /* Memberikan jarak dari header */
            width: 90%;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .content h2 {
            font-size: 24px;
            margin: 0 auto 20px; 
            color: #333;
            text-align: center;
            background: linear-gradient(90deg, #ffffff, #f4e8dc);
            padding: 15px 30px; 
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: inline-block;
            text-align: center;
            position: relative;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .search-but {
            font-size: 18px;
            color: #ffffff;
            background-color: #007bff; 
            padding: 5px 10px; 
            border-radius: 5px; 
            display: inline-block; 
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
            margin: 0 auto 20px; 
        }
        
        .btn-custom-green {
            background-color: #28a745; /* Hijau Bootstrap */
            color: white; /* Warna teks */
            border: none; /* Hilangkan border default */
        }

        .btn-custom-green:hover {
            background-color: #218838; /* Warna saat hover */
        }

        .table-container {
            overflow-x: auto; 
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
            white-space: nowrap; /* Teks tidak terpotong */
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
            display: flex;
            flex-wrap: wrap; /* Tombol tetap rapi di layar kecil */
            gap: 15px;
            justify-content: center; /* Tombol diratakan di tengah */
            margin-top: 20px;
        }

        .back-button, #printButton {
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .back-button {
            background-color: #dc3545;
            color: white;
        }

        .back-button:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .back-button:active {
            transform: translateY(2px);
        }

        #printButton {
            background-color: #4CAF50;
            color: white;
        }

        #printButton:hover {
            background-color: #45a049;
        }

        /* Responsivitas */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 20px; /* Ukuran header lebih kecil */
            }

            .content {
                padding: 20px;
                margin-top: 120px; /* Menambahkan jarak untuk layar kecil */
            }

            table th, table td {
                font-size: 14px; /* Teks tabel lebih kecil */
            }

            .back-button, #printButton {
                font-size: 14px;
                padding: 10px 20px;
            }
        }

        @media (max-width: 576px) {
            .header h1 {
                font-size: 18px; /* Ukuran lebih kecil untuk layar sempit */
            }

            .content h2 {
                font-size: 20px; /* Ukuran judul lebih kecil */
            }

            .back-button, #printButton {
                font-size: 12px;
                padding: 8px 16px;
            }

            table th, table td {
                font-size: 12px;
            }

            table {
                font-size: 12px; /* Keseluruhan ukuran tabel lebih kecil */
            }
        }

    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - Print Inventory Management</h1>
    </div>

    <div class="content">
        <h2 class="content-h2">List of Items</h2>
        
        <div class="search-container modern">
            <h5 class="search-but">Search Filter</h5>
            <form action="SearchReportServlet" method="get" class="form-modern">
                <div class="row g-3 align-items-end">
                    <div class="col-md-2">
                        <label for="id_barang" class="form-label border border-primary rounded px-2 py-1 d-block text-center">ID</label>
                        <input type="text" name="id_barang" id="id_barang" class="form-control"
                               value="<%= request.getParameter("id_barang") != null ? request.getParameter("id_barang") : "" %>" placeholder="Enter ID">
                    </div>
                    <div class="col-md-2">
                        <label for="nama_barang" class="form-label border border-primary rounded px-2 py-1 d-block text-center">Name</label>
                        <input type="text" name="nama_barang" id="nama_barang" class="form-control"
                               value="<%= request.getParameter("nama_barang") != null ? request.getParameter("nama_barang") : "" %>" placeholder="Enter Name">
                    </div>
                    <div class="col-md-2">
                        <label for="kategori" class="form-label border border-primary rounded px-2 py-1 d-block text-center">Category</label>
                        <input type="text" name="kategori" id="kategori" class="form-control"
                               value="<%= request.getParameter("kategori") != null ? request.getParameter("kategori") : "" %>" placeholder="Enter Category">
                    </div>
                    <div class="col-md-2">
                        <label for="date" class="form-label border border-primary rounded px-2 py-1 d-block text-center">Date</label>
                        <input type="date" name="date" id="date" class="form-control"
                               value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label for="id_karyawan_input" class="form-label border border-primary rounded px-2 py-1 d-block text-center">User's ID</label>
                        <input type="text" name="id_karyawan_input" id="id_karyawan_input" class="form-control"
                               value="<%= request.getParameter("id_karyawan_input") != null ? request.getParameter("id_karyawan_input") : "" %>" placeholder="Enter Employee ID">
                    </div>
                    <div class="col-md-2 text-center">
                        <a href="printReport.jsp" class="btn btn-primary w-100 mb-2">All Items</a>
                        <button type="submit" class="btn btn-custom-green w-100">Search</button>
                    </div>
                </div>
            </form>
        </div>


        <!-- Tabel hasil data -->
        <table class="table table-bordered" id="inventoryTable">
            <thead class="table-primary">
                <tr>
                    <th>Item's ID</th>
                    <th>Item'S Name</th>
                    <th>Quantity</th>
                    <th>Category</th>
                    <th>Supplier</th>
                    <th>Date</th>
                    <th>Updated By</th>
                </tr>
            </thead>
            <tbody>
            <%
                // Diterima dari SearchReportServlet
                ResultSet rs = (ResultSet) request.getAttribute("resultSet");
                
                if (rs == null) {
                    jdbc db = new jdbc();
                    rs = db.runQuery("SELECT * FROM mengeloladatainventory");
                }
                int rowCount = 0;
                if (rs != null) {
                    while (rs.next()) {
                        rowCount++;
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
                }
                if (rowCount == 0) {
            %>
                <tr>
                    <td colspan="7">No data available.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <!-- Tombol PDF & Back -->
        <div class="buttons-container">
            <!-- Tombol Print -->
            <button id="printButton" class="btn btn-primary no-print">
                <i class="bi bi-printer"></i> Print PDF
            </button>
            
            <!-- Tombol Back ke Main Menu -->
            <%
                // Misal role disimpan di session: "owner" atau "karyawan"
                String userRole = (String) session.getAttribute("role");
                if (userRole == null) {
                    userRole = "karyawan"; // fallback
                }
                String backPage = "mainMenu.jsp";
                if ("owner".equalsIgnoreCase(userRole)) {
                    backPage = "mainMenuOwner.jsp";
                }
            %>
            <a href="<%= backPage %>">
                <button class="back-button">Back to Main Menu</button>
            </a>
        </div>
    </div>

    <!-- Script Print PDF -->
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
                                   String(currentDate.getMonth() + 1).padStart(2, '0') + '-' +
                                   String(currentDate.getDate()).padStart(2, '0') + ' ' +
                                   String(currentDate.getHours()).padStart(2, '0') + ':' +
                                   String(currentDate.getMinutes()).padStart(2, '0') + ':' +
                                   String(currentDate.getSeconds()).padStart(2, '0');
                                   doc.setFontSize(12); 
                doc.setTextColor(0, 0, 0);
                const dateYPosition = logoYPosition - 5; 
                doc.text('Printed on: ' + dateString, 10, dateYPosition); 

                doc.save('List-Item.pdf');
             });
         });
    </script>

    <!-- Bootstrap JS (opsional) -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
