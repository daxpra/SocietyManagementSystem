package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/visitorEntry")
public class VisitorEntryServlet extends HttpServlet {

    // =========================
    // LOAD PAGE
    // =========================

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
        request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        String role =
        (String) session.getAttribute("role");

        if(role == null ||
           !role.equalsIgnoreCase("security")){

            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher(
        "/visitorEntry.jsp")
        .forward(request,response);
    }

    // =========================
    // SAVE VISITOR
    // =========================

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
        request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // PARAMETERS

        String name =
        request.getParameter("name");

        String vehicleNo =
        request.getParameter("vehicleNo");

        String mobile =
        request.getParameter("phone");

        String purpose =
        request.getParameter("purpose");

        String flatNo =
        request.getParameter("flat_no");

        // VALIDATION

        if(name == null || name.trim().isEmpty()
        || mobile == null || mobile.trim().isEmpty()
        || flatNo == null || flatNo.trim().isEmpty()){

            response.sendRedirect(
            "visitorEntry?msg=Invalid Input");

            return;
        }

        Connection con = null;

        PreparedStatement psVisitor = null;

        PreparedStatement psNotify = null;

        try{

            con = DBConnection.getConnection();

            // =========================
            // INSERT VISITOR
            // =========================

            String visitorQuery =

            "INSERT INTO visitors(name,mobile,purpose,flat_no,vehicle_no,status) VALUES(?,?,?,?,?,?)";

            psVisitor =
            con.prepareStatement(visitorQuery);

            psVisitor.setString(1, name);

            psVisitor.setString(2, mobile);

            psVisitor.setString(3, purpose);

            psVisitor.setString(4, flatNo);

            psVisitor.setString(5, vehicleNo);

            psVisitor.setString(6, "Pending");

            psVisitor.executeUpdate();

            // =========================
            // INSERT USER NOTIFICATION
            // =========================

            String message =

            "Visitor " + name +
            " wants to visit your flat (" +
            flatNo + ")";

            String notifyQuery =

            "INSERT INTO notifications(message,sender_role,receiver_role,status,flat_no) VALUES(?,?,?,?,?)";

            psNotify =
            con.prepareStatement(notifyQuery);

            psNotify.setString(1, message);

            psNotify.setString(2, "security");

            psNotify.setString(3, "user");

            psNotify.setString(4, "pending");

            psNotify.setString(5, flatNo);

            psNotify.executeUpdate();

            response.sendRedirect(
            "visitorEntry?msg=Visitor Added");

        }catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
            "visitorEntry?msg=Database Error");

        }finally{

            try{

                if(psVisitor != null)
                    psVisitor.close();

                if(psNotify != null)
                    psNotify.close();

                if(con != null)
                    con.close();

            }catch(Exception e){

                e.printStackTrace();
            }
        }
    }
}
