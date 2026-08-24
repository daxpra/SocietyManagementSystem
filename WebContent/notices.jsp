<%@ page import="java.sql.*,model.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Society Notices</title>

<style>

body{
font-family:Arial;
text-align:center;
margin-top:40px;
}

table{
margin:auto;
border-collapse:collapse;
}

th{
background:#4a6fb3;
color:white;
padding:10px;
}

td{
padding:10px;
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

<h2>Society Notices</h2>

<table border="1">

<tr>
<th>Title</th>
<th>Message</th>
<th>Date</th>
</tr>

<%

Connection con = null;
Statement stmt = null;
ResultSet rs = null;

try{

    con = DBConnection.getConnection();

    stmt = con.createStatement();

    rs = stmt.executeQuery("SELECT * FROM notices");

    while(rs.next()){

%>

<tr>
<td><%= rs.getString("title") %></td>
<td><%= rs.getString("message") %></td>
<td><%= rs.getDate("date") %></td>
</tr>

<%
    }

}catch(Exception e){

    out.println("Error : " + e.getMessage());

}finally{

    if(rs!=null) rs.close();
    if(stmt!=null) stmt.close();
    if(con!=null) con.close();

}
%>

</table>
<div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div>
</body>
</html>