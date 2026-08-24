package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/VisitorActionServlet")
public class VisitorActionServlet extends HttpServlet {

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
           !(role.equalsIgnoreCase("user") ||
             role.equalsIgnoreCase("admin"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;

        PreparedStatement ps1 = null;

        PreparedStatement ps2 = null;

        try {

            // PARAMETERS

            String idParam =
                request.getParameter("requestId");

            String action =
                request.getParameter("action");

            // VALIDATION

            if(idParam == null ||
               idParam.trim().isEmpty() ||
               action == null ||
               action.trim().isEmpty()) {

                response.sendRedirect(
                    "usernotification.jsp?msg=Invalid Request"
                );
                return;
            }

            // VALID ACTION

            if(!(action.equalsIgnoreCase("approve") ||
                 action.equalsIgnoreCase("reject"))) {

                response.sendRedirect(
                    "usernotification.jsp?msg=Invalid Action"
                );
                return;
            }

            int id =
                Integer.parseInt(idParam);

            // STATUS

            String status =
                action.equalsIgnoreCase("approve")
                ? "Approved"
                : "Rejected";

            con = DBConnection.getConnection();

            // =========================
            // UPDATE NOTIFICATION
            // =========================

            String query1 =
                "UPDATE notifications SET status=? WHERE id=?";

            ps1 = con.prepareStatement(query1);

            ps1.setString(1, status);

            ps1.setInt(2, id);

            ps1.executeUpdate();

            // =========================
            // UPDATE VISITOR STATUS
            // =========================

            String query2 =
                "UPDATE visitors SET status=? ORDER BY id DESC LIMIT 1";

            ps2 = con.prepareStatement(query2);

            ps2.setString(1, status);

            ps2.executeUpdate();

            response.sendRedirect(
                "usernotification.jsp?msg=Updated"
            );

        } catch(NumberFormatException e){

            response.sendRedirect(
                "usernotification.jsp?msg=Invalid ID"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "usernotification.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(ps1 != null)
                    ps1.close();

                if(ps2 != null)
                    ps2.close();

                if(con != null)
                    con.close();

            } catch(Exception e){

                e.printStackTrace();
            }
        }
    }
}

