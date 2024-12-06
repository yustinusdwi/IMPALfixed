<%-- 
    Document   : removeItems
    Created on : 4 Dec 2024, 10.45.52
    Author     : nbpav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Remove Items - InvenTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        .header {
            position: fixed;
            top: 0%;
            display: flex;
            align-items: center;
            background-color: #4b6cb7;
            color: white;
            padding: 15px 30px;
            width: 100%;
            justify-content: space-between;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .header img {
            height: 50px;
        }

        .header h1 {
            font-size: 28px;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
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

        .form-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            animation: slideUp 1s ease-out;
        }

        .form-container h1 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        .btn-submit {
            background-color: #dc3545;
            color: white;
            padding: 12px;
            width: 100%;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-submit:hover {
            background-color: #a71d2a;
            transform: translateY(-2px);
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

        @keyframes slideUp {
            0% {
                opacity: 0;
                transform: translateY(30px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="<%= request.getContextPath() %>/logo" alt="InvenTrack Logo">
        <h1>InvenTrack - Remove Item</h1>
    </div>
    <div class="form-container">
        <h1>Remove Item</h1>
        <form method="post" action="processRemoveItems.jsp">
            <div class="form-group">
                <label for="partNumber">Part Number</label>
                <input type="text" id="partNumber" name="partNumber" required placeholder="Enter Part Number">
            </div>
            <button type="submit" class="btn-submit">Remove Item</button>
        </form>
        <a href="mainMenu.jsp">
            <button class="back-button">Kembali ke Main Menu</button>
        </a>
    </div>
</body>
</html>


