package servlet;

import JDBC.jdbc;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SearchReportServlet")
public class SearchReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cek session (apakah user sudah login)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("LOGINpage.jsp?error=You must log in first.");
            return;
        }

        // Ambil parameter pencarian
        String paramIdBarang = request.getParameter("id_barang");
        String paramNamaBarang = request.getParameter("nama_barang");
        String paramKategori = request.getParameter("kategori");
        String paramDate = request.getParameter("date");
        String paramIdKaryawan = request.getParameter("id_karyawan_input");

        //  query dinamis
        StringBuilder sb = new StringBuilder("SELECT * FROM mengeloladatainventory WHERE 1=1");

        if (paramIdBarang != null && !paramIdBarang.trim().isEmpty()) {
            sb.append(" AND id_barang LIKE '%").append(paramIdBarang).append("%'");
        }
        if (paramNamaBarang != null && !paramNamaBarang.trim().isEmpty()) {
            sb.append(" AND nama_barang LIKE '%").append(paramNamaBarang).append("%'");
        }
        if (paramKategori != null && !paramKategori.trim().isEmpty()) {
            sb.append(" AND kategori LIKE '%").append(paramKategori).append("%'");
        }
        if (paramDate != null && !paramDate.trim().isEmpty()) {
            sb.append(" AND date LIKE '%").append(paramDate).append("%'");
        }
        if (paramIdKaryawan != null && !paramIdKaryawan.trim().isEmpty()) {
            sb.append(" AND id_karyawan_input LIKE '%").append(paramIdKaryawan).append("%'");
        }

        // Jalankan query
        jdbc db = new jdbc();
        ResultSet rs = null;
        rs = db.runQuery(sb.toString());
        // Simpan resultset ke request
        request.setAttribute("resultSet", rs);
        // Forward ke JSP (printReport.jsp)
        RequestDispatcher dispatcher = request.getRequestDispatcher("printReport.jsp");
        dispatcher.forward(request, response);
        db.disconnect();
    }
}
