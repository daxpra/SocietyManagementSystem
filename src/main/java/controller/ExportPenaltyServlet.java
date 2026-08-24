package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/exportPenalty")
public class ExportPenaltyServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv");

        response.setHeader(
            "Content-Disposition",
            "attachment; filename=PenaltyDetails.csv"
        );

        PrintWriter out = response.getWriter();

        // CSV HEADER
        out.println(
            "Start Date,Penalty Type,Charge Per Day,Flat No,Total Maintenance"
        );

        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            st = con.createStatement();

            rs = st.executeQuery(
                "SELECT * FROM penalties"
            );

            while(rs.next()) {

                out.println(
                    rs.getString("start_date") + "," +
                    rs.getString("penalty_type") + "," +
                    rs.getString("charge_per_day") + "," +
                    rs.getString("flat_no") + "," +
                    rs.getString("total_maintenance")
                );
            }

        } catch(Exception e) {

            e.printStackTrace();

        } finally {

            try {

                if(rs != null)
                    rs.close();

                if(st != null)
                    st.close();

                if(con != null)
                    con.close();

            } catch(Exception e) {

                e.printStackTrace();
            }
        }
    }
}