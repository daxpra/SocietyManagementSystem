package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addBill")
public class AddBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String flat = request.getParameter("flat");
        String amountStr = request.getParameter("amount");

        // VALIDATION
        if(flat == null || flat.trim().isEmpty() ||
           amountStr == null || amountStr.trim().isEmpty()){

            response.sendRedirect("dashboard?msg=Invalid Input");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            double amount = Double.parseDouble(amountStr);

            conn = DBConnection.getConnection();

            String query = "INSERT INTO bills(flat_no, amount, status) VALUES(?,?,?)";

            ps = conn.prepareStatement(query);

            ps.setString(1, flat);
            ps.setDouble(2, amount);
            ps.setString(3, "Unpaid");

            int rows = ps.executeUpdate();

            if(rows > 0){
                response.sendRedirect("dashboard?msg=Bill Added Successfully");
            } else {
                response.sendRedirect("dashboard?msg=Bill Not Added");
            }

        } catch(NumberFormatException e){

            e.printStackTrace();
            response.sendRedirect("dashboard?msg=Invalid Amount");

        } catch(Exception e){

            e.printStackTrace();
            response.sendRedirect("dashboard?msg=Database Error");

        } finally {

            try {
                if(ps != null)
                    ps.close();

                if(conn != null)
                    conn.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}