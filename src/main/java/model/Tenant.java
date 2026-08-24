package model;
public class Tenant {

    private String flatNo;
    private String tenantName;
    private String mobile;
    private String rentDate;
    private int members;
    private String indexDoc;	
    private String rentDoc;
    private String policeDoc;
    private String otherDoc;

    // ✅ GETTERS & SETTERS

    public String getFlatNo() { return flatNo; }
    public void setFlatNo(String flatNo) { this.flatNo = flatNo; }

    
    public String getIndexDoc() {
        return indexDoc;
    }
    
    public void setIndexDoc(String indexDoc) {
        this.indexDoc = indexDoc;
    }
    
    
    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getRentDate() { return rentDate; }
    public void setRentDate(String rentDate) { this.rentDate = rentDate; }

    public int getMembers() { return members; }
    public void setMembers(int members) { this.members = members; }

    public String getRentDoc() { return rentDoc; }
    public void setRentDoc(String rentDoc) { this.rentDoc = rentDoc; }

    public String getPoliceDoc() { return policeDoc; }
    public void setPoliceDoc(String policeDoc) { this.policeDoc = policeDoc; }

    public String getOtherDoc() { return otherDoc; }
    public void setOtherDoc(String otherDoc) { this.otherDoc = otherDoc; }
}