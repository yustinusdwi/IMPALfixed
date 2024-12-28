/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SearchStaffServlet")
public class SearchStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cek session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("LOGINpage.jsp?error=You must log in first.");
            return;
        }

        jdbc db = new jdbc();
        Connection conn = null;
        ResultSet rs = null;

        conn = db.getConnection(); 
        String searchQuery = request.getParameter("search");
        StringBuilder sb = new StringBuilder("SELECT * FROM pengguna");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Filter berdasarkan username
            sb.append(" WHERE username LIKE '%").append(searchQuery).append("%'");
        }
        rs = db.runQuery(sb.toString());
        request.setAttribute("resultSet", rs);
        // Forward ke kelolaStaff.jsp untuk menampilkan data
        RequestDispatcher rd = request.getRequestDispatcher("kelolaStaff.jsp");
        rd.forward(request, response);
        db.disconnect();
    }
}
