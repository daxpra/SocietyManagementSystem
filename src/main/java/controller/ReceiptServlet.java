package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/receipt")
public class ReceiptServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session =
            request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET ID
        String idParam =
            request.getParameter("id");

        // VALIDATION
        if(idParam == null ||
           idParam.trim().isEmpty()) {

            response.sendRedirect(
                "maintenance.jsp?msg=Invalid Receipt"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            int id =
                Integer.parseInt(idParam);

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM payments WHERE id=?";

            ps = con.prepareStatement(query);

            ps.setInt(1, id);

            rs = ps.executeQuery();

            if(rs.next()) {

                // SET ATTRIBUTES
                request.setAttribute(
                    "flat_no",
                    rs.getString("flat_no")
                );

                request.setAttribute(
                    "amount",
                    rs.getDouble("amount")
                );

                request.setAttribute(
                    "penalty",
                    rs.getDouble("penalty")
                );

                request.setAttribute(
                    "total_amount",
                    rs.getDouble("total_amount")
                );

                request.setAttribute(
                    "payment_date",
                    rs.getString("payment_date")
                );

                request.setAttribute(
                    "transaction_type",
                    rs.getString("transaction_type")
                );

                request.setAttribute(
                    "transaction_no",
                    rs.getString("transaction_no")
                );

                // FORWARD TO JSP
                request.getRequestDispatcher(
                    "/receipt.jsp"
                ).forward(request, response);

            } else {

                response.sendRedirect(
                    "maintenance.jsp?msg=Receipt Not Found"
                );
            }

        } catch(NumberFormatException e){

            response.sendRedirect(
                "maintenance.jsp?msg=Invalid ID"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "maintenance.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(rs != null)
                    rs.close();

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