package model;

import java.sql.Connection; 
import java.sql.DriverManager;


public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;

        try {
            System.out.println("Trying DB connection...");

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/society_management",
                "root",
                ""
            );

            System.out.println("DB CONNECTED SUCCESS ✅");

        } catch (Exception e) {
            System.out.println("DB ERROR ❌");
            e.printStackTrace();
        }

        return con;
    }
}