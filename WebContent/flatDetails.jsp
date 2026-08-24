<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
prefix="fn" %>

<%

// SESSION CHECK

HttpSession sessionObj =
        request.getSession(false);

if(sessionObj == null ||
   sessionObj.getAttribute("admin") == null){

    response.sendRedirect("login.jsp");
    return;
}

// MESSAGE

String msg = request.getParameter("msg");

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Flat Details</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#f1f5f9;
    overflow-x:hidden;
    min-height:100vh;
    display:flex;
    flex-direction:column;
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
    linear-gradient(
    rgba(0,0,0,0.45),
    rgba(0,0,0,0.45)
    ),

    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;

    filter:blur(2px);

    z-index:-1;
}

/* MAIN */

.main{

    width:95%;
    max-width:1450px;

    margin:25px auto;

    background:rgba(255,255,255,0.97);

    padding:28px;

    border-radius:24px;

    box-shadow:0 8px 25px rgba(0,0,0,0.12);

    backdrop-filter:blur(5px);
}

/* TITLE */

h1{

    text-align:center;

    margin-bottom:25px;

    font-size:34px;

    color:#0f172a;
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

/* BUTTONS */

.back-btn{

    text-decoration:none;

    background:#f59e0b;

    color:white;

    padding:12px 22px;

    border-radius:12px;

    font-size:14px;

    font-weight:600;

    transition:0.3s;
}

.back-btn:hover{

    background:#d97706;
}

/* FILTER */

.filter-form{

    display:flex;

    gap:12px;

    flex-wrap:wrap;
}

select{

    padding:12px 14px;

    border-radius:12px;

    border:1px solid #cbd5e1;

    outline:none;

    font-size:14px;
}

.filter-btn{

    background:#2563eb;

    color:white;

    border:none;

    padding:12px 20px;

    border-radius:12px;

    cursor:pointer;

    font-size:14px;

    font-weight:600;
}

.filter-btn:hover{

    background:#1d4ed8;
}

/* TABLE */

.table-wrapper{

    width:100%;

    overflow-x:auto;

    border-radius:18px;

    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

table{

    width:100%;

    min-width:900px;

    border-collapse:collapse;

    background:white;
}

th{

    background:#2563eb;

    color:white;

    padding:15px 12px;

    font-size:14px;
}

td{

    padding:14px 10px;

    text-align:center;

    border-bottom:1px solid #e2e8f0;

    font-size:14px;
}

tr:hover td{

    background:#f8fafc;
}

/* STATUS */

.owner-status{

    color:#16a34a;

    font-weight:600;
}

.rented-status{

    color:#dc2626;

    font-weight:600;
}

.vacant-status{

    color:#f59e0b;

    font-weight:600;
}

/* ACTION BUTTON */

.action-btn{

    display:inline-block;

    padding:8px 16px;

    border-radius:8px;

    text-decoration:none;

    font-size:13px;

    font-weight:600;

    color:white;

    margin:2px;

    transition:0.3s;
}

.edit-btn{

    background:#2563eb;
}

.edit-btn:hover{

    background:#1d4ed8;
}

/* FOOTER */

.footer{

    margin-top:auto;

    width:100%;

    background:#0f172a;

    color:white;

    text-align:center;

    padding:14px 18px;

    font-size:13px;

    line-height:24px;
}

.footer a{

    color:#38bdf8;

    text-decoration:none;
}

/* MOBILE */

@media(max-width:768px){

    .main{

        width:95%;

        padding:18px;
    }

    h1{

        font-size:24px;
    }

    .top-bar{

        flex-direction:column;

        align-items:stretch;
    }

    .back-btn{

        width:100%;

        text-align:center;
    }

    .filter-form{

        flex-direction:column;
    }

    select,
    .filter-btn{

        width:100%;
    }

    th,
    td{

        font-size:12px;

        padding:10px 8px;
    }

    .action-btn{

        display:block;

        margin:5px auto;
    }
}

</style>

</head>

<body>

<% if(msg != null){ %>

<script>

<% if(msg.equals("Flat_Deleted_Successfully")){ %>

alert("Flat Deleted Successfully!");

<% } else if(msg.equals("Database_Error")){ %>

alert("Database Error!");

<% } else if(msg.equals("Invalid_Flat_Details")){ %>

alert("Invalid Flat Details!");

<% } %>

</script>

<% } %>

<div class="main">

<!-- TOP BAR -->

<div class="top-bar">

<a href="adminDashboard"
class="back-btn">

⬅ Back to Dashboard

</a>

<form method="get"
action="flatDetails"
class="filter-form">

<select name="wing">

<option value="">
All Wings
</option>

<option value="A">
Wing A
</option>

<option value="B">
Wing B
</option>

<option value="C">
Wing C
</option>

<option value="D">
Wing D
</option>

<option value="E">
Wing E
</option>

</select>

<button type="submit"
class="filter-btn">

Filter

</button>

</form>

</div>

<!-- TITLE -->

<h1>🏢 Flat Details</h1>

<!-- TABLE -->

<div class="table-wrapper">

<table>

<tr>

<th>Flat No</th>
<th>Owner</th>
<th>Tenant</th>
<th>Status</th>
<th>Actions</th>

</tr>

<c:forEach var="f"
items="${flatList}">

<tr>

<td>
${f.display_flat_no}
</td>

<td>
${f.owner}
</td>

<td>
${f.tenant}
</td>

<td>

<c:choose>

<c:when test="${f.status == 'Owner + Tenant'}">

<span style="color:#7c3aed;font-weight:600;">

Owner + Tenant

</span>

</c:when>

<c:when test="${f.status == 'Owner Occupied'}">

<span class="owner-status">

Owner Occupied

</span>

</c:when>

<c:when test="${f.status == 'Rented'}">

<span class="rented-status">

Rented

</span>

</c:when>

<c:otherwise>

<span class="vacant-status">

Vacant

</span>

</c:otherwise>

</c:choose>

</td>

<td>

<a href="editFlat?flat_no=${f.flat_no}&wing=${fn:substringBefore(f.display_flat_no,'-')}"
class="action-btn edit-btn">

Edit

</a>

</td>

</tr>

</c:forEach>
</table>

</div>

</div>

<!-- FOOTER -->

<div class="footer">

The Bharat Solutions,
224, Samruddhi Business Hub,
Naroda Dehgam Road,
Naroda, Ahmedabad, Gujarat - 382330.

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