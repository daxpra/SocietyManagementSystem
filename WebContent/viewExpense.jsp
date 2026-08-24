<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
Connection con = null;
Statement st = null;
PreparedStatement ps = null;
ResultSet rs = null;
ResultSet rsTotal = null;

int totalExpense = 0;

try {

    con = DBConnection.getConnection();

    if(con == null){
        out.println("<h3 style='color:red;'>Database Connection Failed</h3>");
        return;
    }

    /* GET DATA */

    st = con.createStatement();

    rs = st.executeQuery(
    "SELECT * FROM expense ORDER BY `date` DESC"
    );

    /* TOTAL EXPENSE */

    ps = con.prepareStatement(
    "SELECT COALESCE(SUM(amount),0) FROM expense"
    );

    rsTotal = ps.executeQuery();

    if(rsTotal.next()){
        totalExpense = rsTotal.getInt(1);
    }

} catch(Exception e){

    out.println(
    "<h3 style='color:red;'>Error: "
    + e.getMessage() +
    "</h3>"
    );
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Expense</title>

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
    padding:20px;
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

/* TOP CARD */

.top-card{
    background:linear-gradient(135deg,#dc2626,#ef4444);
    color:white;
    padding:30px;
    border-radius:24px;
    text-align:center;
    margin-bottom:25px;
    box-shadow:0 8px 20px rgba(0,0,0,0.1);
}

.top-card h3{
    font-size:22px;
    margin-bottom:10px;
}

.top-card h1{
    font-size:48px;
}

/* FORM BOX */

.form-box{
    background:#ffffff;
    padding:25px;
    border-radius:22px;
    margin-bottom:25px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

.form-box h3{
    margin-bottom:18px;
    font-size:24px;
    color:#0f172a;
}

/* FORM GRID */

.form-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:15px;
    align-items:end;
}

/* INPUTS */

input,
select{
    width:100%;
    padding:12px 14px;
    border:1px solid #cbd5e1;
    border-radius:12px;
    outline:none;
    font-size:14px;
    transition:0.3s;
}

input:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
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

/* TABLE WRAPPER */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    border-radius:20px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

/* TABLE */

table{
    width:100%;
    min-width:800px;
    border-collapse:collapse;
    background:white;
}

th{
    background:#2563eb;
    color:white;
    padding:15px 12px;
    font-size:15px;
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

/* TABLET */

@media(max-width:992px){

    .page-title{
        font-size:30px;
    }

    .top-card h1{
        font-size:42px;
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

    .top-card{
        padding:22px;
        border-radius:18px;
    }

    .top-card h3{
        font-size:18px;
    }

    .top-card h1{
        font-size:34px;
    }

    .form-box{
        padding:18px;
        border-radius:18px;
    }

    .form-box h3{
        font-size:20px;
    }

    .form-grid{
        grid-template-columns:1fr;
    }

    table{
        min-width:700px;
    }

    th,td{
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

    .top-card h1{
        font-size:28px;
    }

    .form-box h3{
        font-size:18px;
    }
}

</style>

</head>

<body>

<div class="container">

<!-- TITLE -->

<h2 class="page-title">
💸 Expense
</h2>

<!-- TOTAL CARD -->

<div class="top-card">

    <h3>Total Expense</h3>

    <h1>₹<%= totalExpense %></h1>

</div>

<!-- FORM -->

<div class="form-box">

<h3>➕ Add Expense</h3>

<form action="<%= request.getContextPath() %>/addExpense"
method="post">

<div class="form-grid">

<input type="number"
name="amount"
placeholder="Amount"
required>

<select name="type" required>

<option value="">
Select Type
</option>

<option value="Electricity">
Electricity
</option>

<option value="Water">
Water
</option>

<option value="Maintenance">
Maintenance
</option>

<option value="Security">
Security
</option>

<option value="Other">
Other
</option>

</select>

<input type="text"
name="description"
placeholder="Description">

<input type="date"
name="date"
value="<%= java.time.LocalDate.now() %>"
required>

<button type="submit"
class="submit-btn">

Add Expense

</button>

</div>

</form>

</div>

<!-- TABLE -->

<div class="table-wrapper">

<table>

<tr>

<th>ID</th>
<th>Amount</th>
<th>Type</th>
<th>Description</th>
<th>Date</th>

</tr>

<%

try{

if(rs != null){

while(rs.next()){

%>

<tr>

<td>
<%= rs.getInt("id") %>
</td>

<td>
₹<%= rs.getInt("amount") %>
</td>

<td>
<%= (rs.getString("type") != null)
? rs.getString("type")
: "others" %>
</td>

<td>
<%= rs.getString("description") %>
</td>

<td>
<%= rs.getString("date") %>
</td>

</tr>

<%
        }
    }

}catch(Exception e){

out.println(
"<tr><td colspan='5'>Error loading data</td></tr>"
);

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
Ahmedabad

<br>

Contact:
+91-95865 05037

</div>

</div>

</body>
</html>

<%

/* CLOSE RESOURCES */

try {

if(rs != null) rs.close();

if(rsTotal != null) rsTotal.close();

if(st != null) st.close();

if(ps != null) ps.close();

if(con != null) con.close();

}catch(Exception e){}

%>