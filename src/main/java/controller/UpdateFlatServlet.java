package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/updateFlat")
public class UpdateFlatServlet extends HttpServlet {

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

        // PARAMETERS

        String flatNo =
                request.getParameter("flat_no");

        String wing =
                request.getParameter("wing");

        String name =
                request.getParameter("name");

        String residentType =
                request.getParameter("resident_type");

        // VALIDATION

        if(flatNo == null ||
           wing == null ||
           name == null ||
           residentType == null ||

           flatNo.trim().isEmpty() ||
           wing.trim().isEmpty() ||
           name.trim().isEmpty()){

            response.sendRedirect(
                "flatDetails?msg=Invalid_Input"
            );

            return;
        }

        // CLEAN VALUES

        flatNo = flatNo.trim();

        wing = wing.trim();

        name = name.trim();

        residentType = residentType.trim();

        // FULL FLAT NUMBER

        String fullFlatNo =
                wing + flatNo;

        Connection con = null;

        PreparedStatement ps = null;

        try{

            con = DBConnection.getConnection();

            // DEBUG

            System.out.println(
                "Flat No : " + fullFlatNo
            );

            System.out.println(
                "Name : " + name
            );

            System.out.println(
                "Type : " + residentType
            );

            // OWNER INSERT

            if(residentType.equals("Owner")){

                ps = con.prepareStatement(

                "INSERT INTO members(name,flat_no,wing,block) VALUES(?,?,?,?)"

                );

                ps.setString(1, name);

                ps.setString(2, fullFlatNo);

                ps.setString(3, wing);

                ps.setString(4, wing);

            }

            // TENANT INSERT

            else{

                ps = con.prepareStatement(

                "INSERT INTO tenants(name,flat_no,block) VALUES(?,?,?)"

                );

                ps.setString(1, name);

                ps.setString(2, fullFlatNo);

                ps.setString(3, wing);
            }

            // EXECUTE

            int rows =
                    ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(

                    "flatDetails?msg=Flat_Updated_Successfully"
                );

            }else{

                response.sendRedirect(

                    "flatDetails?msg=Update_Failed"
                );
            }

        }catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(

                "flatDetails?msg=Database_Error"
            );

        }finally{

            try{

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();

            }catch(Exception e){

                e.printStackTrace();
            }
        }
    }
}