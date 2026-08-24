package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/ComplaintServlet")
public class ComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // PARAMETERS
        String name = request.getParameter("name");
        String house = request.getParameter("house");
        String message = request.getParameter("message");

        // VALIDATION
        if(name == null || name.trim().isEmpty() ||
           house == null || house.trim().isEmpty() ||
           message == null || message.trim().isEmpty()) {

            response.sendRedirect(
                "complaint.jsp?msg=Please Fill All Fields"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement psNotify = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // INSERT COMPLAINT
            String complaintQuery =
                "INSERT INTO complaints(name, house_no, message, status) VALUES (?, ?, ?, ?)";

            ps = con.prepareStatement(complaintQuery);

            ps.setString(1, name);
            ps.setString(2, house);
            ps.setString(3, message);
            ps.setString(4, "Pending");

            int complaintRows = ps.executeUpdate();

            // INSERT NOTIFICATION
            String notificationQuery =
                "INSERT INTO notifications(message, receiver_role) VALUES (?, ?)";

            psNotify = con.prepareStatement(notificationQuery);

            psNotify.setString(
                1,
                "New complaint from " + name
            );

            psNotify.setString(2, "admin");

            psNotify.executeUpdate();

            // COMMIT
            con.commit();

            if(complaintRows > 0){

                response.sendRedirect(
                    "complaint.jsp?success=1"
                );

            } else {

                response.sendRedirect(
                    "complaint.jsp?msg=Complaint Not Submitted"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            try {

                if(con != null)
                    con.rollback();

            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "complaint.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(psNotify != null)
                    psNotify.close();

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