<%-- 
    Document   : addItems
    Created on : 4 Dec 2024, 10.32.10
    Author     : nbpav
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Main Menu - InvenTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet"> <!-- Font Modern -->
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
            background: url("<%= request.getContextPath() %>/background") no-repeat center center fixed; /* Gambar background */
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
            height: 100%; 
            min-height: 100%;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
            background: linear-gradient(90deg, #4b6cb7, #182848); 
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
        
        .container {
            margin-left: 250px;
            display: flex;
            min-height: 80vh;
        }

        .sidebar {
            position:absolute;
            left: 0%;
            background: linear-gradient(90deg, #ffffff, #fefaf1);
            width: 250px;
            padding: 30px;
            border-right: 1px solid #ddd;
            box-shadow: 4px 0 6px rgba(0,0,0,0.1);
            animation: slideIn 0.5s ease-out;
            min-height: 100vh;
        }

        .sidebar a {
            top: 0%;
            left: 0;
            display: block;
            padding: 15px;
            margin: 15px 0;
            font-size: 16px;
            font-weight: 500;
            background:linear-gradient(90deg, #ffffff, #d4b99b);
            color: #333;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .sidebar a:hover {
            background:linear-gradient(90deg, #2c3e50, #4ca1af);
            color: white;
            transform: scale(1.05); 
        }

        .sidebar .remove {
            background-color: #f44336;
        }

        .sidebar .add {
            background-color: #4CAF50;
        }

        .content {
            flex: 1;
            padding: 30px;
            margin-left: 20px; 
        }

        .content h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
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
        
        .search-input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #4b6cb7;
            box-shadow: 0 0 10px rgba(75, 108, 183, 0.3);
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
            transform: translateY(-2px); /* Efek hover baris */
            transition: all 0.3s ease;
        }

        /* Animasi sidebar masuk */
        @keyframes slideIn {
            from {
                transform: translateX(-100%);
            }
            to {
                transform: translateX(0);
            }
        }

        .message {
            background: #e0f7fa;
            color: #00796b;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            font-size: 16px;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>Main Menu</h1>
        <h2>halo  
            <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Guest" %> !</h2>
        <% 
            // Cek apakah ada pesan di session
            String message = (String) session.getAttribute("message");
            if (message != null) {
        %>
            <div class="message">
                <strong><%= message %></strong>
            </div>
        <%
            session.removeAttribute("message");
            }
        %>
    </div>
    
    <div class="container">
        <div class="sidebar">
            <a href="addItems.jsp" class="add">Add Items</a>
            <a href="removeItems.jsp" class="remove">Remove Items</a>
            <a href="kelolaStaff.jsp" class="button staff">Staff Management</a>
            <a href="printReport.jsp" class="button report">Print Report Inventory</a>
            <a href="bugReport.jsp" class="button report">Bug Report</a>
            <a href="LOGINpage.jsp" class="button login">Logout</a>
        </div>
        
        <div class="content">
            <input type="text" placeholder="Search for item" class="search-input">
            <h2 class="header">List of Items</h2>
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
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Contoh data -->
                    <tr>
                        <td>7021590</td>
                        <td>Smartphone</td>
                        <td>3</td>
                        <td>Elektronic</td>
                        <td>Supplier A</td>
                        <td>2024-12-01</td>
                        <td>Admin</td>
                        <td>
                        <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editItemModal"
                            onclick="populateEditForm('7021590', 'Power supply chip', 3, 'Power Supply', 'Location A', '2024-12-01', 'Admin')">
                            Edit
                        </button>
                    </td>
                    </tr>
                    <!-- Tambahkan data lainnya -->
                </tbody>
            </table>
        </div>
    </div>
    <div class="modal fade" id="editItemModal" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editItemModalLabel">Edit Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editItemForm">
                        <div class="mb-3">
                            <label for="editPartNumber" class="form-label">Part Number</label>
                            <input type="text" class="form-control" id="editPartNumber" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="editItemName" class="form-label">Item Name</label>
                            <input type="text" class="form-control" id="editItemName">
                        </div>
                        <div class="mb-3">
                            <label for="editQuantity" class="form-label">Quantity</label>
                            <input type="number" class="form-control" id="editQuantity">
                        </div>
                        <div class="mb-3">
                            <label for="editStoreType" class="form-label">Store Type</label>
                            <input type="text" class="form-control" id="editStoreType">
                        </div>
                        <div class="mb-3">
                            <label for="editLocation" class="form-label">Location</label>
                            <input type="text" class="form-control" id="editLocation">
                        </div>
                        <div class="mb-3">
                            <label for="editDate" class="form-label">Date</label>
                            <input type="date" class="form-control" id="editDate">
                        </div>
                        <div class="mb-3">
                            <label for="editUpdatedBy" class="form-label">Updated By</label>
                            <input type="text" class="form-control" id="editUpdatedBy">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-success" form="editItemForm">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
     <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function populateEditForm(partNumber, itemName, quantity, storeType, location, date, updatedBy) {
            document.getElementById('editPartNumber').value = partNumber;
            document.getElementById('editItemName').value = itemName;
            document.getElementById('editQuantity').value = quantity;
            document.getElementById('editStoreType').value = storeType;
            document.getElementById('editLocation').value = location;
            document.getElementById('editDate').value = date;
            document.getElementById('editUpdatedBy').value = updatedBy;
        }
    </script>
</body>
</html>