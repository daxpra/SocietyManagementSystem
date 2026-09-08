package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import model.DBConnection;

@WebServlet("/generatePDF")
public class GeneratePDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("application/pdf");

        response.setHeader(
            "Content-Disposition",
            "attachment; filename=complaint_report.pdf"
        );

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Document document = new Document();

        try {

            con = DBConnection.getConnection();

            PdfWriter.getInstance(
                document,
                response.getOutputStream()
            );

            document.open();

            // TITLE
            Font titleFont =
                FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD,
                    18
                );

            Paragraph title =
                new Paragraph(
                    "Society Complaint Report",
                    titleFont
                );

            title.setAlignment(Element.ALIGN_CENTER);

            document.add(title);

            document.add(new Paragraph(" "));

            // TABLE
            PdfPTable table = new PdfPTable(4);

            table.setWidthPercentage(100);

            table.setSpacingBefore(10f);

            // HEADERS
            table.addCell("Name");
            table.addCell("House No");
            table.addCell("Message");
            table.addCell("Status");

            // QUERY
            String query =
                "SELECT * FROM complaints ORDER BY id DESC";

            ps = con.prepareStatement(query);

            rs = ps.executeQuery();

            boolean hasData = false;

            while(rs.next()){

                hasData = true;

                table.addCell(
                    rs.getString("name")
                );

                table.addCell(
                    rs.getString("house_no")
                );

                table.addCell(
                    rs.getString("message")
                );

                table.addCell(
                    rs.getString("status")
                );
            }

            if(hasData){

                document.add(table);

            } else {

                document.add(
                    new Paragraph("No complaints found.")
                );
            }

        } catch(Exception e){

            e.printStackTrace();

        } finally {

            try {

                if(document.isOpen()){
                    document.close();
                }

                if(rs != null)
                    rs.close();

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
