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

@WebServlet("/addTenant")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)

public class AddTenantServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        // PARAMETERS
        String block = request.getParameter("block");
        String flatNo = request.getParameter("flatNo");
        String name = request.getParameter("tenantName");
        String phone = request.getParameter("phone");
        String startDate = request.getParameter("startDate");
        String members = request.getParameter("member");

        // VALIDATION
        if(block == null || block.trim().isEmpty() ||
           flatNo == null || flatNo.trim().isEmpty() ||
           name == null || name.trim().isEmpty() ||
           phone == null || phone.trim().isEmpty()) {

            response.sendRedirect("addTenant.jsp?msg=Please Fill Required Fields");
            return;
        }

        // MEMBER COUNT
        int memberCount = 0;

        try {

            if(members != null && !members.trim().isEmpty()){
                memberCount = Integer.parseInt(members);
            }

        } catch(NumberFormatException e){

            response.sendRedirect("addTenant.jsp?msg=Invalid Member Count");
            return;
        }

        // UPLOAD PATH
        String uploadPath = getServletContext().getRealPath("") +
                            File.separator + "uploads";

        File uploadDir = new File(uploadPath);

        if(!uploadDir.exists()){
            uploadDir.mkdir();
        }

        // FILE PARTS
        Part rentPart = request.getPart("rentDoc");
        Part policePart = request.getPart("policeDoc");
        Part otherPart = request.getPart("otherDoc");

        // SAVE FILES
        String rentFileName = saveFile(rentPart, uploadPath);
        String policeFileName = saveFile(policePart, uploadPath);
        String otherFileName = saveFile(otherPart, uploadPath);

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                "INSERT INTO tenants(block, flat_no, name, phone, rent_date, member_count, rentDoc, policeDoc, otherDoc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, block);
            ps.setString(2, flatNo);
            ps.setString(3, name);
            ps.setString(4, phone);
            ps.setString(5, startDate);
            ps.setInt(6, memberCount);
            ps.setString(7, rentFileName);
            ps.setString(8, policeFileName);
            ps.setString(9, otherFileName);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect(
                    request.getContextPath() +
                    "/viewMembers.jsp?msg=Tenant Added Successfully"
                );

            } else {

                response.sendRedirect(
                    "addTenant.jsp?msg=Tenant Not Added"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "addTenant.jsp?msg=Database Error"
            );

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