package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/editMember")
public class EditMemberServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET PARAMETER
        String flatNo = request.getParameter("flat_no");

        // VALIDATION
        if(flatNo == null || flatNo.trim().isEmpty()){

            response.sendRedirect(
                "adminDashboard?msg=Invalid Flat Number"
            );
            return;
        }

        Connection con = null;

        PreparedStatement psOwner = null;
        PreparedStatement psTenant = null;

        ResultSet rsOwner = null;
        ResultSet rsTenant = null;

        try {

            con = DBConnection.getConnection();

            // =========================
            // GET OWNER
            // =========================

            String ownerQuery =
                "SELECT * FROM members WHERE flat_no=?";

            psOwner = con.prepareStatement(ownerQuery);

            psOwner.setString(1, flatNo);

            rsOwner = psOwner.executeQuery();

            if(rsOwner.next()){

                request.setAttribute(
                    "owner",
                    rsOwner.getString("name")
                );

            } else {

                request.setAttribute(
                    "owner",
                    ""
                );
            }

            // =========================
            // GET TENANT
            // =========================

            String tenantQuery =
                "SELECT * FROM tenants WHERE flat_no=?";

            psTenant = con.prepareStatement(tenantQuery);

            psTenant.setString(1, flatNo);

            rsTenant = psTenant.executeQuery();

            if(rsTenant.next()){

                request.setAttribute(
                    "tenant",
                    rsTenant.getString("name")
                );

            } else {

                request.setAttribute(
                    "tenant",
                    ""
                );
            }

            // =========================
            // SEND FLAT NUMBER
            // =========================

            request.setAttribute(
                "flat_no",
                flatNo
            );

            // FORWARD
            request.getRequestDispatcher(
                "/editMember.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Database Error"
            );

        } finally {

            try {

                if(rsOwner != null)
                    rsOwner.close();

                if(rsTenant != null)
                    rsTenant.close();

                if(psOwner != null)
                    psOwner.close();

                if(psTenant != null)
                    psTenant.close();

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}