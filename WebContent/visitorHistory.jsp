<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%

String role =
(String) session.getAttribute("role");

if(role == null){

    response.sendRedirect("index.jsp");
    return;
}

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Visitor History</title>

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
    background:rgba(15,23,42,0.95);
    backdrop-filter:blur(6px);
    color:white;
    text-align:center;
    padding:18px;
    font-size:30px;
    font-weight:600;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
}

/* MAIN CONTAINER */

.container{
    width:95%;
    max-width:1400px;
    margin:25px auto;
    flex:1;
}

/* SEARCH BOX */

.search-box{
    background:rgba(255,255,255,0.97);
    padding:22px;
    border-radius:24px;
    box-shadow:0 8px 20px rgba(0,0,0,0.08);
    margin-bottom:25px;
}

/* FORM */

.search-form{
    display:flex;
    gap:14px;
    flex-wrap:wrap;
    justify-content:center;
    align-items:center;
}

/* INPUT */

.search-form input{
    flex:1;
    min-width:240px;
    padding:14px;
    border-radius:14px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:15px;
    transition:0.3s;
}

.search-form input:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* BUTTON */

.btn{
    padding:14px 22px;
    border:none;
    border-radius:14px;
    color:white;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
    transition:0.3s;
}

/* BUTTON COLORS */

.search-btn{
    background:#2563eb;
}

.search-btn:hover{
    background:#1d4ed8;
}

.today-btn{
    background:#16a34a;
}

.today-btn:hover{
    background:#15803d;
}

.reset-btn{
    background:#f59e0b;
    text-decoration:none;
    display:inline-block;
}

.reset-btn:hover{
    background:#d97706;
}

.back-btn{
    background:#0f172a;
    text-decoration:none;
    display:inline-block;
}

.back-btn:hover{
    background:#1e293b;
}

/* TABLE BOX */

.table-box{
    background:rgba(255,255,255,0.97);
    padding:24px;
    border-radius:24px;
    box-shadow:0 8px 20px rgba(0,0,0,0.08);
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
    min-width:850px;
    border-collapse:collapse;
    background:white;
}

/* HEADER */

th{
    background:#2563eb;
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

/* NO DATA */

.no-data{
    text-align:center;
    padding:20px;
    color:#ef4444;
    font-weight:600;
}

/* BACK BOX */

.back-box{
    text-align:center;
    margin-top:25px;
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

.footer a{
    color:#38bdf8;
    text-decoration:none;
}

.footer a:hover{
    text-decoration:underline;
}

/* MOBILE */

@media(max-width:768px){

    .header{
        font-size:24px;
        padding:16px;
    }

    .search-box,
    .table-box{
        padding:18px;
        border-radius:18px;
    }

    .search-form{
        flex-direction:column;
        align-items:stretch;
    }

    .search-form input{
        width:100%;
        min-width:100%;
    }

    .btn{
        width:100%;
        text-align:center;
    }

    table{
        min-width:750px;
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

    .header{
        font-size:20px;
    }

    .btn{
        font-size:13px;
    }
}

</style>

</head>

<body>

<!-- HEADER -->

<div class="header">

🚪 Visitor History

</div>

<!-- CONTAINER -->

<div class="container">

<!-- SEARCH BOX -->

<div class="search-box">

<form method="get"
action="visitorHistory"
class="search-form">

<input type="text"
name="search"
placeholder="Search visitor name or vehicle number">

<button type="submit"
class="btn search-btn">

🔍 Search

</button>

<button type="submit"
name="filter"
value="today"
class="btn today-btn">

📅 Today

</button>

<a href="visitorHistory"
class="btn reset-btn">

♻ Reset

</a>

</form>

</div>

<!-- TABLE BOX -->

<div class="table-box">

<div class="table-wrapper">

<table>

<tr>

<th>Name</th>
<th>Mobile</th>
<th>Flat</th>
<th>Vehicle</th>
<th>Purpose</th>
<th>Time</th>

</tr>

<%

List<Map<String,String>> list =
(List<Map<String,String>>)
request.getAttribute("visitorList");

if(list != null &&
!list.isEmpty()){

for(Map<String,String> v : list){

%>

<tr>

<td>
<%= v.get("name") %>
</td>

<td>
<%= v.get("mobile") %>
</td>

<td>
<%= v.get("flat") %>
</td>

<td>
<%= v.get("vehicle") %>
</td>

<td>
<%= v.get("purpose") %>
</td>

<td>
<%= v.get("time") %>
</td>

</tr>

<%
    }

}else{
%>

<tr>

<td colspan="6"
class="no-data">

No visitors found ❌

</td>

</tr>

<%
}
%>

</table>

</div>

</div>

<!-- BACK BUTTON -->

<div class="back-box">

<a href="securityDashboard.jsp"
class="btn back-btn">

⬅ Back to Dashboard

</a>

</div>

</div>

<!-- FOOTER -->

<div class="footer">

The Bharat Solutions,
224, Samruddhi Business Hub,
Naroda Dehgam Road,
Naroda, Ahmedabad, Gujarat.

<br>

Contact no:
+91-95865 05037

&nbsp; | &nbsp;

Visit:
<a href="https://thebharatsolutions.com"
target="_blank">

Thebharatsolutions.com

</a>

</div>

</body>
</html>