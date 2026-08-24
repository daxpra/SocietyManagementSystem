package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addNotice")
public class AddNoticeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        // VALIDATION
        if(title == null || title.trim().isEmpty() ||
           message == null || message.trim().isEmpty()) {

            response.sendRedirect("dashboard?msg=Please Fill All Fields");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBConnection.getConnection();

            String query = "INSERT INTO notices(title, message) VALUES(?, ?)";

            ps = conn.prepareStatement(query);

            ps.setString(1, title);
            ps.setString(2, message);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect("dashboard?msg=Notice Added Successfully");

            } else {

                response.sendRedirect("dashboard?msg=Notice Not Added");
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect("dashboard?msg=Database Error");

        } finally {

            try {

                if(ps != null)
                    ps.close();

                if(conn != null)
                    conn.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}