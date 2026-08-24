package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.DBConnection;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // =========================
        // SESSION CHECK
        // =========================

        HttpSession session =
                request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        String role =
                (String) session.getAttribute("role");

        if(role == null ||
           !role.equalsIgnoreCase("admin")){

            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            // =========================
            // 💰 FINANCIAL DATA
            // =========================

            int maintenance = 0;
            int otherIncome = 0;
            int pendingAmount = 0;
            int expenseThisYear = 0;

            // MAINTENANCE INCOME
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM payments WHERE LOWER(status)='paid'"
            );

            ResultSet rs1 = ps1.executeQuery();

            if(rs1.next()){
                maintenance = rs1.getInt(1);
            }

            rs1.close();
            ps1.close();

         // OTHER INCOME
            PreparedStatement oi = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM income"
            );

            ResultSet oiRs = oi.executeQuery();

            if(oiRs.next()){
                otherIncome = oiRs.getInt(1);
            }

            oiRs.close();
            oi.close();

            // PENDING AMOUNT
            PreparedStatement ps2 = con.prepareStatement(
            	    "SELECT IFNULL(SUM(amount),0) FROM payments WHERE LOWER(TRIM(status))='pending'"
            	);
            ResultSet rs2 = ps2.executeQuery();

            if(rs2.next()){
                pendingAmount = rs2.getInt(1);
            }

            rs2.close();
            ps2.close();

            // EXPENSE THIS YEAR
            PreparedStatement ps3 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM expense WHERE YEAR(date)=YEAR(CURDATE())"
            );

            ResultSet rs3 = ps3.executeQuery();

            if(rs3.next()){
                expenseThisYear = rs3.getInt(1);
            }

            rs3.close();
            ps3.close();

            // CURRENT BALANCE
            int balance =
                    (maintenance + otherIncome)
                    - expenseThisYear;

            // =========================
            // 👥 MEMBER DATA
            // =========================

            int totalMembers = 0;

            PreparedStatement m1 = con.prepareStatement(
                "SELECT COUNT(*) FROM members"
            );

            ResultSet mRs1 = m1.executeQuery();

            if(mRs1.next()){
                totalMembers = mRs1.getInt(1);
            }

            mRs1.close();
            m1.close();

            // =========================
            // 📢 COMPLAINT DATA
            // =========================

            int complaintCount = 0;
            int resolvedCount = 0;
            int pendingCount = 0;

            PreparedStatement c1 = con.prepareStatement(
                "SELECT COUNT(*) FROM complaints"
            );

            ResultSet cRs1 = c1.executeQuery();

            if(cRs1.next()){
                complaintCount = cRs1.getInt(1);
            }

            cRs1.close();
            c1.close();

            PreparedStatement c2 = con.prepareStatement(
                "SELECT COUNT(*) FROM complaints WHERE status='Resolved'"
            );

            ResultSet cRs2 = c2.executeQuery();

            if(cRs2.next()){
                resolvedCount = cRs2.getInt(1);
            }

            cRs2.close();
            c2.close();

            PreparedStatement c3 = con.prepareStatement(
                "SELECT COUNT(*) FROM complaints WHERE LOWER(status)='pending'"
            );

            ResultSet cRs3 = c3.executeQuery();

            if(cRs3.next()){
                pendingCount = cRs3.getInt(1);
            }

            cRs3.close();
            c3.close();

            // =========================
            // 🏠 HOUSE DATA
            // =========================

            int totalHouses = 0;
            int ownerHouses = 0;
            int rentHouses = 0;
            int workingHouses = 0;

            // TOTAL FLATS
            PreparedStatement h1 = con.prepareStatement(
                "SELECT COUNT(*) FROM flats"
            );

            ResultSet hRs1 = h1.executeQuery();

            if(hRs1.next()){
                totalHouses = hRs1.getInt(1);
            }

            hRs1.close();
            h1.close();

            // OWNER HOUSES
            PreparedStatement h2 = con.prepareStatement(
                "SELECT COUNT(DISTINCT flat_no) FROM members"
            );

            ResultSet hRs2 = h2.executeQuery();

            if(hRs2.next()){
                ownerHouses = hRs2.getInt(1);
            }

            hRs2.close();
            h2.close();

            // RENT HOUSES
            PreparedStatement h3 = con.prepareStatement(
                "SELECT COUNT(DISTINCT flat_no) FROM tenants"
            );

            ResultSet hRs3 = h3.executeQuery();

            if(hRs3.next()){
                rentHouses = hRs3.getInt(1);
            }

            hRs3.close();
            h3.close();

            // WORKING HOUSES
            PreparedStatement h4 = con.prepareStatement(
                "SELECT COUNT(DISTINCT flat_no) FROM (" +
                "SELECT flat_no FROM members " +
                "UNION " +
                "SELECT flat_no FROM tenants" +
                ") x"
            );

            ResultSet hRs4 = h4.executeQuery();

            if(hRs4.next()){
                workingHouses = hRs4.getInt(1);
            }

            hRs4.close();
            h4.close();

            // =========================
            // 📈 YEARLY DATA
            // =========================

            int incomeThisYear = 0;
            int incomeLastYear = 0;
            int expenseLastYear = 0;

            PreparedStatement y1 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='Paid' AND YEAR(payment_date)=YEAR(CURDATE())"
            );

            ResultSet yRs1 = y1.executeQuery();

            if(yRs1.next()){
                incomeThisYear = yRs1.getInt(1);
            }

            yRs1.close();
            y1.close();

            PreparedStatement y2 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='Paid' AND YEAR(payment_date)=YEAR(CURDATE())-1"
            );

            ResultSet yRs2 = y2.executeQuery();

            if(yRs2.next()){
                incomeLastYear = yRs2.getInt(1);
            }

            yRs2.close();
            y2.close();

            PreparedStatement y3 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM expense WHERE YEAR(date)=YEAR(CURDATE())-1"
            );

            ResultSet yRs3 = y3.executeQuery();

            if(yRs3.next()){
                expenseLastYear = yRs3.getInt(1);
            }

            yRs3.close();
            y3.close();

            int profitThisYear =
                    incomeThisYear - expenseThisYear;

            int profitLastYear =
                    incomeLastYear - expenseLastYear;

            // =========================
            // 📅 MONTHLY DATA
            // =========================

            int incomeThisMonth = 0;
            int expenseThisMonth = 0;

            PreparedStatement mo1 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='Paid' AND MONTH(payment_date)=MONTH(CURDATE()) AND YEAR(payment_date)=YEAR(CURDATE())"
            );

            ResultSet moRs1 = mo1.executeQuery();

            if(moRs1.next()){
                incomeThisMonth = moRs1.getInt(1);
            }

            moRs1.close();
            mo1.close();

            PreparedStatement mo2 = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) FROM expense WHERE MONTH(date)=MONTH(CURDATE()) AND YEAR(date)=YEAR(CURDATE())"
            );

            ResultSet moRs2 = mo2.executeQuery();

            if(moRs2.next()){
                expenseThisMonth = moRs2.getInt(1);
            }

            moRs2.close();
            mo2.close();

            int balanceThisMonth =
                    incomeThisMonth - expenseThisMonth;

            // =========================
            // 🔔 NOTIFICATIONS
            // =========================

            List<Map<String,String>> notificationList =
                    new ArrayList<>();

            PreparedStatement n1 = con.prepareStatement(
                "SELECT * FROM notifications ORDER BY id DESC LIMIT 10"
            );

            ResultSet nRs = n1.executeQuery();

            while(nRs.next()){

                Map<String,String> map =
                        new HashMap<>();

                map.put(
                    "message",
                    nRs.getString("message")
                );

                notificationList.add(map);
            }

            nRs.close();
            n1.close();

            // =========================
            // 📢 COMPLAINT LIST
            // =========================

            List<Map<String,String>> complaintList =
                    new ArrayList<>();

            PreparedStatement cp = con.prepareStatement(
                "SELECT * FROM complaints ORDER BY id DESC"
            );

            ResultSet cpRs = cp.executeQuery();

            while(cpRs.next()){

                Map<String,String> map =
                        new HashMap<>();

                map.put("id",
                        cpRs.getString("id"));

                map.put("title",
                        cpRs.getString("title"));

                map.put("description",
                        cpRs.getString("description"));

                map.put("status",
                        cpRs.getString("status"));

                complaintList.add(map);
            }

            cpRs.close();
            cp.close();

            // =========================
            // 🎯 SET ATTRIBUTES
            // =========================

         // =========================
         // 🎯 SET ATTRIBUTES
         // =========================

         request.setAttribute(
             "maintenance",
             maintenance
         );

         request.setAttribute(
             "otherIncome",
             otherIncome
         );

         request.setAttribute(
             "pendingAmount",
             pendingAmount
         );

         request.setAttribute(
             "balance",
             balance
         );

         // ✅ IMPORTANT FIXES
         request.setAttribute(
             "expenseThisYear",
             expenseThisYear
         );

         request.setAttribute(
             "incomeThisYear",
             incomeThisYear
         );

         request.setAttribute(
             "incomeLastYear",
             incomeLastYear
         );

         request.setAttribute(
             "expenseLastYear",
             expenseLastYear
         );

         request.setAttribute(
             "profitThisYear",
             profitThisYear
         );

         request.setAttribute(
             "profitLastYear",
             profitLastYear
         );

         request.setAttribute(
             "balanceThisMonth",
             balanceThisMonth
         );

         request.setAttribute(
             "memberCount",
             totalMembers
         );

         request.setAttribute(
             "complaintCount",
             complaintCount
         );

         request.setAttribute(
             "resolvedCount",
             resolvedCount
         );

         request.setAttribute(
             "pendingCount",
             pendingCount
         );

         request.setAttribute(
             "totalHouses",
             totalHouses
         );

         request.setAttribute(
             "ownerHouses",
             ownerHouses
         );

         request.setAttribute(
             "rentHouses",
             rentHouses
         );

         request.setAttribute(
             "workingHouses",
             workingHouses
         );

         request.setAttribute(
             "notificationList",
             notificationList
         );

         request.setAttribute(
             "complaintList",
             complaintList
         );
            // =========================
            // 🚀 FORWARD
            // =========================

         System.out.println("Maintenance = " + maintenance);
         System.out.println("Other Income = " + otherIncome);
         System.out.println("Pending = " + pendingAmount);
         System.out.println("Income This Year = " + incomeThisYear);
         System.out.println("Expense Last Year = " + expenseLastYear);
         
            request.getRequestDispatcher(
                "/adminDashboard.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "login.jsp?msg=Dashboard Error"
            );

        } finally {

            try {

                if(con != null)
                    con.close();

            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}