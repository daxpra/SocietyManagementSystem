package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/viewNotifications")
public class ViewNotificationServlet extends HttpServlet {

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

        // GET USER ROLE
        String role =
            (String) session.getAttribute("role");

        if(role == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // NOTIFICATION LIST
        List<Map<String, String>> notifications =
            new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM notifications WHERE receiver_role=? ORDER BY id DESC";

            ps = con.prepareStatement(query);

            ps.setString(1, role);

            rs = ps.executeQuery();

            while(rs.next()) {

                Map<String, String> map =
                    new HashMap<>();

                map.put(
                    "id",
                    rs.getString("id")
                );

                map.put(
                    "message",
                    rs.getString("message")
                );

                map.put(
                    "sender_role",
                    rs.getString("sender_role")
                );

                map.put(
                    "receiver_role",
                    rs.getString("receiver_role")
                );

                map.put(
                    "status",
                    rs.getString("status")
                );

                notifications.add(map);
            }

            // SEND TO JSP
            request.setAttribute(
                "notificationList",
                notifications
            );

            request.getRequestDispatcher(
                "/viewNotifications.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Notification Load Error"
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