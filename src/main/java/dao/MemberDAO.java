package dao;

import model.Owner;
import model.Tenant;
import model.DBConnection;
import model.Member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class MemberDAO {

    // 🔹 BLOCK COUNT
    public Map<String, Integer> getBlockCount() {
        Map<String, Integer> map = new HashMap<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT block, COUNT(*) as total FROM members GROUP BY block";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString("block"), rs.getInt("total"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    // 🔹 GET ALL MEMBERS
    public List<Member> getAllMembers() {
        List<Member> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM members";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Member m = new Member();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setBlock(rs.getString("block"));
                m.setFlatNo(rs.getString("flat_no"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔍 SEARCH MEMBERS (FIXED)
    public List<Member> searchMembers(String keyword) {
        List<Member> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM members WHERE name LIKE ? OR block LIKE ? OR flat_no LIKE ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Member m = new Member();
                m.setName(rs.getString("name"));
                m.setBlock(rs.getString("block"));
                m.setFlatNo(rs.getString("flat_no"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 ADD MEMBER (UPDATED WITH FILES)
    public void addMember(Member m) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO members(name, block, flat_no, share_doc, index_doc, other_doc) VALUES (?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, m.getName());
            ps.setString(2, m.getBlock());
            ps.setString(3, m.getFlatNo());
            ps.setString(4, m.getShareDoc());
            ps.setString(5, m.getIndexDoc());
            ps.setString(6, m.getOtherDoc());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 🔹 UPDATE MEMBER
    public void updateMember(Member m) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE members SET name=?, block=?, flat_no=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, m.getName());
            ps.setString(2, m.getBlock());
            ps.setString(3, m.getFlatNo());
         
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 🔹 DELETE MEMBER
    public void deleteMember(int id) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "DELETE FROM members WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 🔹 GET OWNER
    public List<Owner> getOwnerByFlat(String flatNo) {
        List<Owner> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM owner WHERE flat_no=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, flatNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	Owner o = new Owner();

            	o.setFlatNo(rs.getString("flat_no"));
            	o.setName(rs.getString("owner_name"));
            	o.setPhone(rs.getString("mobile"));
            	o.setPurchaseDate(rs.getString("purchase_date"));
            	o.setMembers(rs.getInt("members"));

            	o.setShare(rs.getString("share_doc"));
            	o.setIndex(rs.getString("index_doc"));
            	o.setOther(rs.getString("other_doc"));

            	list.add(o);;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 GET TENANT
    public List<Tenant> getTenantByFlat(String flatNo) {
        List<Tenant> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM tenant WHERE flat_no=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, flatNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tenant t = new Tenant();
                t.setFlatNo(rs.getString("flat_no"));
                t.setTenantName(rs.getString("tenant_name"));
                t.setMobile(rs.getString("mobile"));
                t.setRentDate(rs.getString("rent_date"));
                t.setMembers(rs.getInt("members"));
                t.setRentDoc(rs.getString("rent_doc"));
                t.setPoliceDoc(rs.getString("police_doc"));
                t.setOtherDoc(rs.getString("other_doc"));
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 GET MEMBER BY ID
    public Member getMemberById(int id) {
        Member m = null;

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM members WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                m = new Member();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setBlock(rs.getString("block"));
                m.setFlatNo(rs.getString("flat_no"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return m;
    }
}