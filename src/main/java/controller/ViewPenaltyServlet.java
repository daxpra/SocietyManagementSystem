package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/penaltymaster")
public class ViewPenaltyServlet extends HttpServlet {

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

        List<Map<String, String>> penaltyList =
            new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM penalty_master ORDER BY id DESC";

            ps = con.prepareStatement(query);

            rs = ps.executeQuery();

            while(rs.next()) {

                Map<String, String> map =
                    new HashMap<>();

                map.put(
                    "id",
                    rs.getString("id")
                );

                map.put(
                    "start_date",
                    rs.getString("start_date")
                );

                map.put(
                    "type",
                    rs.getString("type")
                );

                map.put(
                    "amount",
                    rs.getString("amount")
                );

                map.put(
                    "photo",
                    rs.getString("photo")
                );

                // ✅ FIXED
                map.put(
                    "flat_no",
                    rs.getString("flat_no")
                );

                // ✅ FIXED
                map.put(
                    "total_maintenance",
                    rs.getString("total_maintenance")
                );

                penaltyList.add(map);
            }

            request.setAttribute(
                "penaltyList",
                penaltyList
            );

            request.getRequestDispatcher(
                "/penaltymaster.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Penalty Load Error"
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