package model;

public class Member {

    private int id;
    private String name;
    private String block;
    private String flatNo;

    // 🔥 Multiple Documents
    private String shareDoc;
    private String indexDoc;
    private String otherDoc;

    // 🔹 GETTERS & SETTERS

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBlock() {
        return block;
    }

    public void setBlock(String block) {
        this.block = block;
    }

    public String getFlatNo() {
        return flatNo;
    }

    public void setFlatNo(String flatNo) {
        this.flatNo = flatNo;
    }

    // 🔥 FILES

    public String getShareDoc() {
        return shareDoc;
    }

    public void setShareDoc(String shareDoc) {
        this.shareDoc = shareDoc;
    }

    public String getIndexDoc() {
        return indexDoc;
    }

    public void setIndexDoc(String indexDoc) {
        this.indexDoc = indexDoc;
    }

    public String getOtherDoc() {
        return otherDoc;
    }

    public void setOtherDoc(String otherDoc) {
        this.otherDoc = otherDoc;
    }
}