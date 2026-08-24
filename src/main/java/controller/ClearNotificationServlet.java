package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/ClearNotificationServlet")
public class ClearNotificationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET ROLE
        String role =
            (String) session.getAttribute("role");

        // VALIDATION
        if(role == null || role.trim().isEmpty()){

            response.sendRedirect(
                "viewNotifications?msg=Invalid Role"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "DELETE FROM notifications WHERE receiver_role=?";

            ps = con.prepareStatement(query);

            ps.setString(1, role);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "viewNotifications?msg=Notifications Cleared"
                );

            } else {

                response.sendRedirect(
                    "viewNotifications?msg=No Notifications Found"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "viewNotifications?msg=Database Error"
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