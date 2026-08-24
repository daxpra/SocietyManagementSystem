package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/updateBill")
public class UpdateBillServlet extends HttpServlet {

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

        // GET ID
        String idParam =
            request.getParameter("id");

        // VALIDATION
        if(idParam == null ||
           idParam.trim().isEmpty()) {

            response.sendRedirect(
                "dashboard?msg=Invalid Bill"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            int id =
                Integer.parseInt(idParam);

            con = DBConnection.getConnection();

            String query =
                "UPDATE bills SET status='Paid' WHERE id=? AND status!='Paid'";

            ps = con.prepareStatement(query);

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "dashboard?msg=Bill Paid Successfully"
                );

            } else {

                response.sendRedirect(
                    "dashboard?msg=Bill Already Paid Or Not Found"
                );
            }

        } catch(NumberFormatException e){

            response.sendRedirect(
                "dashboard?msg=Invalid ID"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "dashboard?msg=Database Error"
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

    // OPTIONAL SUPPORT FOR GET

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }
}