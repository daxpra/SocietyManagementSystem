package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addPayment")
public class PaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session =
            request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            // PARAMETERS
            String flatNo =
                request.getParameter("flat_no");

            String amountStr =
                request.getParameter("amount");

            String penaltyStr =
                request.getParameter("penalty");

            String txnType =
                request.getParameter("transaction_type");

            String txnNo =
                request.getParameter("transaction_no");

            String date =
                request.getParameter("invoice_date");

            // VALIDATION
            if(flatNo == null || flatNo.trim().isEmpty() ||
               amountStr == null || amountStr.trim().isEmpty()) {

                response.sendRedirect(
                    "maintenance.jsp?msg=Invalid Input"
                );
                return;
            }

            // PARSE NUMBERS
            double amount =
                Double.parseDouble(amountStr);

            double penalty = 0;

            if(penaltyStr != null &&
               !penaltyStr.trim().isEmpty()) {

                penalty =
                    Double.parseDouble(penaltyStr);
            }

            // CALCULATIONS
            double total =
                amount + penalty;

            con = DBConnection.getConnection();

            // INSERT QUERY
            String query =
                "INSERT INTO payments(flat_no, amount, penalty, total_amount, status, payment_date, transaction_type, transaction_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, flatNo);

            ps.setDouble(2, amount);

            ps.setDouble(3, penalty);

            ps.setDouble(4, total);

            // ✅ FIXED PARAMETER 5
            String status =
            		request.getParameter("status");

            		ps.setString(5, status);

            ps.setString(6, date);

            ps.setString(7, txnType);

            ps.setString(8, txnNo);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "maintenance.jsp?msg=Payment Success"
                );

            } else {

                response.sendRedirect(
                    "maintenance.jsp?msg=Payment Failed"
                );
            }

        } catch(NumberFormatException e){

            response.sendRedirect(
                "maintenance.jsp?msg=Invalid Amount"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "maintenance.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}