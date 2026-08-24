package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Logout")
public class LogoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // GET SESSION
        HttpSession session =
            request.getSession(false);

        // INVALIDATE SESSION
        if(session != null){

            session.invalidate();
        }

        // PREVENT BACK BUTTON CACHE
        response.setHeader(
            "Cache-Control",
            "no-cache, no-store, must-revalidate"
        );

        response.setHeader(
            "Pragma",
            "no-cache"
        );

        response.setDateHeader(
            "Expires",
            0
        );

        // REDIRECT TO LOGIN
        response.sendRedirect(
            request.getContextPath() +
            "/login.jsp"
        );
    }

    // OPTIONAL:
    // Allow GET logout also

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }
}