package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MemberDAO;
import model.*;

@WebServlet("/viewMembers")
public class ViewMembersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session =
            request.getSession(false);

        if(session == null){

            response.sendRedirect("login.jsp");
            return;
        }

        MemberDAO dao = new MemberDAO();

        List<Member> memberList;

        // SEARCH
        String search =
            request.getParameter("search");

        if(search != null){
            search = search.trim();
        }

        try {

            // =========================
            // MEMBER SEARCH
            // =========================

            if(search != null &&
               !search.isEmpty()) {

                memberList =
                    dao.searchMembers(search);

            } else {

                memberList =
                    dao.getAllMembers();
            }

            // =========================
            // OWNER LIST
            // =========================

            List<Owner> owners =
                new ArrayList<>();

            // =========================
            // TENANT LIST
            // =========================

            List<Tenant> tenants =
                new ArrayList<>();

            Connection con =
                DBConnection.getConnection();

            // =========================
            // LOAD OWNERS
            // =========================

            PreparedStatement psOwner =
                con.prepareStatement(
                    "SELECT * FROM members"
                );

            ResultSet rsOwner =
                psOwner.executeQuery();

            while(rsOwner.next()) {

                Owner o = new Owner();

                o.setFlatNo(
                    rsOwner.getString("flat_no")
                );

                o.setName(
                    rsOwner.getString("name")
                );

                o.setPhone(
                    rsOwner.getString("phone")
                );

                o.setPurchaseDate(
                    rsOwner.getString("purchase_date")
                );

                o.setMembers(
                    rsOwner.getInt("member_count")
                );

                o.setShare(
                    rsOwner.getString("shareDoc")
                );

                o.setIndex(
                    rsOwner.getString("indexDoc")
                );

                o.setOther(
                    rsOwner.getString("otherDoc")
                );

                owners.add(o);
            }

            rsOwner.close();
            psOwner.close();

            // =========================
            // LOAD TENANTS
            // =========================

            String flatNo =
                request.getParameter("flatNo");

            String tenantSql =
                "SELECT * FROM tenants";

            if(flatNo != null &&
               !flatNo.trim().isEmpty()) {

                tenantSql +=
                    " WHERE flat_no=?";
            }

            PreparedStatement psTenant =
                con.prepareStatement(
                    tenantSql
                );

            if(flatNo != null &&
               !flatNo.trim().isEmpty()) {

                psTenant.setString(
                    1,
                    flatNo
                );
            }

            ResultSet rsTenant =
                psTenant.executeQuery();

            while(rsTenant.next()) {

                Tenant t = new Tenant();

                // ⚠️ IMPORTANT:
                // Use SAME DB column names everywhere

                t.setFlatNo(
                    rsTenant.getString("flat_no")
                );

                t.setTenantName(
                    rsTenant.getString("name")
                );

                t.setMobile(
                    rsTenant.getString("phone")
                );

                t.setRentDate(
                    rsTenant.getString("rent_date")
                );

                t.setMembers(
                    rsTenant.getInt("member_count")
                );

                t.setRentDoc(
                    rsTenant.getString("rentDoc")
                );

                t.setPoliceDoc(
                    rsTenant.getString("policeDoc")
                );

                t.setOtherDoc(
                    rsTenant.getString("otherDoc")
                );

                tenants.add(t);
            }

            rsTenant.close();
            psTenant.close();

            con.close();

            // =========================
            // TREE STRUCTURE
            // =========================

            TreeNode society =
                new TreeNode("Society");

            Map<String, TreeNode> blockMap =
                new HashMap<>();

            for(Member m : memberList) {

                String block =
                    (m.getBlock() == null)
                    ? "Unknown"
                    : m.getBlock();

                String flat =
                    (m.getFlatNo() == null)
                    ? "No Flat"
                    : m.getFlatNo();

                String name =
                    (m.getName() == null)
                    ? "No Name"
                    : m.getName();

                TreeNode blockNode =
                    blockMap.get(block);

                if(blockNode == null) {

                    blockNode =
                        new TreeNode(
                            "Block " + block
                        );

                    blockMap.put(
                        block,
                        blockNode
                    );

                    society.addChild(
                        blockNode
                    );
                }

                TreeNode houseNode =
                    new TreeNode(flat);

                houseNode.addChild(
                    new TreeNode(
                        "Member: " + name
                    )
                );

                blockNode.addChild(
                    houseNode
                );
            }

            // =========================
            // SEND DATA
            // =========================

            request.setAttribute(
                "memberList",
                memberList
            );

            request.setAttribute(
                "owners",
                owners
            );

            request.setAttribute(
                "tenants",
                tenants
            );

            request.setAttribute(
                "tree",
                society
            );

            request.getRequestDispatcher(
                "/viewMembers.jsp"
            ).forward(request, response);

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                "adminDashboard?msg=Load Error"
            );
        }
    }
}