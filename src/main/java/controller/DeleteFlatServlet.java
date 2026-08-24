package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/deleteFlat")
public class DeleteFlatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if(session == null ||
           session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        String fullFlatNo =
                request.getParameter("flat_no");

        if(fullFlatNo == null ||
           fullFlatNo.trim().isEmpty()){

            response.sendRedirect(
                "flatDetails?msg=Invalid_Flat_Details"
            );

            return;
        }

        fullFlatNo = fullFlatNo.trim();

        String[] parts =
                fullFlatNo.split("-");

        if(parts.length != 2){

            response.sendRedirect(
                "flatDetails?msg=Invalid_Flat_Details"
            );

            return;
        }

        String wing = parts[0];
        String flatNo = parts[1];

        Connection con = null;

        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;

        try{

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            // DELETE FROM TENANTS

            ps1 = con.prepareStatement(
                "DELETE FROM tenants WHERE flat_no=? OR flat_no=?"
            );

            ps1.setString(1, flatNo);
            ps1.setString(2, fullFlatNo);

            ps1.executeUpdate();

            // DELETE FROM MEMBERS

            ps2 = con.prepareStatement(
                "DELETE FROM members WHERE flat_no=? OR flat_no=?"
            );

            ps2.setString(1, flatNo);
            ps2.setString(2, fullFlatNo);

            ps2.executeUpdate();

            // DELETE FROM FLATS

            ps3 = con.prepareStatement(
                "DELETE FROM flats WHERE wing=? AND flat_no=?"
            );

            ps3.setString(1, wing);
            ps3.setString(2, flatNo);

            int deleted =
                    ps3.executeUpdate();

            con.commit();

            if(deleted > 0){

                response.sendRedirect(
                    "flatDetails?msg=Flat_Deleted_Successfully"
                );

            }else{

                response.sendRedirect(
                    "flatDetails?msg=Flat_Not_Found"
                );
            }

        }catch(Exception e){

            e.printStackTrace();

            try{

                if(con != null){

                    con.rollback();
                }

            }catch(Exception ex){

                ex.printStackTrace();
            }

            response.sendRedirect(
                "flatDetails?msg=Database_Error"
            );

        }finally{

            try{

                if(ps1 != null)
                    ps1.close();

                if(ps2 != null)
                    ps2.close();

                if(ps3 != null)
                    ps3.close();

                if(con != null){

                    con.setAutoCommit(true);

                    con.close();
                }

            }catch(Exception e){

                e.printStackTrace();
            }
        }
    }
}