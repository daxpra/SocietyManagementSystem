package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/editFlat")
public class EditFlatServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if(session == null ||
           session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        String flatNo = request.getParameter("flat_no");
        String wing = request.getParameter("wing");

        if(flatNo == null || wing == null){

            response.sendRedirect("flatDetails");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{

            con = DBConnection.getConnection();

            String sql =
                "SELECT * FROM flats WHERE flat_no=? AND wing=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, flatNo);
            ps.setString(2, wing);

            rs = ps.executeQuery();

            if(rs.next()){

                request.setAttribute(
                    "flat_no",
                    rs.getString("flat_no")
                );

                request.setAttribute(
                    "wing",
                    rs.getString("wing")
                );

                request.setAttribute(
                    "owner_name",
                    rs.getString("owner_name")
                );

                RequestDispatcher rd =
                    request.getRequestDispatcher(
                        "/editFlat.jsp"
                    );

                rd.forward(request,response);

            }else{

                response.sendRedirect(
                    "flatDetails?msg=Flat_Not_Found"
                );
            }

        }catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "flatDetails?msg=Database_Error"
            );

        }finally{

            try{

                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                if(con!=null) con.close();

            }catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}