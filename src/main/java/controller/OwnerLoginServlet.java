package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;
import model.Member;

@WebServlet("/ownerLogin")
public class OwnerLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // GET PARAMETERS
        String flatNo =
            request.getParameter("flatNo");

        String phone =
            request.getParameter("mobile");

        // VALIDATION
        if(flatNo == null || flatNo.trim().isEmpty() ||
           phone == null || phone.trim().isEmpty()) {

            response.sendRedirect(
                "ownerLogin.jsp?error=empty"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM members WHERE flat_no=? AND phone=?";

            ps = con.prepareStatement(query);

            ps.setString(1, flatNo);
            ps.setString(2, phone);

            rs = ps.executeQuery();

            if(rs.next()) {

                // CREATE MEMBER OBJECT
                Member m = new Member();

                m.setFlatNo(
                    rs.getString("flat_no")
                );

                m.setName(
                    rs.getString("name")
                );

                // REMOVE OLD SESSION
                HttpSession oldSession =
                    request.getSession(false);

                if(oldSession != null){
                    oldSession.invalidate();
                }

                // CREATE NEW SESSION
                HttpSession session =
                    request.getSession(true);

                session.setAttribute(
                    "owner",
                    m
                );

                // OPTIONAL ROLE
                session.setAttribute(
                    "role",
                    "user"
                );

                // SESSION TIMEOUT
                session.setMaxInactiveInterval(
                    30 * 60
                );

                response.sendRedirect(
                    request.getContextPath() +
                    "/userdashboard.jsp"
                );

            } else {

                response.sendRedirect(
                    "ownerLogin.jsp?error=invalid"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "ownerLogin.jsp?error=server"
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