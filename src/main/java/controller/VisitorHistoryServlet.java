package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/visitorHistory")
public class VisitorHistoryServlet extends HttpServlet {

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

        // ROLE CHECK
        String role =
            (String) session.getAttribute("role");

        if(role == null ||
           !(role.equalsIgnoreCase("security") ||
             role.equalsIgnoreCase("admin"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, String>> list =
            new ArrayList<>();

        String search =
            request.getParameter("search");

        String filter =
            request.getParameter("filter");

        // CLEAN INPUT
        if(search != null){
            search = search.trim();
        }

        // FILTER VALIDATION
        if(filter != null &&
           !(filter.equalsIgnoreCase("today") ||
             filter.equalsIgnoreCase("all"))) {

            filter = "all";
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                "SELECT * FROM visitors WHERE 1=1";

            // =========================
            // SEARCH
            // =========================

            if(search != null &&
               !search.isEmpty()) {

                sql +=
                    " AND (name LIKE ? OR vehicle_no LIKE ?)";
            }

            // =========================
            // TODAY FILTER
            // =========================

            if("today".equalsIgnoreCase(filter)) {

                sql +=
                    " AND DATE(entry_time)=CURDATE()";
            }

            // ORDERING
            sql +=
                " ORDER BY id DESC";

            ps = con.prepareStatement(sql);

            int index = 1;

            // SEARCH PARAMETERS
            if(search != null &&
               !search.isEmpty()) {

                ps.setString(
                    index++,
                    "%" + search + "%"
                );

                ps.setString(
                    index++,
                    "%" + search + "%"
                );
            }

            rs = ps.executeQuery();

            while(rs.next()) {

                Map<String, String> map =
                    new HashMap<>();

                map.put(
                    "id",
                    rs.getString("id")
                );

                map.put(
                    "name",
                    rs.getString("name")
                );

                map.put(
                    "mobile",
                    rs.getString("mobile")
                );

                map.put(
                    "flat",
                    rs.getString("flat_no")
                );

                map.put(
                    "vehicle",
                    rs.getString("vehicle_no")
                );

                map.put(
                    "purpose",
                    rs.getString("purpose")
                );

                map.put(
                    "entry_time",
                    rs.getString("entry_time")
                );

                // ✅ ADDED
                map.put(
                    "exit_time",
                    rs.getString("exit_time")
                );

                list.add(map);
            }

            request.setAttribute(
                "visitorList",
                list
            );

            request.getRequestDispatcher(
                "/visitorHistory.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "securityDashboard?msg=Visitor Load Error"
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