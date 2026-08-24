<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%

String role =
(String) session.getAttribute("role");

String user =
(String) session.getAttribute("username");

String flatNo =
(String) session.getAttribute("flat_no");

/* SESSION CHECK */

if(user == null || role == null){

    response.sendRedirect("index.jsp");
    return;
}

role = role.toLowerCase();

/* BACK PAGE */

String backPage = "userDashboard.jsp";

if("security".equalsIgnoreCase(role)){

    backPage = "securityDashboard.jsp";

}else if("admin".equalsIgnoreCase(role)){

    backPage = "adminDashboard.jsp";

}else{

    backPage = "userDashboard.jsp";
}

/* DATABASE */

Connection con =
DBConnection.getConnection();

PreparedStatement ps = null;

/* USER NOTIFICATIONS */

if("user".equalsIgnoreCase(role)){

    ps = con.prepareStatement(

    		"SELECT * FROM notifications " +
    				"WHERE receiver_role=? OR receiver_role='all' " +
    				"ORDER BY id DESC"
    );

    ps.setString(1, role);

}else{

    /* ADMIN + SECURITY */

    ps = con.prepareStatement(

    "SELECT * FROM notifications " +
    "WHERE receiver_role=? OR receiver_role='all' " +
    "ORDER BY id DESC"

    );

    ps.setString(1, role);
}

ResultSet rs =
ps.executeQuery();

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Notifications</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#eef2f7;
    min-height:100vh;
    overflow-x:hidden;
    color:#1e293b;
    display:flex;
    flex-direction:column;
}

body::before{
    content:"";
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:
    linear-gradient(rgba(0,0,0,0.45),
    rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

.header{
    background:rgba(37,99,235,0.95);
    color:white;
    text-align:center;
    padding:18px;
    font-size:28px;
    font-weight:600;
}

.container{
    width:95%;
    max-width:1000px;
    margin:25px auto;
    flex:1;
}

.welcome{
    background:white;
    padding:16px 20px;
    border-radius:18px;
    margin-bottom:20px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

.card{
    background:white;
    padding:22px;
    margin-bottom:18px;
    border-radius:22px;
    box-shadow:0 8px 20px rgba(0,0,0,0.08);
}

.msg{
    font-size:18px;
    font-weight:600;
    margin-bottom:12px;
}

.meta{
    font-size:13px;
    color:#64748b;
    margin-bottom:6px;
}

.status{
    margin-top:10px;
    font-size:14px;
    font-weight:600;
}

.pending{
    color:#f59e0b;
}

.approved{
    color:#16a34a;
}

.rejected{
    color:#dc2626;
}

.btn-group{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
    margin-top:18px;
}

.btn{
    padding:12px 18px;
    border:none;
    border-radius:12px;
    color:white;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
}

.approve{
    background:#16a34a;
}

.reject{
    background:#ef4444;
}

.no-data{
    background:white;
    padding:22px;
    border-radius:18px;
    text-align:center;
}

.back-box{
    text-align:center;
    margin-top:25px;
}

.back-btn{
    display:inline-block;
    text-decoration:none;
    background:#2563eb;
    color:white;
    padding:14px 24px;
    border-radius:14px;
}

.footer{
    background:#0f172a;
    color:white;
    text-align:center;
    padding:14px;
    margin-top:auto;
}

@media(max-width:768px){

    .btn-group{
        flex-direction:column;
    }

    .btn,
    .back-btn{
        width:100%;
    }
}

</style>

</head>

<body>

<div class="header">

🔔 Notifications

</div>

<div class="container">

<div class="welcome">

Welcome,
<b><%= user %></b>

</div>

<%

boolean found = false;

while(rs.next()){

found = true;

String message =
rs.getString("message");

String sender =
rs.getString("sender_role");

String status =
rs.getString("status");

%>

<div class="card">

<div class="msg">

<%= message %>

</div>

<div class="meta">

From:
<b><%= sender %></b>

</div>

<div class="meta">

<%= rs.getString("created_at") %>

</div>

<div class="status
<%= status.toLowerCase() %>">

Status :
<%= status %>

</div>

<%

if("security".equalsIgnoreCase(sender)
&& "user".equalsIgnoreCase(role)
&& "pending".equalsIgnoreCase(status)){

%>

<div class="btn-group">

<form action="<%= request.getContextPath() %>/VisitorActionServlet"
method="post">

<input type="hidden"
name="requestId"
value="<%= rs.getString("id") %>">

<input type="hidden"
name="action"
value="approve">

<button type="submit"
class="btn approve">

✅ Approve

</button>

</form>

<form action="<%= request.getContextPath() %>/VisitorActionServlet"
method="post">

<input type="hidden"
name="requestId"
value="<%= rs.getString("id") %>">

<input type="hidden"
name="action"
value="reject">

<button type="submit"
class="btn reject">

❌ Reject

</button>

</form>

</div>

<%
}
%>

</div>

<%
}

if(!found){
%>

<div class="no-data">

No notifications found ❌

</div>

<%
}
%>

<div class="back-box">

<a class="back-btn"
href="<%= request.getContextPath() + "/" + backPage %>">

⬅ Back to Dashboard

</a>

</div>

</div>

<div class="footer">

The Bharat Solutions |
Ahmedabad |
+91-95865 05037

</div>

</body>
</html>