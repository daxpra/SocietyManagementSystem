<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Notifications</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#f1f5f9;
    padding:20px;
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
}

/* TITLE */

.page-title{
    text-align:center;
    font-size:34px;
    margin-bottom:25px;
    color:#0f172a;
}

/* CARD */

.card{
    background:#ffffff;
    padding:25px;
    border-radius:22px;
    margin-bottom:25px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

/* FORM */

.form-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:15px;
}

/* INPUTS */

input,
textarea,
select{
    width:100%;
    padding:12px 14px;
    border-radius:12px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:14px;
    transition:0.3s;
    resize:none;
}

input:focus,
textarea:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* TEXTAREA */

textarea{
    min-height:120px;
    grid-column:1/-1;
}

/* BUTTON */

.submit-btn{
    background:#16a34a;
    color:white;
    border:none;
    padding:13px;
    border-radius:12px;
    cursor:pointer;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.submit-btn:hover{
    background:#15803d;
    transform:translateY(-2px);
}

/* TABLE */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    border-radius:20px;
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
    padding:14px 12px;
    text-align:center;
    border-bottom:1px solid #e2e8f0;
    font-size:14px;
}

tr:hover td{
    background:#f8fafc;
}

/* DELETE BUTTON */

.delete-btn{
    text-decoration:none;
    background:#ef4444;
    color:white;
    padding:8px 14px;
    border-radius:10px;
    font-size:13px;
    transition:0.3s;
    display:inline-block;
}

.delete-btn:hover{
    background:#dc2626;
}

/* BACK BUTTON */

.back-box{
    margin-top:25px;
    text-align:center;
}

.back-btn{
    display:inline-block;
    text-decoration:none;
    background:#0f172a;
    color:white;
    padding:12px 22px;
    border-radius:12px;
    font-size:15px;
    transition:0.3s;
}

.back-btn:hover{
    background:#1e293b;
    transform:translateY(-2px);
}

/* FOOTER */

.footer{
    margin-top:30px;
    width:100%;
    background:#0f172a;
    color:white;
    text-align:center;
    padding:14px 18px;
    font-size:13px;
    line-height:24px;
    border-radius:14px;
}

.footer a{
    color:#38bdf8;
    text-decoration:none;
}

.footer a:hover{
    text-decoration:underline;
}

/* TABLET */

@media(max-width:992px){

    .page-title{
        font-size:30px;
    }
}

/* MOBILE */

@media(max-width:768px){

    body{
        padding:15px;
    }

    .page-title{
        font-size:24px;
    }

    .card{
        padding:18px;
        border-radius:18px;
    }

    .form-grid{
        grid-template-columns:1fr;
    }

    table{
        min-width:850px;
    }

    th,
    td{
        font-size:12px;
        padding:10px 8px;
    }

    .submit-btn{
        width:100%;
    }

    .back-btn{
        width:100%;
        text-align:center;
    }

    .footer{
        font-size:12px;
        line-height:22px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .page-title{
        font-size:22px;
    }

    textarea{
        min-height:100px;
    }
}

</style>

</head>

<body>

<div class="container">

<!-- TITLE -->

<h2 class="page-title">
📢 Manage Notifications
</h2>

<!-- FORM CARD -->

<div class="card">

<form action="<%= request.getContextPath() %>/addNotification"
method="post">

<div class="form-grid">

<input type="text"
name="title"
placeholder="Notification Title"
required>

<select name="receiver_role" required>

<option value="">
Select Receiver
</option>

<option value="user">
User
</option>

<option value="security">
Security
</option>

<option value="all">
All
</option>

</select>

<textarea
name="message"
placeholder="Write notification message..."
required></textarea>

<button type="submit"
class="submit-btn">

Add Notification

</button>

</div>

</form>

</div>

<!-- TABLE -->

<%

Connection con =
DBConnection.getConnection();

Statement st =
con.createStatement();

ResultSet rs =
st.executeQuery(
"SELECT * FROM notifications ORDER BY id DESC"
);

%>

<div class="table-wrapper">

<table>

<tr>

<th>ID</th>
<th>Title</th>
<th>Message</th>
<th>Date</th>
<th>Receiver</th>
<th>Action</th>

</tr>

<%

while(rs.next()){

%>

<tr>

<td>
<%= rs.getInt("id") %>
</td>

<td>
<%= rs.getString("title") %>
</td>

<td>
<%= rs.getString("message") %>
</td>

<td>
<%= rs.getString("created_at") %>
</td>

<td>
<%= rs.getString("receiver_role") %>
</td>

<td>

<a class="delete-btn"
href="<%= request.getContextPath() %>/deleteNotification?id=<%= rs.getInt("id") %>">

Delete

</a>

</td>

</tr>

<%
}
%>

</table>

</div>

<!-- BACK -->

<div class="back-box">

<a href="adminDashboard"
class="back-btn">

⬅ Back to Dashboard

</a>

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

</div>

</body>
</html>