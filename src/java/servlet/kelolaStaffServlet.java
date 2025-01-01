/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
/**
 *
 * @author nbpav
 */
package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "kelolaStaffServlet", urlPatterns = {"/kelolaStaffServlet"})
public class kelolaStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jdbc db = new jdbc();
        String action = request.getParameter("action");

        try {
            if (action != null && action.equals("delete")) {
                // DELETE: Hapus staff berdasarkan id_pengguna
                String id_pengguna = request.getParameter("id_pengguna");

                // Log input yang diterima
                System.out.println("Attempting to delete user with ID: " + id_pengguna);

                String query = "DELETE FROM pengguna WHERE id_pengguna = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                    stmt.setString(1, id_pengguna);

                    int rowsDeleted = stmt.executeUpdate();
                    System.out.println("Rows deleted: " + rowsDeleted);

                    if (rowsDeleted > 0) {
                        response.sendRedirect(request.getContextPath() + "/kelolaStaff.jsp?status=deleted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/kelolaStaff.jsp?status=not_found");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/kelolaStaff.jsp?status"+e);
                }
            } else {
                // VIEW: Tampilkan semua data pengguna
                ResultSet rs = db.runQuery("SELECT * FROM pengguna");
                request.setAttribute("resultSet", rs);
                request.getRequestDispatcher("/kelolaStaff.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/kelolaStaff.jsp?status=error");
        } finally {
            db.disconnect();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            jdbc db = new jdbc();
            String status = "error"; // Default status
            String action = request.getParameter("action");

            try (Connection conn = db.getConnection()) {
                if (action == null || "create".equals(action)) {
                    // Ambil data dari form input
                    String id_pengguna = request.getParameter("id_pengguna");
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    String address = request.getParameter("address");
                    String jenis_kelamin = request.getParameter("jenis_kelamin");
                    String no_telp = request.getParameter("no_telp");
                    String role_name = request.getParameter("role"); // Role ID, '1' atau '2'

                    // Validasi role
                    if (!role_name.equals("1") && !role_name.equals("2")) {
                        response.sendRedirect("addStaff.jsp?status=invalid_role");
                        return;
                    }

                    int roleId = Integer.parseInt(role_name);

                    // Tambahkan ke tabel Pengguna
                    String penggunaQuery = "INSERT INTO pengguna (id_pengguna, username, password, address, jenis_kelamin, no_telp, role) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement penggunaStmt = conn.prepareStatement(penggunaQuery)) {
                        penggunaStmt.setString(1, id_pengguna);
                        penggunaStmt.setString(2, username);
                        penggunaStmt.setString(3, password);
                        penggunaStmt.setString(4, address);
                        penggunaStmt.setString(5, jenis_kelamin);
                        penggunaStmt.setString(6, no_telp);
                        penggunaStmt.setInt(7, roleId);
                        penggunaStmt.executeUpdate();
                    }

                    // Tambahkan ke tabel khusus berdasarkan role
                    if (roleId == 1) {
                        // Role = 1: Tambahkan ke tabel Karyawan dan KelolaStaff
                        insertIfNotExists(conn, "karyawan", "id_karyawan", id_pengguna);
                        insertIfNotExists(conn, "kelolastaff", "id_pengguna", id_pengguna);
                    } else if (roleId == 2) {
                        // Role = 2: Tambahkan ke tabel Owner
                        insertIfNotExists(conn, "Owner", "id_owner", id_pengguna);
                    }

                    status = "success";
                    response.sendRedirect("addStaff.jsp?status=success");

                } else if ("edit".equals(action)) {
                    // UPDATE: Perbarui data pengguna
                    String id_pengguna = request.getParameter("id_pengguna");
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    String address = request.getParameter("address");
                    String jenis_kelamin = request.getParameter("jenis_kelamin");
                    String no_telp = request.getParameter("no_telp");
                    String role_name = request.getParameter("role"); // Role ID, '1' atau '2'

                    if (!role_name.equals("1") && !role_name.equals("2")) {
                        response.sendRedirect("editStaff.jsp?status=invalid_role&id_pengguna=" + id_pengguna);
                        return;
                    }

                    int roleId = Integer.parseInt(role_name);

                    // Query UPDATE
                    String penggunaQuery;
                    if (password != null && !password.isEmpty()) {
                        penggunaQuery = "UPDATE pengguna SET username = ?, password = ?, address = ?, jenis_kelamin = ?, no_telp = ?, role = ? WHERE id_pengguna = ?";
                    } else {
                        penggunaQuery = "UPDATE pengguna SET username = ?, address = ?, jenis_kelamin = ?, no_telp = ?, role = ? WHERE id_pengguna = ?";
                    }

                    // Update tabel Pengguna
                    try (PreparedStatement stmt = conn.prepareStatement(penggunaQuery)) {
                        int paramIndex = 1;
                        stmt.setString(paramIndex++, username);
                        if (password != null && !password.isEmpty()) {
                            stmt.setString(paramIndex++, password);
                        }
                        stmt.setString(paramIndex++, address);
                        stmt.setString(paramIndex++, jenis_kelamin);
                        stmt.setString(paramIndex++, no_telp);
                        stmt.setInt(paramIndex++, roleId);
                        stmt.setString(paramIndex++, id_pengguna);
                        stmt.executeUpdate();
                    }

                    // Tambahkan logika untuk tabel role jika role berubah
                    if (roleId == 1) {
                        // Role = 1: Tambahkan ke tabel Karyawan dan KelolaStaff
                        insertIfNotExists(conn, "karyawan", "id_karyawan", id_pengguna);
                        insertIfNotExists(conn, "kelolastaff", "id_pengguna", id_pengguna);
                    } else if (roleId == 2) {
                        // Role = 2: Tambahkan ke tabel Owner
                        insertIfNotExists(conn, "owner", "id_owner", id_pengguna);
                    }

                    status = "updated";
                    response.sendRedirect("editStaff.jsp?id_pengguna=" + id_pengguna + "&status=updated");
                }
            } catch (Exception e) {
                e.printStackTrace();
                status = "error";
                response.sendRedirect("addStaff.jsp?status=" + e.getMessage());
            } finally {
                db.disconnect();
            }
    }
    private void insertIfNotExists(Connection conn, String tableName, String columnName, String value) throws SQLException {
    // Query untuk memeriksa apakah data sudah ada
        String checkQuery = "SELECT COUNT(*) FROM " + tableName + " WHERE " + columnName + " = ?";
        try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            checkStmt.setString(1, value);
            ResultSet rs = checkStmt.executeQuery();

            // Jika data belum ada, lakukan INSERT
            if (rs.next() && rs.getInt(1) == 0) {
                String insertQuery = "INSERT INTO " + tableName + " (" + columnName + ") VALUES (?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                    insertStmt.setString(1, value);
                    insertStmt.executeUpdate();
                    System.out.println("Data inserted into table " + tableName + " with " + columnName + " = " + value);
                }
            } else {
                System.out.println("Data already exists in table " + tableName + " with " + columnName + " = " + value);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing user data in Pengguna table.";
    }
    
}
