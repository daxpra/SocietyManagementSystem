package model;

public class Member {

    private int id;
    private String name;
    private String block;
    private String flat;

    private String flat_no;
    private String mobile;
    private String email;
    private String purchase_date;
    private int no_of_members;

    // getters & setters

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getFlat_no() { return flat_no; }
    public void setFlat_no(String flat_no) { this.flat_no = flat_no; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPurchase_date() { return purchase_date; }
    public void setPurchase_date(String purchase_date) { this.purchase_date = purchase_date; }

    public int getNo_of_members() { return no_of_members; }
    public void setNo_of_members(int no_of_members) { this.no_of_members = no_of_members; }
}