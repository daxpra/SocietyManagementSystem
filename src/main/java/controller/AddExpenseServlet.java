package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addExpense")
public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String amountStr = request.getParameter("amount");
        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String date = request.getParameter("date");

        // VALIDATION
        if(amountStr == null || amountStr.trim().isEmpty() ||
           type == null || type.trim().isEmpty() ||
           description == null || description.trim().isEmpty() ||
           date == null || date.trim().isEmpty()) {

            response.sendRedirect("addExpense.jsp?msg=Please Fill All Fields");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            double amount = Double.parseDouble(amountStr);

            con = DBConnection.getConnection();

            String query = "INSERT INTO expense(amount, type, description, `date`) VALUES (?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setDouble(1, amount);
            ps.setString(2, type);
            ps.setString(3, description);
            ps.setString(4, date);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect("viewExpense.jsp?msg=Expense Added Successfully");

            } else {

                response.sendRedirect("addExpense.jsp?msg=Expense Not Added");
            }

        } catch(NumberFormatException e){

            e.printStackTrace();

            response.sendRedirect("addExpense.jsp?msg=Invalid Amount");

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect("addExpense.jsp?msg=Database Error");

        } finally {

            try {

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