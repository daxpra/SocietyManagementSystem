package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/securityDashboard")
public class SecurityDashboardServlet extends HttpServlet {

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

        // ROLE CHECK
        String role =
            (String) session.getAttribute("role");

        if(role == null ||
           !role.equalsIgnoreCase("security")) {

            response.sendRedirect("login.jsp");
            return;
        }

        int todayVisitors = 0;
        int pendingVisitors = 0;

        Connection con = null;

        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        ResultSet rs1 = null;
        ResultSet rs2 = null;

        try {

            con = DBConnection.getConnection();

            // =========================
            // TODAY VISITORS
            // =========================

            String query1 =
                "SELECT COUNT(*) FROM visitors WHERE DATE(entry_time)=CURDATE()";

            ps1 = con.prepareStatement(query1);

            rs1 = ps1.executeQuery();

            if(rs1.next()) {

                todayVisitors =
                    rs1.getInt(1);
            }

            // =========================
            // PENDING VISITORS
            // =========================

            String query2 =
                "SELECT COUNT(*) FROM visitors WHERE exit_time IS NULL";

            ps2 = con.prepareStatement(query2);

            rs2 = ps2.executeQuery();

            if(rs2.next()) {

                pendingVisitors =
                    rs2.getInt(1);
            }

            // SEND DATA
            request.setAttribute(
                "todayVisitors",
                todayVisitors
            );

            request.setAttribute(
                "pendingVisitors",
                pendingVisitors
            );

            // FORWARD
            RequestDispatcher rd =
                request.getRequestDispatcher(
                    "/securityDashboard.jsp"
                );

            rd.forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "login.jsp?msg=Dashboard Error"
            );

        } finally {

            try {

                if(rs1 != null)
                    rs1.close();

                if(rs2 != null)
                    rs2.close();

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