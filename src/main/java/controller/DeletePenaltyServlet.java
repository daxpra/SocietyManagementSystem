package controller;

import java.io.File;
import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/deletePenalty")
public class DeletePenaltyServlet extends HttpServlet {

    // ✅ SUPPORT GET REQUEST
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    // ✅ SUPPORT POST REQUEST
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

        // GET ID
        String idParam =
            request.getParameter("id");

        // VALIDATION
        if(idParam == null ||
           idParam.trim().isEmpty()){

            response.sendRedirect(
                "penalty.jsp?msg=Invalid Penalty"
            );
            return;
        }

        Connection con = null;

        PreparedStatement psSelect = null;
        PreparedStatement psDelete = null;

        ResultSet rs = null;

        try {

            int id =
                Integer.parseInt(idParam);

            con =
                DBConnection.getConnection();

            // =========================
            // GET PHOTO NAME
            // =========================

            psSelect =
                con.prepareStatement(
                    "SELECT photo FROM penalty WHERE id=?"
                );

            psSelect.setInt(1, id);

            rs =
                psSelect.executeQuery();

            String photoName = "";

            if(rs.next()){

                photoName =
                    rs.getString("photo");
            }

            // =========================
            // DELETE RECORD
            // =========================

            psDelete =
                con.prepareStatement(
                    "DELETE FROM penalty WHERE id=?"
                );

            psDelete.setInt(1, id);

            int rows =
                psDelete.executeUpdate();

            // =========================
            // DELETE PHOTO FILE
            // =========================

            if(photoName != null &&
               !photoName.isEmpty()){

                String uploadPath =
                    getServletContext()
                    .getRealPath("") +
                    File.separator +
                    "uploads";

                File photoFile =
                    new File(
                        uploadPath +
                        File.separator +
                        photoName
                    );

                if(photoFile.exists()){

                    photoFile.delete();
                }
            }

            // =========================
            // SUCCESS / FAILED
            // =========================

            if(rows > 0){

                response.sendRedirect(
                    "penalty.jsp?msg=Penalty Deleted Successfully"
                );

            } else {

                response.sendRedirect(
                    "penalty.jsp?msg=Penalty Not Found"
                );
            }

        } catch(NumberFormatException e){

            response.sendRedirect(
                "penalty.jsp?msg=Invalid ID"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "penalty.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(rs != null)
                    rs.close();

                if(psSelect != null)
                    psSelect.close();

                if(psDelete != null)
                    psDelete.close();

                if(con != null)
                    con.close();

            } catch(Exception e){

                e.printStackTrace();
            }
        }
    }
}