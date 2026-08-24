<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String role = (String) session.getAttribute("role");

if (role == null || !role.equals("admin")) {
    response.sendRedirect("login.jsp");
}
%>

<%
String wing = request.getParameter("wing");
String flatNo = request.getParameter("flatNo");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>View Members</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#f1f5f9;
    color:#1e293b;
    overflow-x:hidden;
}

/* BACKGROUND */

body::before{
    content:"";
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    opacity:0.05;
    z-index:-1;
}

/* CONTAINER */

.container{
    width:100%;
    max-width:1400px;
    margin:auto;
    padding:20px;
}

/* TOP BAR */

.top-bar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:15px;
    flex-wrap:wrap;
    margin-bottom:20px;
}

/* BACK BUTTON */

.back-btn{
    background:#2563eb;
    color:white;
    border:none;
    padding:10px 18px;
    border-radius:10px;
    cursor:pointer;
    font-size:15px;
    transition:0.3s;
}

.back-btn:hover{
    background:#1d4ed8;
}

/* FILTER */

.filter-box{
    background:white;
    padding:18px;
    border-radius:16px;
    box-shadow:0 4px 12px rgba(0,0,0,0.06);
    display:flex;
    flex-wrap:wrap;
    gap:12px;
    align-items:center;
    justify-content:center;
    margin-bottom:25px;
}

.filter-box select,
.filter-box input{
    padding:10px 14px;
    border:1px solid #cbd5e1;
    border-radius:10px;
    font-size:14px;
    min-width:180px;
    outline:none;
}

.filter-box button{
    background:#16a34a;
    color:white;
    border:none;
    padding:10px 18px;
    border-radius:10px;
    cursor:pointer;
    transition:0.3s;
}

.filter-box button:hover{
    background:#15803d;
}

/* SECTION TITLE */

.section-title{
    text-align:center;
    margin:25px 0 15px;
    font-size:28px;
    color:#0f172a;
}

/* TABLE WRAPPER */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    margin-bottom:30px;
    border-radius:18px;
    box-shadow:0 4px 12px rgba(0,0,0,0.06);
}

/* TABLE */

table{
    width:100%;
    border-collapse:collapse;
    background:white;
}

@media(max-width:768px){

    table{
        min-width:1000px;
    }
}

/* OWNER */

.owner th{
    background:#a5d6a7;
    color:#1b4332;
}

.owner td{
    background:#edf7ed;
}

/* TENANT */

.tenant th{
    background:#90caf9;
    color:#0c4a6e;
}

.tenant td{
    background:#eaf6ff;
}

/* TABLE CELLS */

th,td{
    padding:14px 12px;
    text-align:center;
    border:1px solid #dbeafe;
    font-size:14px;
}

th{
    font-weight:600;
}

/* PDF ICON */

.pdf{
    text-decoration:none;
    font-size:20px;
}

/* EDIT BUTTON */

.edit-btn{
    text-decoration:none;
    background:#f59e0b;
    color:white;
    padding:7px 12px;
    border-radius:8px;
    font-size:13px;
    transition:0.3s;
}

.edit-btn:hover{
    background:#d97706;
}

/* NO DATA */

.no-data{
    text-align:center;
    background:white;
    padding:20px;
    border-radius:15px;
    margin-bottom:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.05);
}

/* FOOTER */

.footer{
    width:100%;
    background:#0f172a;
    color:white;
    text-align:center;
    padding:12px;
    font-size:13px;
    margin-top:20px;
}

/* TABLET */

@media(max-width:992px){

    .section-title{
        font-size:24px;
    }

    th,td{
        font-size:13px;
        padding:12px 10px;
    }
}

/* MOBILE */

@media(max-width:768px){

    .container{
        padding:15px;
    }

    .top-bar{
        flex-direction:column;
        align-items:stretch;
    }

    .back-btn{
        width:100%;
    }

    .filter-box{
        flex-direction:column;
        align-items:stretch;
    }

    .filter-box select,
    .filter-box input,
    .filter-box button{
        width:100%;
    }

    .section-title{
        font-size:22px;
    }

    th,td{
        font-size:12px;
        padding:10px 8px;
    }

    .pdf{
        font-size:18px;
    }

    .edit-btn{
        font-size:12px;
        padding:6px 10px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .section-title{
        font-size:20px;
    }

    .footer{
        font-size:12px;
    }
}

</style>
</head>

<body>

<div class="container">

    <!-- TOP BAR -->

    <div class="top-bar">

        <a href="adminDashboard">
            <button class="back-btn">⬅ Back Dashboard</button>
        </a>

    </div>

    <!-- FILTER -->

    <form method="get" action="viewMembers" class="filter-box">

        <select name="wing">

            <option value="">All Wings</option>
            <option value="A">Wing A</option>
            <option value="B">Wing B</option>
            <option value="C">Wing C</option>
            <option value="D">Wing D</option>
            <option value="E">Wing E</option>

        </select>

        <input type="text" name="flatNo" placeholder="Enter Flat No">

        <button type="submit">Filter Members</button>

    </form>

    <!-- OWNER DETAILS -->

    <h2 class="section-title">🏠 Owner Details</h2>

<%
Connection con = DBConnection.getConnection();

String query = "SELECT * FROM members WHERE 1=1";

if(flatNo != null && !flatNo.trim().isEmpty()){
    query += " AND flat_no = '" + flatNo + "'";
}

Statement st = con.createStatement();
ResultSet rs = st.executeQuery(query);

int i = 1;
%>

<%
if(!rs.isBeforeFirst()){
%>

<div class="no-data">
    No owner data found
</div>

<%
}
%>

<div class="table-wrapper">

<table class="owner">

<tr>
<th>Sr No</th>
<th>Flat No</th>
<th>Name</th>
<th>Phone</th>
<th>Purchase Date</th>
<th>Members</th>
<th>Share</th>
<th>Index</th>
<th>Other</th>
<th>Action</th>
</tr>

<%
while(rs.next()){
%>

<tr>

<td><%= i++ %></td>

<td><%= rs.getString("flat_no") %></td>

<td><%= rs.getString("name") %></td>

<td><%= rs.getString("phone") %></td>

<td><%= rs.getString("purchase_date") %></td>

<td><%= rs.getInt("member_count") %></td>

<td>

<%
String share = rs.getString("shareDoc");

if(share != null && !share.isEmpty()){
%>

<a class="pdf" href="uploads/<%= share %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

<td>

<%
String index = rs.getString("indexDoc");

if(index != null && !index.isEmpty()){
%>

<a class="pdf" href="uploads/<%= index %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

<td>

<%
String other = rs.getString("otherDoc");

if(other != null && !other.isEmpty()){
%>

<a class="pdf" href="uploads/<%= other %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

<td>

<a class="edit-btn" href="editMember.jsp?id=<%= rs.getInt("id") %>">
Edit
</a>

</td>

</tr>

<%
}
rs.close();
%>

</table>

</div>

<!-- TENANT DETAILS -->

<h2 class="section-title">🏢 Tenant Details</h2>

<%
String tenantQuery = "SELECT * FROM tenants WHERE 1=1";

if(flatNo != null && !flatNo.trim().isEmpty()){
    tenantQuery += " AND flat_no = '" + flatNo + "'";
}

ResultSet rs2 = st.executeQuery(tenantQuery);

int j = 1;

if(!rs2.isBeforeFirst()){
%>

<div class="no-data">
    No tenant data found
</div>

<%
}
%>

<div class="table-wrapper">

<table class="tenant">

<tr>
<th>Sr No</th>
<th>Flat No</th>
<th>Name</th>
<th>Phone</th>
<th>Rent Date</th>
<th>Members</th>
<th>Rent Doc</th>
<th>Police</th>
<th>Other</th>
</tr>

<%
while(rs2.next()){
%>

<tr>

<td><%= j++ %></td>

<td><%= rs2.getString("flat_no") %></td>

<td><%= rs2.getString("name") %></td>

<td><%= rs2.getString("phone") %></td>

<td><%= rs2.getString("rent_date") %></td>

<td><%= rs2.getString("member_count") %></td>

<td>

<%
String rent = rs2.getString("rentDoc");

if(rent != null && !rent.isEmpty()){
%>

<a class="pdf" href="uploads/<%= rent %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

<td>

<%
String police = rs2.getString("policeDoc");

if(police != null && !police.isEmpty()){
%>

<a class="pdf" href="uploads/<%= police %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

<td>

<%
String otherT = rs2.getString("otherDoc");

if(otherT != null && !otherT.isEmpty()){
%>

<a class="pdf" href="uploads/<%= otherT %>" target="_blank">📄</a>

<%
}else{
%>
-
<%
}
%>

</td>

</tr>

<%
}

rs2.close();
st.close();
con.close();

%>

</table>

</div>

</div>

<!-- FOOTER -->

<div class="footer">
    The Bharat Solutions, Ahmedabad | Contact: +91-95865 05037
</div>

</body>
</html>