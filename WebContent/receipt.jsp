<%@ page import="java.sql.*,model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String flatNo = request.getParameter("flat_no");

int amount = 0;
String status = "";

try {

    Connection con =
        DBConnection.getConnection();

    PreparedStatement ps =
        con.prepareStatement(
            "SELECT * FROM maintenance WHERE flat_no=? ORDER BY id DESC LIMIT 1"
        );

    ps.setString(1, flatNo);

    ResultSet rs =
        ps.executeQuery();

    if(rs.next()){

        amount =
            rs.getInt("amount");

        status =
            rs.getString("status");
    }

} catch(Exception e){

    e.printStackTrace();
}
%>

<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Payment Receipt</title>

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
    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;
    overflow-x:hidden;
    padding:20px;
    position:relative;
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
    rgba(0,0,0,0.55),
    rgba(0,0,0,0.55)),

    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;

    filter:blur(3px);

    z-index:-1;
}

/* CARD */

.card{

    width:100%;
    max-width:500px;

    background:
    rgba(255,255,255,0.96);

    padding:35px 30px;

    border-radius:22px;

    box-shadow:
    0 10px 30px rgba(0,0,0,0.25);

    text-align:center;

    backdrop-filter:blur(5px);

    animation:fadeIn 0.4s ease;
}

/* ANIMATION */

@keyframes fadeIn{

    from{
        opacity:0;
        transform:translateY(20px);
    }

    to{
        opacity:1;
        transform:translateY(0);
    }
}

/* TITLE */

h2{

    color:#0f172a;

    margin-bottom:25px;

    font-size:32px;
}

/* RECEIPT DETAILS */

.receipt-box{

    background:#f8fafc;

    border-radius:16px;

    padding:22px;

    margin-bottom:25px;

    border:1px solid #dbeafe;
}

.receipt-box p{

    display:flex;

    justify-content:space-between;

    align-items:center;

    padding:12px 0;

    border-bottom:1px solid #e2e8f0;

    font-size:17px;

    color:#1e293b;
}

.receipt-box p:last-child{

    border-bottom:none;
}

.receipt-box span{

    font-weight:600;
    color:#0f172a;
}

/* BUTTON AREA */

.btn-group{

    display:flex;
    gap:15px;
    justify-content:center;
    flex-wrap:wrap;
}

/* BUTTON */

.btn{

    border:none;

    padding:14px 24px;

    border-radius:12px;

    font-size:15px;

    font-weight:600;

    cursor:pointer;

    transition:0.3s;

    min-width:150px;
}

/* PRINT */

.print{

    background:#16a34a;
    color:white;
}

.print:hover{

    background:#15803d;

    transform:translateY(-2px);
}

/* BACK */

.back{

    background:#2563eb;
    color:white;
}

.back:hover{

    background:#1d4ed8;

    transform:translateY(-2px);
}

/* FOOTER */

.footer{

    width:100%;

    margin-top:30px;

    background:#0f172a;

    color:white;

    text-align:center;

    padding:14px;

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

@media(max-width:768px){

    .card{

        padding:28px 22px;
    }

    h2{

        font-size:28px;
    }

    .receipt-box p{

        font-size:15px;
    }

    .btn{

        width:100%;
    }

    .btn-group{

        flex-direction:column;
    }
}

/* MOBILE */

@media(max-width:480px){

    body{

        padding:15px;
    }

    .card{

        padding:24px 18px;

        border-radius:18px;
    }

    h2{

        font-size:24px;
    }

    .receipt-box{

        padding:18px;
    }

    .receipt-box p{

        flex-direction:column;

        align-items:flex-start;

        gap:5px;

        font-size:14px;
    }

    .footer{

        font-size:12px;

        line-height:22px;
    }
}

/* PRINT */

@media print{

    .btn-group,
    .footer{

        display:none;
    }

    body{

        background:white;
    }

    body::before{

        display:none;
    }

    .card{

        box-shadow:none;

        border:1px solid #ddd;
    }
}

</style>

<script>

function printPage(){

    window.print();
}

</script>

</head>

<body>

<div class="card">

<h2>🧾 Payment Receipt</h2>

<div class="receipt-box">

<p>
Flat No :
<span><%= flatNo %></span>
</p>

<p>
Amount :
<span>₹<%= amount %></span>
</p>

<p>
Status :
<span><%= status %></span>
</p>

<p>
Date :
<span><%= new java.util.Date() %></span>
</p>

</div>

<div class="btn-group">

<button class="btn print"
onclick="printPage()">

🖨 Print Receipt

</button>

<a href="adminDashboard">

<button class="btn back">

⬅ Back Dashboard

</button>

</a>

</div>

</div>

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