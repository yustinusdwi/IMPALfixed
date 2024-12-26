package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        jdbc db = new jdbc();
        String role = null;
        boolean isAuthenticated = false;

        try (Connection conn = db.getConnection()) {
            // Query untuk memvalidasi username dan password
            String query = "SELECT Role.role_name AS role " +
                           "FROM Pengguna " +
                           "JOIN Role ON Pengguna.role = Role.id " +
                           "WHERE Pengguna.username = ? AND Pengguna.password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            if (conn == null) {
                System.out.println("Failed to establish a database connection.");
            }

            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    isAuthenticated = true;
                    role = rs.getString("role");
                }
            }

            if (isAuthenticated) {
                // Hapus sesi lama jika ada
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // Buat sesi baru
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("username", username);
                newSession.setAttribute("role", role);

                // Redirect berdasarkan role
                if ("owner".equalsIgnoreCase(role)) {
                    response.sendRedirect("mainMenuOwner.jsp");
                } else if ("karyawan".equalsIgnoreCase(role)) {
                    response.sendRedirect("mainMenu.jsp");
                }
            } else {
                // Jika username/password salah
                response.sendRedirect("LOGINpage.jsp?error=Invalid username or password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("LOGINpage.jsp?error=An error occurred. Please try again.");
        } finally {
            db.disconnect();
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling user login.";
    }
}
