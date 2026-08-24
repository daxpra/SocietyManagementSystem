<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%

String role =
(String) session.getAttribute("role");

String user =
(String) session.getAttribute("username");

if(user == null ||
role == null ||
!role.equalsIgnoreCase("security")){

    response.sendRedirect("index.jsp");
    return;
}

%>

<%

Connection con =
DBConnection.getConnection();

/* NOTIFICATION COUNT */

PreparedStatement psNotify =
con.prepareStatement(

"SELECT COUNT(*) FROM notifications WHERE receiver_role='security' OR receiver_role='all'"

);

ResultSet rsNotify =
psNotify.executeQuery();

int notifyCount = 0;

if(rsNotify.next()){
    notifyCount = rsNotify.getInt(1);
}

/* VISITOR COUNT */

PreparedStatement ps1 =
con.prepareStatement(
"SELECT COUNT(*) FROM visitors"
);

ResultSet rs1 =
ps1.executeQuery();

rs1.next();

int totalVisitors =
rs1.getInt(1);

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Security Dashboard</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#eef2f7;
    overflow:hidden;
    color:#1e293b;
}

/* BACKGROUND */

body::before{
    content:"";
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:
    linear-gradient(rgba(0,0,0,0.40),
    rgba(0,0,0,0.40)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* SIDEBAR */

.sidebar{
    width:240px;
    height:100vh;
    background:rgba(15,23,42,0.95);
    backdrop-filter:blur(8px);
    position:fixed;
    top:0;
    left:0;
    padding-top:20px;
    transition:0.3s;
    z-index:1000;
    overflow-y:auto;
}

.sidebar.hide{
    left:-240px;
}

.logo{
    text-align:center;
    color:white;
    font-size:28px;
    margin-bottom:25px;
}

/* SIDEBAR LINKS */

.sidebar a{
    display:flex;
    align-items:center;
    gap:12px;
    margin:8px 14px;
    padding:14px;
    text-decoration:none;
    color:#cbd5e1;
    border-radius:14px;
    transition:0.3s;
    font-size:15px;
    font-weight:500;
}

.sidebar a:hover{
    background:#2563eb;
    color:white;
    transform:translateX(5px);
}

/* MAIN */

.main{
    margin-left:240px;
    height:100vh;
    display:flex;
    flex-direction:column;
    transition:0.3s;
}

/* HEADER */

.header{
    height:70px;
    background:rgba(22,163,116,0.95);
    backdrop-filter:blur(6px);
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 22px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
}

.menu-btn{
    font-size:24px;
    cursor:pointer;
}

/* HEADER TITLE */

.header-title{
    font-size:20px;
    font-weight:600;
}

/* CONTENT */

.content{
    flex:1;
    overflow-y:auto;
    padding:22px;
}

/* CARDS */

.cards{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:20px;
    margin-bottom:25px;
}

/* CARD */

.card{
    padding:28px;
    border-radius:24px;
    color:white;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,0.12);
    transition:0.3s;
}

.card:hover{
    transform:translateY(-5px);
}

.card h2{
    margin-top:12px;
    font-size:40px;
}

.card p{
    font-size:18px;
    margin-top:5px;
}

/* CARD COLORS */

.blue{
    background:linear-gradient(135deg,#2563eb,#3b82f6);
}

.orange{
    background:linear-gradient(135deg,#f59e0b,#fbbf24);
}

/* TABLE SECTION */

.table-box{
    background:rgba(255,255,255,0.96);
    padding:24px;
    border-radius:24px;
    box-shadow:0 8px 20px rgba(0,0,0,0.08);
}

/* TABLE TITLE */

.table-title{
    margin-bottom:18px;
    font-size:26px;
    color:#0f172a;
}

/* TABLE WRAPPER */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    border-radius:18px;
}

/* TABLE */

table{
    width:100%;
    min-width:700px;
    border-collapse:collapse;
    background:white;
}

/* HEADER */

th{
    background:#16a085;
    color:white;
    padding:15px 12px;
    font-size:14px;
}

/* TD */

td{
    padding:14px 12px;
    text-align:center;
    border-bottom:1px solid #e2e8f0;
    font-size:14px;
}

tr:hover td{
    background:#f8fafc;
}

/* BADGES */

.badge{
    padding:8px 14px;
    border-radius:20px;
    color:white;
    font-size:12px;
    font-weight:600;
}

.pending{
    background:#f59e0b;
}

.approved{
    background:#16a34a;
}

.rejected{
    background:#ef4444;
}

/* FOOTER */

.footer{
    background:#0f172a;
    color:white;
    text-align:center;
    padding:14px;
    font-size:13px;
}

/* TABLET */

@media(max-width:992px){

    .header-title{
        font-size:18px;
    }

    .card h2{
        font-size:34px;
    }
}

/* MOBILE */

@media(max-width:768px){

    body{
        overflow:auto;
    }

    .sidebar{
        left:-240px;
    }

    .sidebar.show{
        left:0;
    }

    .main{
        margin-left:0;
        height:auto;
        min-height:100vh;
    }

    .header{
        height:65px;
        padding:0 16px;
    }

    .header-title{
        font-size:16px;
    }

    .content{
        padding:16px;
    }

    .cards{
        grid-template-columns:1fr;
    }

    .card{
        padding:22px;
    }

    .card h2{
        font-size:30px;
    }

    .table-box{
        padding:18px;
        border-radius:18px;
    }

    .table-title{
        font-size:22px;
    }

    table{
        min-width:650px;
    }

    th,
    td{
        font-size:12px;
        padding:10px 8px;
    }

    .footer{
        font-size:12px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .logo{
        font-size:24px;
    }

    .card p{
        font-size:16px;
    }

    .card h2{
        font-size:26px;
    }

    .table-title{
        font-size:20px;
    }
}

</style>

</head>

<body>

<!-- SIDEBAR -->

<div class="sidebar">

<div class="logo">
👮 Security
</div>

<a href="securityDashboard.jsp">
🏠 Dashboard
</a>

<a href="visitorEntry">
🚪 Visitor Entry
</a>

<a href="viewNotifications">
🔔 Notifications
</a>

<a href="visitorHistory.jsp">
📜 History
</a>

<a href="logout.jsp">
🚪 Logout
</a>

</div>

<!-- MAIN -->

<div class="main">

<!-- HEADER -->

<div class="header">

<div class="menu-btn"
id="menuBtn">

☰

</div>

<div class="header-title">
Security Panel
</div>

<div>
Welcome
<b><%= user %></b>
</div>

</div>

<!-- CONTENT -->

<div class="content">

<!-- CARDS -->

<div class="cards">

<div class="card blue">

<div style="font-size:42px;">
👤
</div>

<p>Total Visitors</p>

<h2>
<%= totalVisitors %>
</h2>

</div>

<div class="card orange">

<div style="font-size:42px;">
🔔
</div>

<p>Notifications</p>

<h2>
<%= notifyCount %>
</h2>

</div>

</div>

<!-- TABLE -->

<div class="table-box">

<h2 class="table-title">
🚪 Visitor Requests
</h2>

<%

PreparedStatement ps =
con.prepareStatement(

		"SELECT * FROM notifications WHERE sender_role='security' ORDER BY id DESC"
);

ResultSet rs =
ps.executeQuery();

%>

<div class="table-wrapper">

<table>

<tr>

<th>Message</th>
<th>Status</th>

</tr>

<%

while(rs.next()){

String status =
rs.getString("status");

%>

<tr>

<td>
<%= rs.getString("message") %>
</td>

<td>

<%

if("approved".equalsIgnoreCase(status)){

%>

<span class="badge approved">
Approved
</span>

<%

}else if(
"rejected".equalsIgnoreCase(status)
){

%>

<span class="badge rejected">
Rejected
</span>

<%

}else{

%>

<span class="badge pending">
Pending
</span>

<%
}
%>

</td>

</tr>

<%
}
%>

</table>

</div>

</div>

</div>

<!-- FOOTER -->

<div class="footer">

The Bharat Solutions |
Ahmedabad |
+91-95865 05037

</div>

</div>

<script>

const menuBtn =
document.getElementById("menuBtn");

const sidebar =
document.querySelector(".sidebar");

menuBtn.onclick = () => {

if(window.innerWidth <= 768){

    sidebar.classList.toggle("show");

}else{

    sidebar.classList.toggle("hide");

    document.querySelector(".main")
    .classList.toggle("full");
}

};

</script>

</body>
</html>