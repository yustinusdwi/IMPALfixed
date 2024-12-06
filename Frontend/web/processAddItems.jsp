<%-- 
    Document   : processAddItems
    Created on : 4 Dec 2024, 10.33.46
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Ambil data dari form
    String itemName = request.getParameter("itemName");
    String quantity = request.getParameter("quantity");
    String storeType = request.getParameter("storeType");
    String location = request.getParameter("location");

    // Simpan ke database (contoh query SQL jika menggunakan database)
    // Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "user", "password");
    // String query = "INSERT INTO inventory (item_name, quantity, store_type, location) VALUES (?, ?, ?, ?)";
    // PreparedStatement pstmt = conn.prepareStatement(query);
    // pstmt.setString(1, itemName);
    // pstmt.setInt(2, Integer.parseInt(quantity));
    // pstmt.setString(3, storeType);
    // pstmt.setString(4, location);
    // pstmt.executeUpdate();

    // Redirect kembali ke main menu
    response.sendRedirect("mainMenu.jsp");
%>

