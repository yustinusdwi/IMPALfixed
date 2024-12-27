<%-- 
    Document   : bugReport
    Created on : 4 Dec 2024, 13.04.14
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.reset(); // Hapus output buffer
        response.sendRedirect("LOGINpage.jsp?error=You must log in first.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bug Report - InvenTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f7f9fc;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            animation: fadeIn 1s ease-out;
            background-size: cover;
        }

        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: inherit;
            filter: blur(3px);
            z-index: -1;
        }

        .header {
            position: fixed;
            top: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
            background: linear-gradient(90deg, #4b6cb7, #182848);
            color: white;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            height: 80px; /* Menambahkan tinggi tetap */
        }

        .header img {
            height: 70px;
            max-width: 100%; /* Menjamin gambar tetap proporsional */
        }

        .header h1 {
            font-size: 28px;
            text-align: center;
            flex: 1; /* Memberi ruang proporsional */
        }

        .container {
            width: 90%; /* Menggunakan persentase untuk responsivitas */
            max-width: 900px;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            margin-top: 120px; /* Memberi jarak cukup dari header */
            text-align: center;
        }

        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }

        .whatsapp-btn {
            background-color: #25D366;
            color: white;
            padding: 12px 24px;
            font-size: 18px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            text-decoration: none;
            margin-top: 20px;
            display: inline-block;
        }

        .whatsapp-btn:hover {
            background-color: #128C7E;
            transform: translateY(-2px);
        }

        .whatsapp-btn:active {
            transform: translateY(2px);
        }

        .number {
            font-size: 18px;
            margin-top: 15px;
            color: #555;
        }

        .back-button {
            background-color: #dc3545;
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            margin-top: 30px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .back-button:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .back-button:active {
            transform: translateY(2px);
        }

        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(30px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsivitas */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: center; /* Header lebih responsif */
                height: auto; /* Header fleksibel di layar kecil */
                padding: 10px;
            }

            .header img {
                height: 40px; /* Ukuran gambar lebih kecil di layar sempit */
            }

            .header h1 {
                font-size: 22px; /* Ukuran teks lebih kecil di layar sempit */
                margin-top: 10px;
            }

            .container {
                padding: 20px;
                margin-top: 150px; /* Jarak tambahan untuk header fleksibel */
            }

            h2 {
                font-size: 20px;
            }

            .whatsapp-btn, .back-button {
                font-size: 16px; /* Ukuran tombol disesuaikan */
                padding: 10px 20px;
            }

            .number {
                font-size: 16px;
            }
        }

        @media (max-width: 576px) {
            .header {
                padding: 10px 15px;
            }

            .header h1 {
                font-size: 18px;
            }

            .container {
                padding: 15px;
                margin-top: 160px;
            }

            h2 {
                font-size: 18px;
            }

            .whatsapp-btn, .back-button {
                font-size: 14px;
                padding: 8px 16px;
            }

            .number {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - Bug Report</h1>
    </div>

    <div class="container">
        <h2>Bug Report</h2>
        <p>Only if you encounter a bug on this website, you can contact our staff responsible for handling the bug.</p>

        <a href="https://wa.me/+6285175138441?text=Hello,%20I%20need%20help%20with%20a%20bug" class="whatsapp-btn">
            Contact us
        </a>

        <div class="number">
            <p>If there are any problems with the green button above, you can contact the following number.</p>
            <p><strong>085299699662</strong></p>
        </div>

        <!-- Updated back button with the latest design -->
        <a href="<%= session.getAttribute("role").equals("owner") ? "mainMenuOwner.jsp" : "mainMenu.jsp" %>">
            <button class="back-button">Back to Main Menu</button>
        </a>
    </div>
</body>
</html>

