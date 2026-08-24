package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/deleteMember")
public class DeleteMemberServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
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

        PreparedStatement psTenant = null;
        PreparedStatement psMember = null;
        PreparedStatement psOwner = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // DELETE TENANT
            psTenant = con.prepareStatement(
                "DELETE FROM tenants WHERE flat_no=?"
            );

            psTenant.setString(1, flatNo);

            psTenant.executeUpdate();

            // DELETE MEMBER
            psMember = con.prepareStatement(
                "DELETE FROM members WHERE flat_no=?"
            );

            psMember.setString(1, flatNo);

            int memberRows = psMember.executeUpdate();

            // DELETE OWNER
            psOwner = con.prepareStatement(
                "DELETE FROM owners WHERE flat_no=?"
            );

            psOwner.setString(1, flatNo);

            psOwner.executeUpdate();

            // COMMIT
            con.commit();

            if(memberRows > 0){

                response.sendRedirect(
                    "adminDashboard?msg=Member Deleted Successfully"
                );

            } else {

                response.sendRedirect(
                    "adminDashboard?msg=Member Not Found"
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
                "adminDashboard?msg=Database Error"
            );

        } finally {

            try {

                if(psTenant != null)
                    psTenant.close();

                if(psMember != null)
                    psMember.close();

                if(psOwner != null)
                    psOwner.close();

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}