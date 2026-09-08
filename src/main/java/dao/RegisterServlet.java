import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


public class RegisterServlet extends HttpServlet {


    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get data from JSP formT
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        Connection con = null;
        PreparedStatement ps = null;

        try {

            
            Class.forName("com.mysql.cj.jdbc.Driver");

            
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/testdb",
                    "root",
                    ""
            );

            
            String sql = "INSERT INTO users(name, email) VALUES (?, ?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);

            
            ps.executeUpdate();

            
            request.setAttribute(
                    "message",
                    "Registration Successful!"
            );

            
                 ((javax.servlet.RequestDispatcher) request.getRequestDispatcher("result.jsp"))
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "message",
                    "Registration Failed: " + e.getMessage()
            );

                 ((javax.servlet.RequestDispatcher) request.getRequestDispatcher("result.jsp"))
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