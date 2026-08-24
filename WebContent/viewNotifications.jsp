<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%

String user =
(String)session.getAttribute("username");

String role =
(String)session.getAttribute("role");

if(user == null ||
role == null ||
!role.equalsIgnoreCase("security")){

    response.sendRedirect("index.jsp");
    return;
}

Connection con =
DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement(

"SELECT * FROM notifications WHERE sender_role='security' ORDER BY id DESC"

);

ResultSet rs =
ps.executeQuery();

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Security Notifications</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#eef2f7;
    color:#1e293b;
    min-height:100vh;
    display:flex;
    flex-direction:column;
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
    background:
    linear-gradient(rgba(0,0,0,0.45),
    rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* HEADER */

.header{
    background:rgba(22,163,116,0.95);
    color:white;
    padding:22px;
    text-align:center;
    font-size:34px;
    font-weight:700;
    box-shadow:0 3px 12px rgba(0,0,0,0.15);
}

/* CONTAINER */

.container{
    width:95%;
    max-width:1200px;
    margin:25px auto;
    flex:1;
}

/* GRID */

.notification-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
    gap:22px;
}

/* CARD */

.box{
    background:rgba(255,255,255,0.97);
    padding:24px;
    border-radius:24px;
    box-shadow:0 8px 20px rgba(0,0,0,0.10);
    transition:0.3s;
    backdrop-filter:blur(6px);
    word-wrap:break-word;
}

.box:hover{
    transform:translateY(-5px);
}

/* MESSAGE */

.box h3{
    font-size:24px;
    margin-bottom:18px;
    color:#0f172a;
    line-height:34px;
}

/* TEXT */

.box p{
    margin-bottom:12px;
    font-size:16px;
    line-height:28px;
    color:#475569;
}

/* STATUS */

.status{
    display:inline-block;
    padding:8px 18px;
    border-radius:20px;
    color:white;
    font-size:14px;
    font-weight:600;
    margin-top:6px;
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

/* EMPTY */

.no-data{
    background:white;
    padding:35px;
    border-radius:20px;
    text-align:center;
    font-size:22px;
    font-weight:600;
}

/* BACK BUTTON */

.back-wrap{
    text-align:center;
    margin-top:30px;
}

.back{
    display:inline-block;
    padding:14px 28px;
    background:#16a085;
    color:white;
    text-decoration:none;
    border-radius:14px;
    font-size:16px;
    font-weight:600;
    transition:0.3s;
}

.back:hover{
    background:#13856b;
    transform:translateY(-2px);
}

/* FOOTER */

.footer{
    background:#0f172a;
    color:white;
    text-align:center;
    padding:14px;
    font-size:13px;
    line-height:22px;
    margin-top:auto;
}

/* TABLET */

@media(max-width:992px){

    .header{
        font-size:30px;
    }

    .box h3{
        font-size:22px;
    }
}

/* MOBILE */

@media(max-width:768px){

    body{
        overflow:auto;
    }

    .header{
        font-size:24px;
        padding:18px;
    }

    .container{
        width:92%;
        margin:18px auto;
    }

    .notification-grid{
        grid-template-columns:1fr;
        gap:18px;
    }

    .box{
        padding:20px;
        border-radius:20px;
    }

    .box h3{
        font-size:20px;
        line-height:30px;
    }

    .box p{
        font-size:15px;
        line-height:25px;
    }

    .back{
        width:100%;
        text-align:center;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .header{
        font-size:22px;
    }

    .box{
        padding:18px;
    }

    .box h3{
        font-size:18px;
    }

    .box p{
        font-size:14px;
    }

    .status{
        width:100%;
        text-align:center;
    }
}

</style>

</head>

<body>

<!-- HEADER -->

<div class="header">

🔔 Security Notifications

</div>

<!-- CONTAINER -->

<div class="container">

<div class="notification-grid">

<%

boolean found = false;

while(rs.next()){

found = true;

String status =
rs.getString("status");

String statusClass =
status.toLowerCase();

%>

<div class="box">

<h3>

<%= rs.getString("message") %>

</h3>

<p>

Status :

<span class="status <%= statusClass %>">

<%= status %>

</span>

</p>

<p>

📅 Date :
<%= rs.getString("created_at") %>

</p>

</div>

<%
}

if(!found){
%>

<div class="no-data">

No Notifications Found ❌

</div>

<%
}
%>

</div>

<div class="back-wrap">

<a class="back"
href="securityDashboard.jsp">

⬅ Back to Dashboard

</a>

</div>

</div>

<!-- FOOTER -->

<div class="footer">

The Bharat Solutions |
Ahmedabad |
+91-95865 05037

</div>

</body>

</html>

