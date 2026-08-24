package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/exitVisitor")
public class ExitVisitorServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET ID
        String idParam = request.getParameter("id");

        // VALIDATION
        if(idParam == null || idParam.trim().isEmpty()){

            response.sendRedirect(
                "visitorHistory?msg=Invalid Visitor"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            int id = Integer.parseInt(idParam);

            con = DBConnection.getConnection();

            String sql =
                "UPDATE visitors SET exit_time = NOW() WHERE id=? AND exit_time IS NULL";

            ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "visitorHistory?msg=Visitor Exit Updated"
                );

            } else {

                response.sendRedirect(
                    "visitorHistory?msg=Visitor Already Exited Or Not Found"
                );
            }

        } catch(NumberFormatException e){

            response.sendRedirect(
                "visitorHistory?msg=Invalid ID"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "visitorHistory?msg=Database Error"
            );

        } finally {

            try {

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