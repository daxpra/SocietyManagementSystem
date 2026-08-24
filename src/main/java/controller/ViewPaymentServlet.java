package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/viewPayments")
public class ViewPaymentServlet extends HttpServlet {

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

        List<Map<String, Object>> paymentList =
            new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // STATUS FILTER
            String status =
                request.getParameter("status");

            // VALIDATION
            if(status != null &&
               !(status.equalsIgnoreCase("Paid") ||
                 status.equalsIgnoreCase("Pending") ||
                 status.equalsIgnoreCase("all"))) {

                response.sendRedirect(
                    "maintenance.jsp?msg=Invalid Status"
                );
                return;
            }

            String query =
                "SELECT * FROM payments";

            if(status != null &&
               !status.equalsIgnoreCase("all")) {

                query +=
                    " WHERE status=?";
            }

            // ORDERING
            query +=
                " ORDER BY id DESC";

            ps = con.prepareStatement(query);

            if(status != null &&
               !status.equalsIgnoreCase("all")) {

                ps.setString(1, status);
            }

            rs = ps.executeQuery();

            while(rs.next()) {

                Map<String, Object> map =
                    new HashMap<>();

                map.put(
                    "id",
                    rs.getInt("id")
                );

                map.put(
                    "flat_no",
                    rs.getString("flat_no")
                );

                map.put(
                    "payment_date",
                    rs.getString("payment_date")
                );

                map.put(
                    "amount",
                    rs.getDouble("amount")
                );

                map.put(
                    "penalty",
                    rs.getDouble("penalty")
                );

                map.put(
                	    "total_amount",
                	    rs.getDouble("total_amount")
                	);

                	map.put(
                	    "status",
                	    rs.getString("status")
                	);
                	
                map.put(
                    "transaction_type",
                    rs.getString("transaction_type")
                );

                map.put(
                    "transaction_no",
                    rs.getString("transaction_no")
                );

                paymentList.add(map);
            }

            // SEND DATA
            request.setAttribute(
                "paymentList",
                paymentList
            );

            request.getRequestDispatcher(
                "/maintenance.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "maintenance.jsp?msg=Payment Load Error"
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