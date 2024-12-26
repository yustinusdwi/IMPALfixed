<%-- 
    Document   : processRemoveItems
    Created on : 4 Dec 2024, 10.47.43
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
<%
    // Ambil data dari form
    String partNumber = request.getParameter("partNumber");

    // Cek apakah input valid
    if (partNumber != null && !partNumber.trim().isEmpty()) {
        try {
            // Simpan ke database (contoh query SQL jika menggunakan database)
            // Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "user", "password");
            // String query = "DELETE FROM inventory WHERE part_number = ?";
            // PreparedStatement pstmt = conn.prepareStatement(query);
            // pstmt.setString(1, partNumber);
            // int rowsAffected = pstmt.executeUpdate();

            // Simulasi hasil penghapusan data
            boolean isRemoved = true; // Ubah sesuai hasil database Anda

            if (isRemoved) {
                // Jika berhasil menghapus data
                session.setAttribute("message", "Item with Part Number " + partNumber + " has been successfully removed.");
            } else {
                // Jika data tidak ditemukan
                session.setAttribute("message", "No item found with Part Number " + partNumber + ".");
            }

            // Redirect ke main menu
            response.sendRedirect("mainMenu.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred while removing the item.");
            response.sendRedirect("mainMenu.jsp");
        }
    } else {
        session.setAttribute("message", "Invalid Part Number. Please try again.");
        response.sendRedirect("mainMenu.jsp");
    }
%>
