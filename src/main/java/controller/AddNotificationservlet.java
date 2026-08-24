package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addNotification")
public class AddNotificationservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String receiver = request.getParameter("receiver_role");

        // FIXED SENDER
        String sender = "admin";

        // VALIDATION
        if(title == null || title.trim().isEmpty() ||
           message == null || message.trim().isEmpty() ||
           receiver == null || receiver.trim().isEmpty()) {

            response.sendRedirect(
                "manageNotifications.jsp?msg=Please Fill All Fields"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "INSERT INTO notifications(title, message, sender_role, receiver_role) VALUES (?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, title);
            ps.setString(2, message);
            ps.setString(3, sender);
            ps.setString(4, receiver);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "manageNotifications.jsp?msg=Notification Sent Successfully"
                );

            } else {

                response.sendRedirect(
                    "manageNotifications.jsp?msg=Notification Not Sent"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "manageNotifications.jsp?msg=Database Error"
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