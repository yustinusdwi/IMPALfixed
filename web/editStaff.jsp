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
    <title>Edit Staff - InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .modal-xl {
            max-width: 90%; 
        }

        .modal-content {
            min-height: 80vh;
        }
    </style>
</head>
<body>
<%
    String id_pengguna = request.getParameter("id_pengguna");

    if (id_pengguna == null || id_pengguna.isEmpty()) {
        out.println("<h3>Error: ID User not valid!</h3>");
        return;
    }

    jdbc db = new jdbc();
    try {
        ResultSet rs = db.runQuery("SELECT * FROM pengguna WHERE id_pengguna = '" + id_pengguna + "'");
        if (rs.next()) {
%>
<div class="modal fade" id="editItemModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editStaffModalLabel">Edit Staff</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.location.href='kelolaStaff.jsp'"></button>
            </div>
            <div class="modal-body">
                <form action="kelolaStaffServlet" method="post" id="editStaffForm">
                    <input type="hidden" name="action" value="edit">
                    <div class="mb-3">
                        <label for="editIDUser" class="form-label">ID User</label>
                        <input type="text" class="form-control" id="editIDUser" name="id_pengguna" readonly value="<%= rs.getString("id_pengguna") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editUsername" class="form-label">Username</label>
                        <input type="text" class="form-control" id="editUsername" name="username" value="<%= rs.getString("username") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editPassword" class="form-label">Password Baru</label>
                        <input type="password" class="form-control" id="editPassword" name="password" placeholder="Masukkan password baru">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Konfirmasi Password Baru</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirm_password" placeholder="Konfirmasi password baru">
                    </div>
                    <div class="mb-3">
                        <label for="editAddress" class="form-label">Address</label>
                        <input type="text" class="form-control" id="editAddress" name="address" value="<%= rs.getString("address") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editGender" class="form-label">Gender</label>
                        <input type="text" class="form-control" id="editGender" name="jenis_kelamin" value="<%= rs.getString("jenis_kelamin") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editPhoneNumber" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="editPhoneNumber" name="no_telp" value="<%= rs.getString("no_telp") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editRole" class="form-label">Role</label>
                        <input type="text" class="form-control" id="editRole" name="role" value="<%= rs.getString("role") %>">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="window.location.href='kelolaStaff.jsp'">Close</button>
                        <button type="submit" class="btn btn-success">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%
        } else {
            out.println("<h3>Error: User not found!</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Error: Unable to retrieve data from database.</h3>");
    } finally {
        db.disconnect();
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var editModal = new bootstrap.Modal(document.getElementById('editItemModal'), {
            backdrop: 'static',
            keyboard: false
        });
        editModal.show();
    });
</script>
</body>
</html>
