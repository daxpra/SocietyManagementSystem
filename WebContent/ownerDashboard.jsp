<%@ page import="model.Member" %>

<%
Member owner = (Member) session.getAttribute("owner");

if(owner == null){
    response.sendRedirect("ownerLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Owner Dashboard</title>

<style>

body{
font-family:Arial;
text-align:center;
background-image:url("images/background.png");
background-size:cover;
}

.card{
width:200px;
height:120px;
background:#b9c7e3;
margin:20px;
border-radius:10px;
display:inline-block;
padding-top:20px;
}

button{
padding:10px 20px;
background:#4a6fb3;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
}

button:hover{
background:#365a9b;
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

</style>

</head>

<body>

<h1>Welcome <%= owner.getName() %></h1>

<div class="card">
<h3>My House</h3>
<button onclick="location.href='myHouse.jsp'">View</button>
</div>

<div class="card">
<h3>Maintenance</h3>
<button onclick="location.href='maintenance.jsp'">View</button>
</div>

<div class="card">
<h3>Documents</h3>
<button onclick="location.href='documents.jsp'">View</button>
</div>
<a href="LogoutServlet">Logout</a>
<div class="card">
<h3>Complaints</h3>
<button onclick="location.href='complaint.jsp'">Raise</button>
</div>

<div class="card">
<h3>Notices</h3>
<button onclick="location.href='notices.jsp'">View</button>
</div>

</body>
</html>