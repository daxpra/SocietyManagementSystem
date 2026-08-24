package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/ApproveRejectServlet")
public class ApproveRejectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
        request.getSession(false);

        if(session == null ||
           session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        String action =
        request.getParameter("action");

        String id =
        request.getParameter("notification_id");

        if(action == null || id == null){

            response.sendRedirect(
            "viewNotifications?msg=Invalid Request");

            return;
        }

        String status = "";

        if(action.equalsIgnoreCase("approve")){

            status = "Approved";

        }else{

            status = "Rejected";
        }

        Connection con = null;

        try{

            con = DBConnection.getConnection();

            /* GET OLD NOTIFICATION */

            PreparedStatement getPs =
            con.prepareStatement(

            "SELECT * FROM notifications WHERE id=?"

            );

            getPs.setInt(1,
            Integer.parseInt(id));

            ResultSet rs =
            getPs.executeQuery();

            String flatNo = "";

            if(rs.next()){

                flatNo =
                rs.getString("flat_no");
            }

            /* UPDATE STATUS */

            PreparedStatement ps =
            con.prepareStatement(

            "UPDATE notifications SET status=? WHERE id=?"

            );

            ps.setString(1, status);

            ps.setInt(2,
            Integer.parseInt(id));

            ps.executeUpdate();

            /* ADD NEW USER NOTIFICATION */

            PreparedStatement insertPs =
            con.prepareStatement(

            "INSERT INTO notifications(title,message,receiver_role,sender_role,status,flat_no) VALUES(?,?,?,?,?,?)"

            );

            insertPs.setString(1,
            "Visitor Request " + status);

            insertPs.setString(2,
            "Your visitor request has been "
            + status);

            insertPs.setString(3,
            "user");

            insertPs.setString(4,
            "security");

            insertPs.setString(5,
            status);

            insertPs.setString(6,
            flatNo);

            insertPs.executeUpdate();

            response.sendRedirect(
            "viewNotifications?msg=Updated Successfully");

        }catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
            "viewNotifications?msg=Database Error");
        }
    }
}