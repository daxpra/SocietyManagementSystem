<%@ page import="java.util.*" %>
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
!role.equalsIgnoreCase("user")){

    response.sendRedirect("index.jsp");
    return;
}

%>

<%

Connection con =
DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement(

"SELECT COUNT(*) FROM notifications WHERE receiver_role=? OR receiver_role='all'"

);

ps.setString(1, role);

ResultSet rs =
ps.executeQuery();

int count = 0;

if(rs.next()){
    count = rs.getInt(1);
}

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>User Dashboard</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
    background:rgba(15,23,42,0.96);
    backdrop-filter:blur(8px);
    position:fixed;
    top:0;
    left:0;
    color:white;
    padding-top:20px;
    transition:0.3s;
    z-index:1000;
}

.sidebar.hide{
    left:-240px;
}

/* LOGO */

.sidebar h2{
    text-align:center;
    margin-bottom:25px;
    font-size:28px;
}

/* LINKS */

.sidebar a{
    display:flex;
    align-items:center;
    gap:12px;
    color:#cbd5e1;
    padding:14px 18px;
    margin:8px 14px;
    border-radius:14px;
    text-decoration:none;
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

.main.full{
    margin-left:0;
}

/* HEADER */

.header{
    height:70px;
    background:rgba(37,99,235,0.95);
    backdrop-filter:blur(6px);
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 22px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
}

/* MENU BUTTON */

.menu-btn{
    font-size:24px;
    cursor:pointer;
}

/* TITLE */

.header-title{
    font-size:20px;
    font-weight:600;
}

/* CONTENT */

.container{
    flex:1;
    overflow-y:auto;
    padding:24px;
}

/* DASHBOARD TITLE */

.dashboard-title{
    font-size:32px;
    color:white;
    margin-bottom:25px;
}

/* CARDS */

.cards{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:22px;
}

/* CARD */

.card{
    background:rgba(255,255,255,0.97);
    padding:28px;
    border-radius:24px;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,0.12);
    transition:0.3s;
}

.card:hover{
    transform:translateY(-5px);
}

/* ICON */

.card i{
    font-size:42px;
    margin-bottom:15px;
    color:#2563eb;
}

/* CARD TEXT */

.card h3{
    font-size:20px;
    margin-bottom:12px;
    color:#0f172a;
}

.card h2{
    font-size:42px;
    color:#2563eb;
}

/* FOOTER */

.footer{
    background:#0f172a;
    color:white;
    text-align:center;
    padding:14px;
    font-size:13px;
    line-height:22px;
}

/* MOBILE */

@media(max-width:768px){

    body{
        overflow:auto;
    }

    .sidebar{
        left:-240px;
    }

    .sidebar.active{
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

    .container{
        padding:18px;
    }

    .dashboard-title{
        font-size:24px;
    }

    .cards{
        grid-template-columns:1fr;
    }

    .card{
        padding:24px;
    }

    .card h2{
        font-size:34px;
    }

    .footer{
        font-size:12px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .sidebar h2{
        font-size:24px;
    }

    .dashboard-title{
        font-size:22px;
    }

    .card h3{
        font-size:18px;
    }

    .card h2{
        font-size:30px;
    }
}

</style>

</head>

<body>

<!-- SOUND -->

<audio id="notifySound">

<source src="<%=request.getContextPath()%>/sounds/Samsung_notification_sound_M4A_128kbps.m4a">

</audio>

<!-- SIDEBAR -->

<div class="sidebar">

<h2>👤 User</h2>

<a href="userDashboard.jsp">
<i class="fa fa-home"></i>
Dashboard
</a>

<a href="complaint.jsp">
<i class="fa fa-exclamation-circle"></i>
Feedback / Complain
</a>

<a href="usernotification.jsp">
<i class="fa fa-bell"></i>
Notifications
</a>

<a href="logout.jsp">
<i class="fa fa-sign-out-alt"></i>
Logout
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

User Panel

</div>

<div>

Welcome
<b><%= user %></b>

</div>

</div>

<!-- CONTENT -->

<div class="container">

<h2 class="dashboard-title">

🏠 Dashboard

</h2>

<!-- CARDS -->

<div class="cards">

<div class="card">

<i class="fa fa-bell"></i>

<h3>Notifications</h3>

<h2>

<%= count %>

</h2>

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

/* SOUND */

window.onload = function(){

    var count =
    <%= count %>;

    if(count > 0){

        document
        .getElementById("notifySound")
        .play();

    }
};

/* SIDEBAR */

const menuBtn =
document.getElementById("menuBtn");

const sidebar =
document.querySelector(".sidebar");

menuBtn.onclick = () => {

if(window.innerWidth <= 768){

    sidebar.classList.toggle("active");

}else{

    sidebar.classList.toggle("hide");

    document.querySelector(".main")
    .classList.toggle("full");
}

};

</script>

</body>
</html>