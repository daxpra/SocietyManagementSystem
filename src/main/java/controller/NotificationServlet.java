package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import model.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session =
            request.getSession(false);

        if(session == null ||
           session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET DATA
        String message =
            request.getParameter("message");

        String receiver =
            request.getParameter("receiver");

        // VALIDATION
        if(message == null ||
           message.trim().isEmpty() ||
           receiver == null ||
           receiver.trim().isEmpty()) {

            response.sendRedirect(
                "adminDashboard?msg=Invalid Input"
            );
            return;
        }

        // MESSAGE LENGTH LIMIT
        if(message.length() > 500){

            response.sendRedirect(
                "adminDashboard?msg=Message Too Long"
            );
            return;
        }

        // VALID RECEIVERS
        if(!(receiver.equalsIgnoreCase("all") ||
             receiver.equalsIgnoreCase("user") ||
             receiver.equalsIgnoreCase("security"))) {

            response.sendRedirect(
                "adminDashboard?msg=Invalid Receiver"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // SENDER
            String sender =
                (String) session.getAttribute("username");

            if(sender == null){
                sender = "admin";
            }

            // =========================
            // SEND TO ALL
            // =========================

            if(receiver.equalsIgnoreCase("all")) {

                // USER
                ps = con.prepareStatement(
                    "INSERT INTO notifications(message, sender_role, receiver_role) VALUES (?, ?, ?)"
                );

                ps.setString(1, message);
                ps.setString(2, sender);
                ps.setString(3, "user");

                ps.executeUpdate();

                ps.close();

                // SECURITY
                ps = con.prepareStatement(
                    "INSERT INTO notifications(message, sender_role, receiver_role) VALUES (?, ?, ?)"
                );

                ps.setString(1, message);
                ps.setString(2, sender);
                ps.setString(3, "security");

                ps.executeUpdate();
            }

            // =========================
            // SINGLE ROLE
            // =========================

            else {

                ps = con.prepareStatement(
                    "INSERT INTO notifications(message, sender_role, receiver_role) VALUES (?, ?, ?)"
                );

                ps.setString(1, message);
                ps.setString(2, sender);
                ps.setString(3, receiver.toLowerCase());

                ps.executeUpdate();
            }

            // COMMIT
            con.commit();

            response.sendRedirect(
                "adminDashboard?msg=Notification Sent"
            );

        } catch(Exception e){

            e.printStackTrace();

            try {

                if(con != null)
                    con.rollback();

            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "adminDashboard?msg=Database Error"
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