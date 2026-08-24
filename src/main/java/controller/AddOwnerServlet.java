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

@WebServlet("/addOwner")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)

public class AddOwnerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String block = request.getParameter("block");
        String flatNo = request.getParameter("flatNo");
        String name = request.getParameter("ownerName");
        String mobile = request.getParameter("mobile");
        String date = request.getParameter("purchaseDate");
        String members = request.getParameter("members");
        String category = request.getParameter("category");

        // VALIDATION
        if(block == null || block.trim().isEmpty() ||
           flatNo == null || flatNo.trim().isEmpty() ||
           name == null || name.trim().isEmpty() ||
           mobile == null || mobile.trim().isEmpty()) {

            response.sendRedirect("addOwner.jsp?msg=Please Fill Required Fields");
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
        Part share = request.getPart("shareDoc");
        Part index = request.getPart("indexDoc");
        Part other = request.getPart("otherDoc");

        // SAVE FILES
        String shareFile = saveFile(share, uploadPath);
        String indexFile = saveFile(index, uploadPath);
        String otherFile = saveFile(other, uploadPath);

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;

        try {

            conn = DBConnection.getConnection();

            // TRANSACTION START
            conn.setAutoCommit(false);

            // INSERT OWNER
            String ownerQuery =
                "INSERT INTO owners(block, flat_no, owner_name, mobile, purchase_date, members, share_doc, index_doc, other_doc) VALUES (?,?,?,?,?,?,?,?,?)";

            ps = conn.prepareStatement(ownerQuery);

            ps.setString(1, block);
            ps.setString(2, flatNo);
            ps.setString(3, name);
            ps.setString(4, mobile);
            ps.setString(5, date);
            ps.setString(6, members);
            ps.setString(7, shareFile);
            ps.setString(8, indexFile);
            ps.setString(9, otherFile);

            int ownerRows = ps.executeUpdate();

            // INSERT FILES
            String fileQuery =
                "INSERT INTO files(file_name, uploaded_by, category) VALUES (?, ?, ?)";

            ps2 = conn.prepareStatement(fileQuery);

            insertFile(ps2, shareFile, category);
            insertFile(ps2, indexFile, category);
            insertFile(ps2, otherFile, category);

            // COMMIT
            conn.commit();

            if(ownerRows > 0){

                response.sendRedirect(
                    "viewMembers?msg=Owner Added Successfully"
                );

            } else {

                response.sendRedirect(
                    "addOwner.jsp?msg=Owner Not Added"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            try {
                if(conn != null)
                    conn.rollback();
            } catch(Exception ex){
                ex.printStackTrace();
            }

            response.sendRedirect(
                "addOwner.jsp?msg=Database Error"
            );

        } finally {

            try {

                if(ps2 != null)
                    ps2.close();

                if(ps != null)
                    ps.close();

                if(conn != null)
                    conn.close();

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

        String fileName =
            UUID.randomUUID().toString() + "_" + originalFileName;

        part.write(uploadPath + File.separator + fileName);

        return fileName;
    }

    // INSERT FILE RECORD
    private void insertFile(PreparedStatement ps,
                            String fileName,
                            String category) throws Exception {

        if(fileName == null || fileName.isEmpty()){
            return;
        }

        ps.setString(1, fileName);
        ps.setString(2, "Admin");
        ps.setString(3, category);

        ps.executeUpdate();
    }
}