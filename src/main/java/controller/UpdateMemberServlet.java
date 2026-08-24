package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/updateMember")
public class UpdateMemberServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
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

        String owner =
            request.getParameter("owner");

        String tenant =
            request.getParameter("tenant");

        // VALIDATION
        if(flatNo == null ||
           flatNo.trim().isEmpty() ||
           owner == null ||
           owner.trim().isEmpty()) {

            response.sendRedirect(
                "flatDetails?msg=Invalid Input"
            );
            return;
        }

        // CLEAN INPUT
        flatNo = flatNo.trim();
        owner = owner.trim();

        if(tenant != null){
            tenant = tenant.trim();
        }

        Connection con = null;

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // =========================
            // OWNER CHECK
            // =========================

            ps = con.prepareStatement(
                "SELECT * FROM members WHERE flat_no=?"
            );

            ps.setString(1, flatNo);

            rs = ps.executeQuery();

            if(rs.next()) {

                rs.close();
                ps.close();

                // UPDATE OWNER
                ps = con.prepareStatement(
                    "UPDATE members SET name=? WHERE flat_no=?"
                );

                ps.setString(1, owner);
                ps.setString(2, flatNo);

                ps.executeUpdate();

            } else {

                rs.close();
                ps.close();

                // INSERT OWNER
                ps = con.prepareStatement(
                    "INSERT INTO members(name, flat_no) VALUES (?, ?)"
                );

                ps.setString(1, owner);
                ps.setString(2, flatNo);

                ps.executeUpdate();
            }

            ps.close();

            // =========================
            // TENANT CHECK
            // =========================

            ps = con.prepareStatement(
                "SELECT * FROM tenants WHERE flat_no=?"
            );

            ps.setString(1, flatNo);

            rs = ps.executeQuery();

            boolean tenantExists =
                rs.next();

            rs.close();
            ps.close();

            // =========================
            // DELETE TENANT
            // =========================

            if(tenant == null ||
               tenant.isEmpty()) {

                ps = con.prepareStatement(
                    "DELETE FROM tenants WHERE flat_no=?"
                );

                ps.setString(1, flatNo);

                ps.executeUpdate();
            }

            // =========================
            // UPDATE TENANT
            // =========================

            else if(tenantExists) {

                ps = con.prepareStatement(
                    "UPDATE tenants SET name=? WHERE flat_no=?"
                );

                ps.setString(1, tenant);
                ps.setString(2, flatNo);

                ps.executeUpdate();
            }

            // =========================
            // INSERT TENANT
            // =========================

            else {

                ps = con.prepareStatement(
                    "INSERT INTO tenants(name, flat_no) VALUES (?, ?)"
                );

                ps.setString(1, tenant);
                ps.setString(2, flatNo);

                ps.executeUpdate();
            }

            // COMMIT
            con.commit();

            response.sendRedirect(
                "flatDetails?msg=Member Updated Successfully"
            );

        } catch(Exception e){

            e.printStackTrace();

            try {

                if(con != null)
                    con.rollback();

            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "flatDetails?msg=Database Error"
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