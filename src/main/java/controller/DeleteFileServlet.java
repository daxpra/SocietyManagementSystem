package controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/deleteFile")
public class DeleteFileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        // GET FILE NAME
        String fileName = request.getParameter("name");

        // VALIDATION
        if(fileName == null || fileName.trim().isEmpty()){

            response.sendRedirect(
                "viewFiles.jsp?msg=Invalid File"
            );
            return;
        }

        // SECURITY CHECK
        // Prevent path traversal

        fileName = new File(fileName).getName();

        // UPLOAD PATH
        String uploadPath =
            getServletContext().getRealPath("") +
            File.separator + "uploads";

        File file =
            new File(uploadPath + File.separator + fileName);

        try {

            if(file.exists()){

                boolean deleted = file.delete();

                if(deleted){

                    response.sendRedirect(
                        "viewFiles.jsp?msg=File Deleted Successfully"
                    );

                } else {

                    response.sendRedirect(
                        "viewFiles.jsp?msg=Unable To Delete File"
                    );
                }

            } else {

                response.sendRedirect(
                    "viewFiles.jsp?msg=File Not Found"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "viewFiles.jsp?msg=Delete Error"
            );
        }
    }
}