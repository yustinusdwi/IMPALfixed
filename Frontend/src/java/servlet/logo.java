package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/logo")
public class logo extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("image/jpeg");

        // Mengambil gambar dari folder "images" di dalam aplikasi.
        InputStream inputStream = getServletContext().getResourceAsStream("/images/logoIMPAL.jpg");
        if (inputStream == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // Kirim error jika gambar tidak ditemukan.
            return;
        }

        OutputStream outputStream = response.getOutputStream();
        byte[] buffer = new byte[1024];
        int bytesRead;

        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }

        inputStream.close();
        outputStream.close();
    }
}
