package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBConnection;

@WebServlet("/flatDetails")
public class flatDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("admin") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            List<Map<String, String>> flatList =
                    new ArrayList<>();

            // GET FILTER
            String wing =
                    request.getParameter("wing");

            if (wing != null) {

                wing = wing.trim();
            }

            // SQL QUERY
            String sql =
            		"SELECT DISTINCT " +
            		"f.flat_no, " +
            		"CONCAT(f.wing,'-',TRIM(f.flat_no)) AS display_flat_no, " +

            		"COALESCE(m.name,'-') AS owner_name, " +

            		"COALESCE(t.name,'-') AS tenant_name, " +
										
					"CASE " +
					"WHEN m.name IS NOT NULL AND t.name IS NOT NULL THEN 'Owner + Tenant' " +
					"WHEN t.name IS NOT NULL THEN 'Rented' " +
					"WHEN m.name IS NOT NULL THEN 'Owner Occupied' " +
					"ELSE 'Vacant' " +
					"END AS status " +
					
            		"FROM flats f " +

            		"LEFT JOIN members m " +
            		"ON CONCAT(f.wing,TRIM(f.flat_no)) = TRIM(m.flat_no)" +

            		"LEFT JOIN tenants t " +
            		"ON CONCAT(f.wing,TRIM(f.flat_no)) = TRIM(t.flat_no)" +
					
					"WHERE f.flat_no IS NOT NULL " +
					"AND TRIM(f.flat_no) <> '' " +
					"AND f.wing IS NOT NULL " +
					"AND TRIM(f.wing) <> '' ";
            // FILTER
            if (wing != null && !wing.isEmpty()) {

            	sql += " AND f.wing = ? ";
            }

            // ORDER
            sql += "ORDER BY f.wing, f.flat_no";

            ps = con.prepareStatement(sql);

            // SET FILTER
            if (wing != null && !wing.isEmpty()) {

                ps.setString(1, wing);
            }

            rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, String> map =
                        new HashMap<>();

                map.put(
                    "flat_no",
                    rs.getString("flat_no")
                );

                map.put(
                    "display_flat_no",
                    rs.getString("display_flat_no")
                );

                map.put(
                    "owner",
                    rs.getString("owner_name")
                );

                map.put(
                    "tenant",
                    rs.getString("tenant_name")
                );

                map.put(
                    "status",
                    rs.getString("status")
                );

                flatList.add(map);
            }

            // SEND DATA TO JSP
            request.setAttribute(
                "flatList",
                flatList
            );

            request.getRequestDispatcher(
                "/flatDetails.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Database_Error"
            );

        } finally {

            try {

                if (rs != null)
                    rs.close();

                if (ps != null)
                    ps.close();

                if (con != null)
                    con.close();

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }
}