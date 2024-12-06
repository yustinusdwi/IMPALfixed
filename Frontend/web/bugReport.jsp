<%-- 
    Document   : bugReport
    Created on : 4 Dec 2024, 13.04.14
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            background: url("<%= request.getContextPath() %>/background") no-repeat center center fixed; /* Gambar background */
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
            top: 0%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
            background: linear-gradient(90deg, #4b6cb7, #182848); 
            color: white;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 28px;
        }

        .container {
            width: 100%;
            max-width: 900px;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            text-align: center;
        }

        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
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

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
            }

            .container {
                padding: 20px;
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
        <p>Hanya Jika anda menemukan bug pada website ini, anda bisa menghubungi petugas kami yang menangani bug tersebut.</p>

        <!-- Button linking to WhatsApp with the phone number -->
        <a href="https://wa.me/+6281929786327?text=Hello,%20I%20need%20help%20with%20a%20bug" class="whatsapp-btn">
            Hubungi Kami
        </a>

        <div class="number">
            <p>Jika ada kendala pada tautan diatas, anda dapat menghubungi nomor berikut</p>
            <p><strong>085299699662</strong></p>
        </div>

        <!-- Updated back button with the latest design -->
        <a href="<%= session.getAttribute("role").equals("owner") ? "mainMenuOwner.jsp" : "mainMenu.jsp" %>">
            <button class="back-button">Kembali ke Main Menu</button>
        </a>
    </div>
</body>
</html>

