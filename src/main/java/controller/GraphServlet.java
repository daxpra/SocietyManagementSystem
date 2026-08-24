package controller;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MemberDAO;

@WebServlet("/graph")
public class GraphServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("admin") == null){

            response.sendRedirect("login.jsp");
            return;
        }

        try {

            MemberDAO dao = new MemberDAO();

            Map<String, Integer> data =
                    dao.getBlockCount();

            // NULL SAFETY
            if(data == null){

                data = new HashMap<>();
            }

            request.setAttribute(
                "graphData",
                data
            );

            request.getRequestDispatcher(
                "/graph.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Graph Load Error"
            );
        }
    }
}