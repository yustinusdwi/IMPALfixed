/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Arahkan pengguna ke halaman login
        RequestDispatcher dispatcher = request.getRequestDispatcher("/LOGINpage.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validasi login (ganti dengan logika autentikasi yang sesuai)
        if ("admin".equals(username) && "password".equals(password)) {
            // Redirect ke halaman utama setelah login berhasil
            response.sendRedirect("mainMenu.jsp");
        } else {
            // Redirect kembali ke halaman login jika login gagal
            response.sendRedirect("LOGINpage.jsp?error=true");
        }
    }
}

