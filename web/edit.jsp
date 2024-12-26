<%-- 
    Document   : edit.jsp
    Created on : 19 Dec 2024, 07.47.47
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
    <title>Edit Item - InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%
    String id_barang = request.getParameter("id_barang");

    if (id_barang == null || id_barang.isEmpty()) {
        out.println("<div class='alert alert-danger text-center'>Error: ID Item tidak valid!</div>");
        return;
    }

    jdbc db = new jdbc();
    try {
        ResultSet rs = db.runQuery("SELECT * FROM mengeloladatainventory WHERE id_barang = '" + id_barang + "'");
        if (rs.next()) {
%>
<div class="modal fade" id="editItemModal" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editItemModalLabel">Edit Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.location.href='mainMenu.jsp'"></button>
            </div>
            <div class="modal-body">
                <form action="inventoryServlet" method="post" id="editItemForm">
                    <input type="hidden" name="action" value="update">
                    <div class="mb-3">
                        <label for="editIDItem" class="form-label">ID Item</label>
                        <input type="text" class="form-control" id="editIDItem" name="id_barang" readonly value="<%= rs.getString("id_barang") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editItemName" class="form-label">Item Name</label>
                        <input type="text" class="form-control" id="editItemName" name="nama_barang" value="<%= rs.getString("nama_barang") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editQuantity" class="form-label">Quantity</label>
                        <input type="number" class="form-control" id="editQuantity" name="quantity" value="<%= rs.getInt("quantity") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editCategory" class="form-label">Category</label>
                        <input type="text" class="form-control" id="editCategory" name="kategori" value="<%= rs.getString("kategori") %>">
                    </div>
                    <div class="mb-3">
                        <label for="editSupplier" class="form-label">Supplier</label>
                        <input type="text" class="form-control" id="editSupplier" name="supplier" value="<%= rs.getString("supplier") %>">
                    </div>
                    <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const now = new Date();
                    const formattedDate = now.toISOString().slice(0, 16); // Format sesuai dengan input datetime-local
                    document.getElementById('date').value = formattedDate;
                });
            </script>
                    <input type="hidden" id="id_karyawan_input" name="id_karyawan_input" value="<%= session.getAttribute("username") %>">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="window.location.href='mainMenu.jsp'">Close</button>
                        <button type="submit" class="btn btn-success">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%
        } else {
            out.println("<div class='alert alert-danger text-center'>Error: Item tidak ditemukan!</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger text-center'>Error: Tidak dapat mengambil data dari database.</div>");
    } finally {
        db.disconnect();
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var editModal = new bootstrap.Modal(document.getElementById('editItemModal'));
        editModal.show();
    });
</script>
</body>
</html>
