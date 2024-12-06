<%-- 
    Document   : kelolaStaff
    Created on : 4 Dec 2024, 11.31.49
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
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
            animation: fadeIn 1s ease-out;
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
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - Staff Management</h1>
    </div>

    <div class="container mt-4">
        <h2 class="text-center mb-4">List of Staffs</h2>
        <a href="addStaff.jsp" class="btn btn-primary mb-3">Add New Staff</a>

        <table class="table table-bordered">
            <thead class="table-primary">
                <tr>
                    <th>Staff ID</th>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="staffTableBody">
                <!-- Contoh data staff -->
                <tr id="row-001">
                    <td>001</td>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>johndoe@example.com</td>
                    <td>123-456-789</td>
                    <td>
                        <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editStaffModal" 
                                onclick="populateEditForm('001', 'John Doe', 'Manager', 'johndoe@example.com', '123-456-789')">Edit</button>
                        <button class="btn btn-danger btn-sm" onclick="deleteStaff('001')">Delete</button>
                    </td>
                </tr>
                <!-- Tambahkan data staff lainnya -->
            </tbody>
        </table>
        <a href="<%= session.getAttribute("role").equals("owner") ? "mainMenuOwner.jsp" : "mainMenu.jsp" %>">
            <button class="back-button">Kembali ke Main Menu</button>
        </a>
    </div>

    <!-- Modal for Edit Form -->
    <div class="modal fade" id="editStaffModal" tabindex="-1" aria-labelledby="editStaffModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editStaffModalLabel">Edit Staff</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editStaffForm">
                    <div class="modal-body">
                        <input type="hidden" id="editStaffId">
                        <div class="mb-3">
                            <label for="editStaffName" class="form-label">Name</label>
                            <input type="text" class="form-control" id="editStaffName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editStaffRole" class="form-label">Role</label>
                            <input type="text" class="form-control" id="editStaffRole" required>
                        </div>
                        <div class="mb-3">
                            <label for="editStaffEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editStaffEmail" required>
                        </div>
                        <div class="mb-3">
                            <label for="editStaffPhone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="editStaffPhone" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function populateEditForm(id, name, role, email, phone) {
            document.getElementById('editStaffId').value = id;
            document.getElementById('editStaffName').value = name;
            document.getElementById('editStaffRole').value = role;
            document.getElementById('editStaffEmail').value = email;
            document.getElementById('editStaffPhone').value = phone;
        }

        function deleteStaff(id) {
            if (confirm(`Are you sure you want to delete staff with ID ${id}?`)) {
                const row = document.getElementById(`row-${id}`);
                if (row) {
                    row.remove();
                    alert(`Staff with ID ${id} has been deleted.`);
                } else {
                    alert(`Staff with ID ${id} not found.`);
                }
            }
        }
    </script>
</body>
</html>


