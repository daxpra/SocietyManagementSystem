<%@ page import="java.sql.*,model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Penalty Master</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#eef2f7;
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
    linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* MAIN CONTAINER */

.container{
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

h2{
    text-align:center;
    border:2px solid #22c55e;
    padding:14px;
    border-radius:16px;
    margin-bottom:25px;
    font-size:32px;
    color:#0f172a;
}

/* EXPORT BUTTON */

.top-action{
    display:flex;
    justify-content:flex-end;
    margin-bottom:20px;
}

.export{
    background:#2563eb;
    color:white;
    padding:12px 20px;
    border-radius:12px;
    text-decoration:none;
    font-size:14px;
    font-weight:600;
    transition:0.3s;
}

.export-btn{
    display:inline-block;
    background:linear-gradient(135deg,#2563eb,#1d4ed8);
    color:white;
    padding:14px 28px;
    border-radius:14px;
    text-decoration:none;
    font-size:16px;
    font-weight:600;
    border:none;
    transition:0.3s ease;
    box-shadow:0 4px 12px rgba(37,99,235,0.3);
}

.export-btn:hover{
    transform:translateY(-2px);
    box-shadow:0 6px 16px rgba(37,99,235,0.4);
    background:linear-gradient(135deg,#1d4ed8,#1e40af);
}

.export:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
}

/* FORM */

.form-box{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:15px;
    margin-bottom:30px;
    align-items:end;
}

/* INPUTS */

input,
select{
    width:100%;
    padding:12px 14px;
    border-radius:12px;
    border:1px solid #cbd5e1;
    font-size:14px;
    outline:none;
    transition:0.3s;
    background:white;
}

input:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* BUTTON */

.btn{
    padding:13px;
    border:none;
    border-radius:12px;
    cursor:pointer;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.add-btn{
    background:#16a34a;
    color:white;
}

.add-btn:hover{
    background:#15803d;
    transform:translateY(-2px);
}

/* TABLE WRAPPER */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    border-radius:18px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

/* TABLE */

table{
    width:100%;
    min-width:1000px;
    border-collapse:collapse;
    background:white;
}

/* TABLE HEADER */

th{
    background:#2563eb;
    color:white;
    padding:15px 12px;
    font-size:14px;
    border:none;
}

/* TABLE DATA */

td{
    padding:14px 10px;
    text-align:center;
    border-bottom:1px solid #e2e8f0;
    font-size:14px;
}

tr:hover td{
    background:#f8fafc;
}

/* IMAGE */

.penalty-img{
    width:60px;
    height:60px;
    object-fit:cover;
    border-radius:12px;
    border:2px solid #e2e8f0;
}

/* DELETE */

.delete{
    text-decoration:none;
    background:#ef4444;
    color:white;
    padding:8px 12px;
    border-radius:10px;
    font-size:13px;
    transition:0.3s;
}

.delete:hover{
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
    background:#f59e0b;
    color:white;
    padding:12px 22px;
    border-radius:12px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    background:#d97706;
    transform:translateY(-2px);
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

.footer a:hover{
    text-decoration:underline;
}

/* TABLET */

@media(max-width:992px){

    h2{
        font-size:28px;
    }

    .form-box{
        grid-template-columns:repeat(2,1fr);
    }
}

/* MOBILE */

@media(max-width:768px){

    .container{
        width:95%;
        padding:18px;
        border-radius:18px;
    }

    h2{
        font-size:22px;
        padding:12px;
    }

    .top-action{
        justify-content:center;
    }

    .export{
        width:100%;
        text-align:center;
    }

    .form-box{
        grid-template-columns:1fr;
    }

    input,
    select,
    .btn{
        width:100%;
    }

    table{
        min-width:900px;
    }

    th,
    td{
        font-size:12px;
        padding:10px 8px;
    }

    .penalty-img{
        width:50px;
        height:50px;
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

    h2{
        font-size:20px;
    }

    .container{
        padding:15px;
    }

.export-btn{
    background:#2d6cdf;
    color:white;
    padding:12px 22px;
    border-radius:10px;
    text-decoration:none;
    font-weight:600;
}

    .btn,
    .export{
        font-size:13px;
    }
}

</style>

</head>

<body>

<div class="container">

<h2>⚠️ Penalty Master</h2>

<!-- EXPORT -->

<div class="top-action">

<a href="exportPenalty" class="export-btn">
    ⬇ Export All Details
</a>
</div>

<!-- FORM -->

<form action="addPenalty"
method="post"
enctype="multipart/form-data"
class="form-box">

<input type="date"
name="start_date"
required>

<input type="text"
name="type"
placeholder="Penalty Type"
required>

<input type="number"
name="charge"
placeholder="Charge per day"
required>

<input type="file"
name="photo">

<select name="flat_no" required>

<option value="">
Select Flat
</option>

<%

char[] wings = {'A','B','C','D','E'};

for(char w : wings){

    for(int floor = 1; floor <= 7; floor++){

        for(int flat = 1; flat <= 4; flat++){

            String flatNo =
            w + "-" + floor + "0" + flat;

%>

<option value="<%=flatNo%>">
<%=flatNo%>
</option>

<%
        }
    }
}
%>

</select>

<input type="number"
name="total_maintenance"
placeholder="Total Maintenance"
required>

<button class="btn add-btn">
Add Penalty
</button>

</form>

<!-- TABLE -->

<div class="table-wrapper">

<table>

<tr>

<th>Start Date</th>
<th>Type of Penalty</th>
<th>Charge/Per Day</th>
<th>Photo</th>
<th>House No</th>
<th>Total Maintenance</th>
</tr>

<%

try{

Connection con =
DBConnection.getConnection();

Statement st =
con.createStatement();

ResultSet rs =
st.executeQuery(
"SELECT * FROM penalty"
);

while(rs.next()){

%>

<tr>

<td>
<%= rs.getDate("start_date") %>
</td>

<td>
<%= rs.getString("type") %>
</td>

<td>
₹<%= rs.getInt("charge") %>
</td>

<td>

<%

String photo =
rs.getString("photo");

if(photo != null &&
!photo.equals("")){

%>

<img
class="penalty-img"
src="uploads/<%= photo %>">

<%

}else{

%>

📷

<%
}
%>

</td>

<td>
<%= rs.getString("flat_no") %>
</td>

<td>
₹<%= rs.getString("total_maintenance") %>
</td>

<td>

<a class="delete"
href="deletePenalty?id=<%= rs.getInt("id") %>">

❌ Delete

</a>

</td>

</tr>

<%
}

}catch(Exception e){

e.printStackTrace();

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