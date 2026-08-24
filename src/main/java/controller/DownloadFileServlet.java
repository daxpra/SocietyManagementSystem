package controller;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/downloadFile")
public class DownloadFileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET FILE NAME
        String fileName = request.getParameter("name");

        // VALIDATION
        if(fileName == null || fileName.trim().isEmpty()){

            response.getWriter().println("Invalid File");
            return;
        }

        // SECURITY FIX
        // Prevent path traversal attack
        fileName = new File(fileName).getName();

        // FILE PATH
        String uploadPath =
            getServletContext().getRealPath("") +
            File.separator + "uploads";

        File file =
            new File(uploadPath + File.separator + fileName);

        // CHECK FILE EXISTS
        if(!file.exists()){

            response.getWriter().println("File Not Found");
            return;
        }

        // UPDATE DOWNLOAD COUNT
        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = DBConnection.getConnection();

            String query =
                "UPDATE files SET download_count = download_count + 1 WHERE file_name=?";

            ps = con.prepareStatement(query);

            ps.setString(1, fileName);

            ps.executeUpdate();

        } catch(Exception e){

            e.printStackTrace();

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

        // MIME TYPE
        String mimeType =
            getServletContext().getMimeType(file.getAbsolutePath());

        if(mimeType == null){
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);

        response.setContentLengthLong(file.length());

        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"" + file.getName() + "\""
        );

        // SEND FILE
        try (
            FileInputStream in =
                new FileInputStream(file);

            OutputStream out =
                response.getOutputStream()
        ) {

            byte[] buffer = new byte[4096];

            int bytesRead;

            while((bytesRead = in.read(buffer)) != -1){

                out.write(buffer, 0, bytesRead);
            }

            out.flush();
        }
    }
}