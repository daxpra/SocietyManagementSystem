package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addVisitor")
public class AddVisitorServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){
            response.sendRedirect("login.jsp");
            return;
        }

        // PARAMETERS
        String name = request.getParameter("visitor_name");
        String phone = request.getParameter("phone");
        String purpose = request.getParameter("purpose");
        String house = request.getParameter("house_no");

        // VALIDATION
        if(name == null || name.trim().isEmpty() ||
           phone == null || phone.trim().isEmpty() ||
           purpose == null || purpose.trim().isEmpty() ||
           house == null || house.trim().isEmpty()) {

            response.sendRedirect(
                "addVisitor.jsp?msg=Please Fill All Fields"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "INSERT INTO visitor (visitor_name, phone, purpose, house_no) VALUES (?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, purpose);
            ps.setString(4, house);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    "visitorHistory.jsp?msg=Visitor Added Successfully"
                );

            } else {

                response.sendRedirect(
                    "addVisitor.jsp?msg=Visitor Not Added"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "addVisitor.jsp?msg=Database Error"
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