package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/VisitorRequestServlet")
public class VisitorRequestServlet extends HttpServlet {

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

        // ROLE CHECK
        String role =
            (String) session.getAttribute("role");

        if(role == null ||
           !role.equalsIgnoreCase("security")) {

            response.sendRedirect("login.jsp");
            return;
        }

        // PARAMETERS
        String name =
            request.getParameter("visitor_name");

        String flat =
            request.getParameter("flat_no");

        String purpose =
            request.getParameter("purpose");

        // VALIDATION
        if(name == null || name.trim().isEmpty() ||
           flat == null || flat.trim().isEmpty()) {

            response.sendRedirect(
                "securityDashboard?msg=Invalid Input"
            );
            return;
        }

        // CLEAN INPUT
        name = name.trim();
        flat = flat.trim();

        if(purpose != null){
            purpose = purpose.trim();
        }

        Connection con = null;

        PreparedStatement psCheck = null;
        PreparedStatement ps = null;

        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // =========================
            // CHECK FLAT EXISTS
            // =========================

            psCheck = con.prepareStatement(
                "SELECT * FROM flats WHERE flat_no=?"
            );

            psCheck.setString(1, flat);

            rs = psCheck.executeQuery();

            if(!rs.next()) {

                response.sendRedirect(
                    "securityDashboard?msg=Invalid Flat"
                );
                return;
            }

            rs.close();
            psCheck.close();

            // =========================
            // CREATE MESSAGE
            // =========================

            String message =
                "Visitor " + name +
                " wants to visit Flat " +
                flat +
                " for " + purpose;

            // =========================
            // INSERT NOTIFICATION
            // =========================

            ps = con.prepareStatement(
                "INSERT INTO notifications(message, sender_role, receiver_role, status) VALUES (?, ?, ?, ?)"
            );

            ps.setString(1, message);

            ps.setString(2, "security");

            ps.setString(3, "user");

            // BETTER DEFAULT STATUS
            ps.setString(4, "pending");

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "securityDashboard?msg=Request Sent"
                );

            } else {

                response.sendRedirect(
                    "securityDashboard?msg=Insert Failed"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "securityDashboard?msg=Database Error"
            );

        } finally {

            try {

                if(rs != null)
                    rs.close();

                if(psCheck != null)
                    psCheck.close();

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