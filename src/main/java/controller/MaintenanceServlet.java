package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/generateMaintenance")
public class MaintenanceServlet extends HttpServlet {

    // HANDLE GET
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            "maintenance.jsp"
        );
    }

    // HANDLE POST
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

        // PARAMETERS
        String type =
            request.getParameter("type");

        String flatNo =
            request.getParameter("flat_no");

        String pdf =
            request.getParameter("pdf");

        // DYNAMIC AMOUNT
        int amount = 1000;

        // VALIDATION
        if(type == null || type.trim().isEmpty()){

            response.sendRedirect(
                "maintenance.jsp?msg=Invalid Type"
            );
            return;
        }

        Connection con = null;

        Statement st = null;
        ResultSet rs = null;

        PreparedStatement psInsert = null;
        PreparedStatement psCheck = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // =========================
            // GENERATE FOR ALL FLATS
            // =========================

            if("all".equalsIgnoreCase(type)) {

                st = con.createStatement();

                rs = st.executeQuery(
                    "SELECT flat_no FROM flats"
                );

                while(rs.next()) {

                    String f =
                        rs.getString("flat_no");

                    // DUPLICATE CHECK
                    psCheck = con.prepareStatement(
                        "SELECT * FROM maintenance WHERE flat_no=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())"
                    );

                    psCheck.setString(1, f);

                    ResultSet checkRs =
                        psCheck.executeQuery();

                    if(!checkRs.next()) {

                        psInsert = con.prepareStatement(
                            "INSERT INTO maintenance(flat_no, amount, status) VALUES (?, ?, ?)"
                        );

                        // ✅ FIXED
                        psInsert.setString(1, f);

                        psInsert.setInt(2, amount);

                        psInsert.setString(3, "Pending");

                        psInsert.executeUpdate();

                        psInsert.close();
                    }

                    checkRs.close();
                    psCheck.close();
                }
            }

            // =========================
            // SINGLE FLAT
            // =========================

            else if("single".equalsIgnoreCase(type)) {

                if(flatNo == null ||
                   flatNo.trim().isEmpty()) {

                    response.sendRedirect(
                        "maintenance.jsp?msg=Flat Required"
                    );
                    return;
                }

                // CHECK DUPLICATE
                psCheck = con.prepareStatement(
                    "SELECT * FROM maintenance WHERE flat_no=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())"
                );

                psCheck.setString(1, flatNo);

                ResultSet checkRs =
                    psCheck.executeQuery();

                if(checkRs.next()) {

                    response.sendRedirect(
                        "maintenance.jsp?msg=Already Generated"
                    );

                    checkRs.close();
                    return;
                }

                checkRs.close();

                // INSERT
                psInsert = con.prepareStatement(
                    "INSERT INTO maintenance(flat_no, amount, status) VALUES (?, ?, ?)"
                );

                psInsert.setString(1, flatNo);

                psInsert.setInt(2, amount);

                psInsert.setString(3, "Pending");

                psInsert.executeUpdate();
            }

            else {

                response.sendRedirect(
                    "maintenance.jsp?msg=Invalid Option"
                );
                return;
            }

            // COMMIT
            con.commit();

            // PDF REDIRECT
            if("yes".equalsIgnoreCase(pdf)) {

                response.sendRedirect(
                    "receipt.jsp?flat_no=" + flatNo
                );

            } else {

                response.sendRedirect(
                    "maintenance.jsp?msg=Generated"
                );
            }

        } catch(Exception e) {

            e.printStackTrace();

            try {

                if(con != null)
                    con.rollback();

            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "maintenance.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(rs != null)
                    rs.close();

                if(st != null)
                    st.close();

                if(psInsert != null)
                    psInsert.close();

                if(psCheck != null)
                    psCheck.close();

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}