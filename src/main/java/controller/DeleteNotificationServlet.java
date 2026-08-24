package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/deleteNotification")
public class DeleteNotificationServlet extends HttpServlet {

    // GET METHOD
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        deleteNotification(request, response);
    }

    // POST METHOD
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        deleteNotification(request, response);
    }

    // COMMON METHOD
    private void deleteNotification(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // GET ID
        String id = request.getParameter("id");

        // VALIDATION
        if (id == null || id.trim().isEmpty()) {

            response.sendRedirect(
                "manageNotifications.jsp?msg=Invalid Notification"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            int notificationId = Integer.parseInt(id);

            con = DBConnection.getConnection();

            String query =
                "DELETE FROM notifications WHERE id=?";

            ps = con.prepareStatement(query);

            ps.setInt(1, notificationId);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                response.sendRedirect(
                    "manageNotifications.jsp?msg=Notification Deleted"
                );

            } else {

                response.sendRedirect(
                    "manageNotifications.jsp?msg=Notification Not Found"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                "manageNotifications.jsp?msg=Invalid ID"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "manageNotifications.jsp?msg=Database Error"
            );

        } finally {

            try {

                if (ps != null)
                    ps.close();

                if (con != null)
                    con.close();

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }
}