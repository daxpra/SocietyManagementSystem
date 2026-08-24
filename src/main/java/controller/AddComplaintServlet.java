package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addComplaint")
public class AddComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        // VALIDATION
        if(title == null || title.trim().isEmpty() ||
           description == null || description.trim().isEmpty()) {

            response.sendRedirect("complaint.jsp?msg=Please Fill All Fields");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query = "INSERT INTO complaints(title, description, status) VALUES (?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, "Pending");

            int rows = ps.executeUpdate();

            if(rows > 0) {

                response.sendRedirect(
                    request.getContextPath() + "/viewComplaint?msg=Complaint Added Successfully"
                );

            } else {

                response.sendRedirect(
                    "complaint.jsp?msg=Complaint Not Added"
                );
            }

        } catch(Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "complaint.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();

            } catch(Exception e) {
                e.printStackTrace();
            }
        }
    }
}