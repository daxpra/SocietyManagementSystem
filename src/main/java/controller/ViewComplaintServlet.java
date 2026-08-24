package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/viewComplaint")
public class ViewComplaintServlet extends HttpServlet {

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

        List<String[]> list =
            new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM complaints ORDER BY id DESC";

            ps = con.prepareStatement(query);

            rs = ps.executeQuery();

            while(rs.next()) {

                list.add(new String[]{

                    rs.getString("id"),

                    rs.getString("title"),

                    rs.getString("description"),

                    rs.getString("status")
                });
            }

            request.setAttribute(
                "complaintList",
                list
            );

            request.getRequestDispatcher(
                "/viewComplaint.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Complaint Load Error"
            );

        } finally {

            try {

                if(rs != null)
                    rs.close();

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