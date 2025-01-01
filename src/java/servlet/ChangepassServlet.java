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
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */
@WebServlet(name = "ChangepassServlet", urlPatterns = {"/ChangepassServlet"})
public class ChangepassServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String errorMessage = null;
        String successMessage = null;

        jdbc db = new jdbc();
        if (!db.isConnected) {
            errorMessage = "Database connection failed: " + db.message;
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("changePass.jsp").forward(request, response);
            return;
        }

        try {
            // Verifikasi username dan password lama
            String checkPasswordQuery = "SELECT password FROM pengguna WHERE username = '" + username + "'";
            ResultSet rs = db.runQuery(checkPasswordQuery);

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (!storedPassword.equals(currentPassword)) {
                    errorMessage = "Current password is incorrect.";
                } else if (!newPassword.equals(confirmPassword)) {
                    errorMessage = "New password and confirmation do not match.";
                } else {
                    // Update password di database
                    String updatePasswordQuery = "UPDATE Pengguna SET password = '" + newPassword + "' WHERE username = '" + username + "'";
                    int rowsUpdated = db.runUpdate(updatePasswordQuery);

                    if (rowsUpdated > 0) {
                        successMessage = "Password changed successfully!";
                    } else {
                        errorMessage = "Failed to update the password.";
                    }
                }
            } else {
                errorMessage = "User not found.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "An error occurred while processing your request: " + e.getMessage();
        } finally {
            db.disconnect();
        }

        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("successMessage", successMessage);
        request.getRequestDispatcher("changePass.jsp").forward(request, response);
    }
}
