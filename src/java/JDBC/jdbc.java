/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package JDBC;

/**
 *
 * @author nbpav
 */

import model.Inventory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class jdbc {
    Connection con;
    Statement stmt;
    public boolean isConnected;
    public String message;

    public jdbc() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

//            String url = "jdbc:mysql://localhost:3307/inventorymanagement";
            String url = "jdbc:mysql://mysql-11e7911d-yustinus134-1596.e.aivencloud.com:16286/defaultdb";
            String user = "avnadmin";
            String password = "AVNS_gm-WtZCbSmaeGPAKus4";
            con = DriverManager.getConnection(url, user, password);
            stmt = con.createStatement();
            isConnected = true;
            message = "DB connected";
        } catch (Exception e) {
            isConnected = false;
            message = "DB gagal dikoneksi :"+e.getMessage();
            e.printStackTrace();
        }
    }
    
    public Connection getConnection() {
        return con;
    }

    public void disconnect() {
         try {
            if (stmt != null) {
                stmt.close();
            }
            if (con != null) {
                con.close();
            }
            message = "DB disconnected";
            System.out.println(message);
        } catch (Exception e) {
            message = "Error during disconnection: " + e.getMessage();
            System.err.println(message);
        }
    }

    public ResultSet runQuery(String query) {
        ResultSet rs = null;
        try {
            if (stmt != null) {
                rs = stmt.executeQuery(query);
            } else {
                message = "Statement is null. Query cannot be executed.";
                System.err.println(message);
            }
        } catch (SQLException e) {
            message = "Error executing query: " + e.getMessage();
            System.err.println(message);
        }
        return rs;
    }


    public int runUpdate(String query) {
        int result = 0;
        try {
            if (stmt != null) {
                result = stmt.executeUpdate(query);
            } else {
                message = "Statement is null. Update cannot be executed.";
                System.err.println(message);
            }
        } catch (Exception e) {
            message = "Error executing update: " + e.getMessage();
            System.err.println(message);
        }
        return result;
    }
}
