package dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get data from JSP form
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        Connection con = null;
        PreparedStatement ps = null;

        try {

            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database connection
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/testdb",
                    "root",
                    ""
            );

            // SQL query
            String sql = "INSERT INTO users(name, email) VALUES (?, ?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);

            // Execute query
            ps.executeUpdate();

            // Send message to JSP
            request.setAttribute(
                    "message",
                    "Registration Successful!"
            );

            // Forward to result.jsp
            request.getRequestDispatcher("result.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "message",
                    "Registration Failed: " + e.getMessage()
            );

            request.getRequestDispatcher("result.jsp")
                   .forward(request, response);

        } finally {

            try {
                if (ps != null) {
                    ps.close();
                }

                if (con != null) {
                    con.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}