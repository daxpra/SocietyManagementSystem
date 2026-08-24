<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String user = (String) session.getAttribute("username");

if (user == null) {
    response.sendRedirect("index.jsp");
}
%>

<html>
<head>
<title>File History</title>

<style>
body {
    font-family: Arial;
    background: #f4f6f9;
}

h2 {
    text-align: center;
}

table {
    width: 70%;
    margin: auto;
    border-collapse: collapse;
    background: white;
}

th, td {
    padding: 10px;
    border: 1px solid #ccc;
    text-align: center;
}
body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background:
        linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
        url("<%=request.getContextPath()%>/images/background.png") no-repeat center/cover;
    filter: blur(3px);
    z-index: -1;
}
.footer {
    position: fixed;
    bottom: 0;
    width: 100%;
    background: #2c3e50;
    color: #fff;
    text-align: center;
    padding: 8px;
    font-size: 13px;
    border-top: 2px solid #000;
}

.footer a {
    color: #00c3ff;
    text-decoration: none;
}
</style>
</head>

<body>

<h2>File Upload History</h2>
<form method="get" style="text-align:center; margin-bottom:20px;">

    <select name="category">
        <option value="">All</option>
        <option value="Bill">Bill</option>
        <option value="Notice">Notice</option>
        <option value="Document">Document</option>
        <option value="Bill" <%= "Bill".equals(request.getParameter("category")) ? "selected" : "" %>>Bill</option>
<option value="Notice" <%= "Notice".equals(request.getParameter("category")) ? "selected" : "" %>>Notice</option>
<option value="Document" <%= "Document".equals(request.getParameter("category")) ? "selected" : "" %>>Document</option>
    </select>

    <button type="submit">Filter</button>

</form>
<table>
<tr>
    <th>ID</th>
    <th>File Name</th>
    <th>Uploaded By</th>
    <th>Date</th>
    <th>Downloads</th>
</tr>

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();
String category = request.getParameter("category");

PreparedStatement ps;

if (category != null && !category.isEmpty()) {
    ps = con.prepareStatement("SELECT * FROM files WHERE category=?");
    ps.setString(1, category);
} else {
    ps = con.prepareStatement("SELECT * FROM files");
}

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("file_name") %></td>
    <td><%= rs.getString("uploaded_by") %></td>
    <td><%= rs.getString("upload_date") %></td>
    <td><%= rs.getInt("download_count") %></td>
</tr>

<%
}
%>

</table>

<div style="text-align:left; margin:15px;">
    <a href="adminDashboard" 
       style="text-decoration:none; 
              background:#2f80ed; 
              color:white; 
              padding:8px 15px; 
              border-radius:8px;
              font-size:14px;">
        ⬅ Back to Dashboard
    </a>
</div><div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div></body>
</html>