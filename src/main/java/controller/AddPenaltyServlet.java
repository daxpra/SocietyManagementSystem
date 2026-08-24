package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/addPenalty")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)

public class AddPenaltyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String startDate = request.getParameter("start_date");
        String type = request.getParameter("type");
        String chargeStr = request.getParameter("charge");
        String flatNo = request.getParameter("flat_no");
        String totalStr = request.getParameter("total_maintenance");

        // VALIDATION
        if(startDate == null || startDate.trim().isEmpty() ||
           type == null || type.trim().isEmpty() ||
           chargeStr == null || chargeStr.trim().isEmpty() ||
           flatNo == null || flatNo.trim().isEmpty()) {

            response.sendRedirect("penalty.jsp?msg=Please Fill All Fields");
            return;
        }

        double charge;
        double totalMaintenance = 0;

        try {

            charge = Double.parseDouble(chargeStr);

            if(totalStr != null && !totalStr.trim().isEmpty()){
                totalMaintenance = Double.parseDouble(totalStr);
            }

        } catch(NumberFormatException e){

            response.sendRedirect("penalty.jsp?msg=Invalid Amount");
            return;
        }

        // FILE PART
        Part filePart = request.getPart("photo");

        // UPLOAD PATH
        String uploadPath = getServletContext().getRealPath("") +
                            File.separator + "uploads";

        File uploadDir = new File(uploadPath);

        if(!uploadDir.exists()){
            uploadDir.mkdir();
        }

        // SAVE FILE
        String fileName = saveFile(filePart, uploadPath);

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;

        try {

            con = DBConnection.getConnection();

            // TRANSACTION START
            con.setAutoCommit(false);

            // INSERT PENALTY
            String penaltyQuery =
                "INSERT INTO penalty(start_date, type, charge, photo, flat_no, total_maintenance) VALUES (?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(penaltyQuery);

            ps.setString(1, startDate);
            ps.setString(2, type);
            ps.setDouble(3, charge);
            ps.setString(4, fileName);
            ps.setString(5, flatNo);
            ps.setDouble(6, totalMaintenance);

            int rows = ps.executeUpdate();

            // INSERT NOTIFICATION
            String message =
                "Penalty added for House " + flatNo +
                " Amount ₹" + charge;

            String notificationQuery =
                "INSERT INTO notifications(message, receiver_role) VALUES (?, ?)";

            ps2 = con.prepareStatement(notificationQuery);

            ps2.setString(1, message);
            ps2.setString(2, "user");

            ps2.executeUpdate();

            // COMMIT
            con.commit();

            if(rows > 0){

                response.sendRedirect(
                    "penalty.jsp?msg=Penalty Added Successfully"
                );

            } else {

                response.sendRedirect(
                    "penalty.jsp?msg=Penalty Not Added"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            try {

                if(con != null)
                    con.rollback();

            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "penalty.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(ps2 != null)
                    ps2.close();

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    // SAVE FILE METHOD
    private String saveFile(Part part, String uploadPath)
            throws IOException {

        if(part == null || part.getSize() == 0){
            return "";
        }

        String originalFileName =
            Paths.get(part.getSubmittedFileName())
                 .getFileName()
                 .toString();

        // UNIQUE FILE NAME
        String fileName =
            UUID.randomUUID().toString() + "_" + originalFileName;

        part.write(uploadPath + File.separator + fileName);

        return fileName;
    }
}