package controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // GET PARAMETERS
        String username =
            request.getParameter("username");

        String password =
            request.getParameter("password");

        // VALIDATION
        if(username == null || username.trim().isEmpty() ||
           password == null || password.trim().isEmpty()) {

            response.sendRedirect(
                "login.jsp?error=empty"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "SELECT * FROM users WHERE username=? AND password=?";

            ps = con.prepareStatement(query);

            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if(rs.next()) {

                String role =
                    rs.getString("role");

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
                    "username",
                    username
                );

                session.setAttribute(
                    "role",
                    role.toLowerCase()
                );

                // OPTIONAL
                session.setAttribute(
                    "admin",
                    username
                );

                // SESSION TIMEOUT
                session.setMaxInactiveInterval(
                    30 * 60
                );

                // ROLE-BASED REDIRECT
                if(role.equalsIgnoreCase("admin")) {

                    response.sendRedirect(
                        request.getContextPath() +
                        "/adminDashboard"
                    );

                } else if(role.equalsIgnoreCase("security")) {

                    response.sendRedirect(
                        request.getContextPath() +
                        "/securityDashboard.jsp"
                    );

                } else if(role.equalsIgnoreCase("user")) {

                    response.sendRedirect(
                        request.getContextPath() +
                        "/userDashboard.jsp"
                    );

                } else {

                    response.sendRedirect(
                        "login.jsp?error=invalidrole"
                    );
                }

            } else {

                response.sendRedirect(
                    "login.jsp?error=invalid"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "login.jsp?error=server"
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