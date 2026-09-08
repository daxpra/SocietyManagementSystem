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

            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database Connection
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/testdb",
                    "root",
                    ""
            );

            // SQL Query
            String sql = "INSERT INTO users(name, email) VALUES (?, ?)";

            ps = con.prepareStatement(sql);

            // Set values
            ps.setString(1, name);
            ps.setString(2, email);

            // Execute Query
            ps.executeUpdate();

            // Send success message to JSP
            request.setAttribute(
                    "message",
                    "Registration Successful!"
            );

            // Forward to result.jsp
            request.getRequestDispatcher("result.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            // Send error message to JSP
            request.setAttribute(
                    "message",
                    "Registration Failed: " + e.getMessage()
            );

            // Forward to result.jsp
            request.getRequestDispatcher("result.jsp")
                   .forward(request, response);

        } finally {

            // Close PreparedStatement
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Close Connection
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
