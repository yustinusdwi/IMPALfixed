/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "inventoryServlet", urlPatterns = {"/inventoryServlet"})
public class inventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jdbc db = new jdbc();
        String action = request.getParameter("action");

        try {
            // Ambil username dari session
            String username = (String) request.getSession().getAttribute("username");
            if (username == null || username.isEmpty()) {
                response.sendRedirect("LOGINpage.jsp?error=Session expired.");
                return;
            }

            // Cari role pengguna
            String role = null;
            String findRoleQuery = "SELECT role FROM pengguna WHERE username = ?";
            try (Connection conn = db.getConnection();
                 PreparedStatement findRoleStmt = conn.prepareStatement(findRoleQuery)) {
                findRoleStmt.setString(1, username);
                ResultSet roleRs = findRoleStmt.executeQuery();
                if (roleRs.next()) {
                    role = roleRs.getString("role");
                } else {
                    response.sendRedirect("LOGINpage.jsp?error=User not found.");
                    return;
                }
            }

            // Tampilkan data berdasarkan role pengguna
            ResultSet rs;
            if ("1".equals(role)) { // Role 1: Karyawan
                String karyawanQuery = "SELECT * FROM mengeloladatainventory WHERE id_karyawan_input = ?";
                try (Connection conn = db.getConnection();
                     PreparedStatement karyawanStmt = conn.prepareStatement(karyawanQuery)) {
                    karyawanStmt.setString(1, username);
                    rs = karyawanStmt.executeQuery();
                }

                // Set data untuk mainMenu.jsp
                request.setAttribute("resultSet", rs);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/mainMenu.jsp");
                dispatcher.forward(request, response);
            } else if ("2".equals(role)) { // Role 2: Owner
                String ownerQuery = "SELECT * FROM mengeloladatainventory";
                rs = db.runQuery(ownerQuery); // Owner dapat melihat semua data

                // Set data untuk mainMenuOwner.jsp
                request.setAttribute("resultSet", rs);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/mainMenuOwner.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("mainMenu.jsp?error=Invalid role.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/mainMenu.jsp");
        } finally {
            db.disconnect();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jdbc db = new jdbc();
        String action = request.getParameter("action");
        String status = ""; // Status untuk notifikasi

        try (Connection conn = db.getConnection()) {
            // Ambil username dari session
            String username = (String) request.getSession().getAttribute("username");
            if (username == null || username.isEmpty()) {
                response.sendRedirect("LOGINpage.jsp?error=Session expired.");
                return;
            }

            // Cari id_karyawan berdasarkan username
            String id_karyawan_input = null;
            String findKaryawanQuery = "SELECT id_pengguna FROM pengguna WHERE username = ?";
            try (PreparedStatement findStmt = conn.prepareStatement(findKaryawanQuery)) {
                findStmt.setString(1, username);
                ResultSet rs = findStmt.executeQuery();
                if (rs.next()) {
                    id_karyawan_input = rs.getString("id_pengguna");
                } else {
                    response.sendRedirect("mainMenu.jsp?status=invalid_user");
                    return;
                }
            }

            if ("create".equals(action)) {
                String id_barang = request.getParameter("id_barang");
                String nama_barang = request.getParameter("nama_barang");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String kategori = request.getParameter("kategori");
                String supplier = request.getParameter("supplier");
                String date = request.getParameter("date");
                if (date == null || date.isEmpty()) {
                    date = new java.sql.Timestamp(System.currentTimeMillis()).toString();
                }

                // Periksa ID barang unik
                String checkQuery = "SELECT COUNT(*) FROM mengeloladatainventory WHERE id_barang = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                    checkStmt.setString(1, id_barang);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        response.sendRedirect(request.getContextPath() + "/addItems.jsp?status=duplicate");
                        return;
                    }
                }

                // Tambah barang baru
                String query = "INSERT INTO mengeloladatainventory (id_barang, nama_barang, quantity, kategori, supplier, date, id_karyawan_input) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, id_barang);
                    stmt.setString(2, nama_barang);
                    stmt.setInt(3, quantity);
                    stmt.setString(4, kategori);
                    stmt.setString(5, supplier);
                    stmt.setString(6, date);
                    stmt.setString(7, id_karyawan_input);

                    if (stmt.executeUpdate() > 0) {
                        response.sendRedirect(request.getContextPath() + "/addItems.jsp?status=success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/addItems.jsp?status=error");
                    }
                }
            } else if ("update".equals(action)) {
                // Update barang
                String id_barang = request.getParameter("id_barang");
                String nama_barang = request.getParameter("nama_barang");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String kategori = request.getParameter("kategori");
                String supplier = request.getParameter("supplier");
                String date = request.getParameter("date");
                if (date == null || date.isEmpty()) {
                    date = new java.sql.Timestamp(System.currentTimeMillis()).toString();
                }

                System.out.println("Updating data with ID: " + id_barang);

                String query = "UPDATE mengeloladatainventory SET nama_barang = ?, quantity = ?, kategori = ?, supplier = ?, date = ?, id_karyawan_input = ? WHERE id_barang = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, nama_barang);
                    stmt.setInt(2, quantity);
                    stmt.setString(3, kategori);
                    stmt.setString(4, supplier);
                    stmt.setString(5, date);
                    stmt.setString(6, id_karyawan_input);
                    stmt.setString(7, id_barang);

                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        System.out.println("Update successful for ID: " + id_barang);
                        response.sendRedirect(request.getContextPath() + "/mainMenu.jsp?status=has_been_edited");
                    } else {
                        System.out.println("No rows updated for ID: " + id_barang);
                        response.sendRedirect(request.getContextPath() + "/mainMenu.jsp?status=error");
                    }
                }
            } else if ("delete".equals(action)) {
                // Hapus barang
                String id_barang = request.getParameter("id_barang");
                System.out.println("Deleting data with ID: " + id_barang);

                String query = "DELETE FROM mengeloladatainventory WHERE id_barang = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, id_barang);

                    int rowsDeleted = stmt.executeUpdate();
                    if (rowsDeleted > 0) {
                        System.out.println("Delete successful for ID: " + id_barang);
                        response.sendRedirect(request.getContextPath() + "/mainMenu.jsp?status=deleted");
                    } else {
                        System.out.println("No rows deleted for ID: " + id_barang);
                        response.sendRedirect(request.getContextPath() + "/mainMenu.jsp?status=error");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/mainMenu.jsp?status=error");
        } finally {
            db.disconnect();
        }
    }


    @Override
    public String getServletInfo() {
        return "Servlet for managing inventory data.";
    }
}
