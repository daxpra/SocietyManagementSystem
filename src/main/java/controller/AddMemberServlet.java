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

@WebServlet("/AddMemberServlet")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)

public class AddMemberServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("addmember.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String block = request.getParameter("block");
        String flatNo = request.getParameter("flat_no");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String purchaseDate = request.getParameter("purchaseDate");
        String memberCount = request.getParameter("members");

        // VALIDATION
        if(block == null || block.trim().isEmpty() ||
           flatNo == null || flatNo.trim().isEmpty() ||
           name == null || name.trim().isEmpty() ||
           phone == null || phone.trim().isEmpty()) {

            response.sendRedirect("addmember.jsp?msg=Please Fill Required Fields");
            return;
        }

        // UPLOAD FOLDER
        String uploadPath = getServletContext().getRealPath("") +
                            File.separator + "uploads";

        File uploadDir = new File(uploadPath);

        if(!uploadDir.exists()){
            uploadDir.mkdir();
        }

        // FILE PARTS
        Part sharePart = request.getPart("shareDoc");
        Part indexPart = request.getPart("indexDoc");
        Part otherPart = request.getPart("otherDoc");

        // SAVE FILES
        String shareFile = saveFile(sharePart, uploadPath);
        String indexFile = saveFile(indexPart, uploadPath);
        String otherFile = saveFile(otherPart, uploadPath);

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query = "INSERT INTO members(block, flat_no, name, phone, purchase_date, member_count, shareDoc, indexDoc, otherDoc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, block);
            ps.setString(2, flatNo);
            ps.setString(3, name);
            ps.setString(4, phone);
            ps.setString(5, purchaseDate);
            ps.setString(6, memberCount);
            ps.setString(7, shareFile);
            ps.setString(8, indexFile);
            ps.setString(9, otherFile);

            int rows = ps.executeUpdate();

            if(rows > 0){

                response.sendRedirect("viewMembers.jsp?msg=Member Added Successfully");

            } else {

                response.sendRedirect("addmember.jsp?msg=Member Not Added");
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect("addmember.jsp?msg=Database Error");

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

    // FILE SAVE METHOD
    private String saveFile(Part part, String uploadPath) throws IOException {

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