<%@ page import="java.sql.*,model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Penalty History</title>

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
    color:#1e293b;
    min-height:100vh;
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
    linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* MAIN CONTAINER */

.container{
    width:95%;
    max-width:1400px;
    margin:30px auto;
    background:rgba(255,255,255,0.96);
    padding:25px;
    border-radius:22px;
    box-shadow:0 8px 25px rgba(0,0,0,0.12);
    backdrop-filter:blur(4px);
}

/* TITLE */

.title{
    text-align:center;
    font-size:32px;
    margin-bottom:25px;
    color:#0f172a;
}

/* TABLE WRAPPER */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    border-radius:16px;
}

/* TABLE */

table{
    width:100%;
    min-width:800px;
    border-collapse:collapse;
    overflow:hidden;
    border-radius:16px;
}

/* HEADER */

th{
    background:#dbeafe;
    color:#0f172a;
    padding:15px 12px;
    font-size:15px;
    font-weight:600;
    border-bottom:1px solid #cbd5e1;
}

/* TABLE DATA */

td{
    padding:14px 12px;
    text-align:center;
    border-bottom:1px solid #e2e8f0;
    background:#ffffff;
    font-size:14px;
}

/* ROW HOVER */

tr:hover td{
    background:#f8fafc;
}

/* IMAGE */

.penalty-img{
    width:60px;
    height:60px;
    object-fit:cover;
    border-radius:10px;
    border:2px solid #e2e8f0;
}

/* DELETE BUTTON */

.delete-btn{
    text-decoration:none;
    background:#ef4444;
    color:white;
    padding:8px 12px;
    border-radius:10px;
    font-size:14px;
    transition:0.3s;
    display:inline-block;
}

.delete-btn:hover{
    background:#dc2626;
    transform:scale(1.05);
}

/* BACK BUTTON */

.back-box{
    text-align:center;
    margin-top:25px;
}

.back-btn{
    display:inline-block;
    text-decoration:none;
    background:#2563eb;
    color:white;
    padding:12px 22px;
    border-radius:12px;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
}

/* NO IMAGE */

.no-photo{
    font-size:22px;
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
    border-top:2px solid #000;
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

    .title{
        font-size:28px;
    }

    th,td{
        font-size:13px;
        padding:12px 10px;
    }

    .penalty-img{
        width:55px;
        height:55px;
    }
}

/* MOBILE */

@media(max-width:768px){

    .container{
        width:95%;
        padding:18px;
        margin:20px auto;
        border-radius:18px;
    }

    .title{
        font-size:24px;
    }

    table{
        min-width:700px;
    }

    th,td{
        font-size:12px;
        padding:10px 8px;
    }

    .penalty-img{
        width:50px;
        height:50px;
    }

    .delete-btn{
        font-size:12px;
        padding:7px 10px;
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

    .title{
        font-size:22px;
    }

    .container{
        padding:15px;
    }

    .footer{
        font-size:11px;
    }
}

</style>

</head>

<body>

<div class="container">

    <h2 class="title">⚠️ Penalty History</h2>

    <div class="table-wrapper">

        <table>

            <tr>
                <th>Start Date</th>
                <th>Type</th>
                <th>Charge</th>
                <th>Photo</th>
                <th>Delete</th>
            </tr>

<%
try{

    Connection con = DBConnection.getConnection();

    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT * FROM penalty");

    while(rs.next()){

%>

            <tr>

                <td><%= rs.getDate("start_date") %></td>

                <td><%= rs.getString("type") %></td>

                <td>₹<%= rs.getInt("charge") %></td>

                <td>

<%
if(rs.getString("photo") != null &&
   !rs.getString("photo").equals("")){
%>

                    <img
                    class="penalty-img"
                    src="uploads/<%= rs.getString("photo") %>">

<%
}else{
%>

                    <span class="no-photo">📷</span>

<%
}
%>

                </td>

                <td>

                    <a class="delete-btn"
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

    <!-- BACK BUTTON -->

    <div class="back-box">

        <a href="adminDashboard" class="back-btn">
            ⬅ Back to Dashboard
        </a>

    </div>

</div>

<!-- FOOTER -->

<div class="footer">

    The Bharat Solutions, 224, Samruddhi Business Hub,
    Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat - 382330.

    <br>

    Contact no: +91-95865 05037

    &nbsp; | &nbsp;

    Visit:
    <a href="https://thebharatsolutions.com" target="_blank">
        Thebharatsolutions.com
    </a>

</div>

</body>
</html>