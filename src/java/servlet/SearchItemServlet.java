package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SearchItemServlet")  // Pastikan mapping sesuai dengan pengaturan web.xml atau anotasi
public class SearchItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cek session apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("LOGINpage.jsp?error=You must log in first.");
            return;
        }

        // Ambil username dari session
        String username = (String) session.getAttribute("username");
        if (username == null || username.isEmpty()) {
            response.sendRedirect("LOGINpage.jsp?error=Session expired.");
            return;
        }

        jdbc db = new jdbc();
        Connection conn = null;
        
        try {
            conn = db.getConnection();
            
            // Cari role pengguna (1 = karyawan, 2 = owner)
            String role = null;
            String findRoleQuery = "SELECT role FROM pengguna WHERE username = ?";
            try (PreparedStatement findRoleStmt = conn.prepareStatement(findRoleQuery)) {
                findRoleStmt.setString(1, username);
                try (ResultSet roleRs = findRoleStmt.executeQuery()) {
                    if (roleRs.next()) {
                        role = roleRs.getString("role");
                    } else {
                        response.sendRedirect("LOGINpage.jsp?error=User not found.");
                        return;
                    }
                }
            }
            System.out.println(role);
            // Ambil parameter 'search'
            String searchQuery = request.getParameter("search");
            ResultSet rs;

            // Jika searchQuery null atau kosong, tampilkan semua data
            if (searchQuery == null || searchQuery.trim().isEmpty()) {
                String sql = "SELECT * FROM mengeloladatainventory";
                rs = db.runQuery(sql);
            } else {
                // Jika searchQuery diisi, lakukan pencarian berdasarkan id_barang atau nama_barang
                String sql = "SELECT * FROM mengeloladatainventory "
                           + "WHERE id_barang LIKE '%" + searchQuery + "%' "
                           + "OR nama_barang LIKE '%" + searchQuery + "%'";
                rs = db.runQuery(sql);
            }

            // Simpan hasil ke request agar bisa diambil di JSP
            request.setAttribute("resultSet", rs);
            
            // Tentukan mau forward ke mana berdasarkan role
            if ("1".equals(role)) {
                // Role 1: Karyawan -> mainMenu.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("/mainMenu.jsp");
                dispatcher.forward(request, response);
            } else if ("2".equals(role)) {
                // Role 2: Owner -> mainMenuOwner.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("/mainMenuOwner.jsp");
                dispatcher.forward(request, response);
            } else {
                // Role tidak valid
                response.sendRedirect("LOGINpage.jsp?error=Invalid role.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LOGINpage.jsp?error=" + e.getMessage());
        } finally {
            db.disconnect();
        }
    }
}
