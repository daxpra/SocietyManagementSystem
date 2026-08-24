<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String role = (String) session.getAttribute("role");
String user = (String) session.getAttribute("username");

if (user == null || !"admin".equals(role)) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

html,body{
    height:100%;
    overflow:hidden;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#0f172a;
    color:white;
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
    rgba(15,23,42,0.78),
    rgba(15,23,42,0.85)
    ),

    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;

    z-index:-1;
}

/* SIDEBAR */

.sidebar{
    position:fixed;
    top:0;
    left:0;
    width:210px;
    height:100vh;
    background:rgba(15,23,42,0.96);
    backdrop-filter:blur(15px);
    overflow-y:auto;
    transition:0.3s;
    z-index:1000;
}

.sidebar h2{
    text-align:center;
    padding:18px 10px;
    font-size:24px;
}

.sidebar a{
    display:flex;
    align-items:center;
    gap:10px;
    text-decoration:none;
    color:#e2e8f0;
    padding:11px 16px;
    margin:6px 10px;
    border-radius:12px;
    transition:0.3s;
    font-size:15px;
    font-weight:500;
}

.sidebar a:hover{
    background:linear-gradient(135deg,#2563eb,#7c3aed);
    transform:translateX(5px);
}

/* MAIN */

.main{
    margin-left:210px;
    height:100vh;
    overflow:hidden;
}

/* TOPBAR */

.topbar{
    height:68px;
    background:#2563eb;
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:0 20px;
    position:sticky;
    top:0;
    z-index:500;
    box-shadow:0 5px 20px rgba(0,0,0,0.25);
}

.left-top{
    display:flex;
    align-items:center;
    gap:15px;
}

.menu-toggle{
    font-size:28px;
    cursor:pointer;
    display:none;
}

.topbar h1{
    font-size:24px;
}

.welcome{
    font-size:16px;
}

/* DASHBOARD */

.dashboard{
    padding:15px;
}

/* CARDS */

.cards{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:14px;
}

.card{
    position:relative;
    overflow:hidden;
    border-radius:20px;
    padding:18px;
    min-height:120px;
    color:white;
    transition:0.35s;
    box-shadow:0 8px 20px rgba(0,0,0,0.25);
}

.card::before{
    content:"";
    position:absolute;
    width:120px;
    height:120px;
    border-radius:50%;
    background:rgba(255,255,255,0.10);
    top:-45px;
    right:-35px;
}

.card:hover{
    transform:translateY(-5px);
}

.card:nth-child(1){background:linear-gradient(135deg,#2563eb,#60a5fa);}
.card:nth-child(2){background:linear-gradient(135deg,#16a34a,#4ade80);}
.card:nth-child(3){background:linear-gradient(135deg,#7c3aed,#c084fc);}
.card:nth-child(4){background:linear-gradient(135deg,#ea580c,#fb923c);}
.card:nth-child(5){background:linear-gradient(135deg,#dc2626,#f87171);}
.card:nth-child(6){background:linear-gradient(135deg,#0891b2,#22d3ee);}
.card:nth-child(7){background:linear-gradient(135deg,#2563eb,#818cf8);}
.card:nth-child(8){background:linear-gradient(135deg,#0f766e,#2dd4bf);}

.card-title{
    font-size:15px;
    margin-bottom:14px;
    font-weight:600;
}

.card h2{
    font-size:34px;
    font-weight:800;
}

/* CHART */

.chart-container{
    margin-top:18px;
    background:rgba(255,255,255,0.08);
    backdrop-filter:blur(12px);
    border-radius:20px;
    padding:16px;
}

.chart-box{
    position:relative;
    width:100%;
    height:220px;
}

/* FOOTER */

.footer{
    text-align:center;
    padding:10px;
    color:#cbd5e1;
    font-size:13px;
}

/* MOBILE */

@media(max-width:1200px){

    .cards{
        grid-template-columns:repeat(2,1fr);
    }
}

@media(max-width:768px){

    html,body{
        overflow:auto;
    }

    .sidebar{
        left:-210px;
    }

    .sidebar.active{
        left:0;
    }

    .main{
        margin-left:0;
        overflow:auto;
    }

    .menu-toggle{
        display:block;
    }

    .topbar{
        padding:0 15px;
    }

    .topbar h1{
        font-size:20px;
    }

    .welcome{
        font-size:14px;
    }

    .cards{
        grid-template-columns:1fr;
    }

    .card{
        min-height:110px;
    }

    .card h2{
        font-size:28px;
    }

    .chart-box{
        height:260px;
    }
}

</style>

</head>

<body>

<!-- SIDEBAR -->

<div class="sidebar" id="sidebar">

    <h2>🏢 Society</h2>

    <a href="adminDashboard">🏠 Dashboard</a>
    <a href="viewMembers">👥 Members</a>
    <a href="history.jsp">📜 History</a>
    <a href="addmember.jsp">🧍 Add Member</a>
    <a href="viewPayments">🧾 Maintenance</a>
    <a href="penalty.jsp">🏴 Penalty</a>
    <a href="viewPayments.jsp">➕ Income</a>
    <a href="viewExpense.jsp">➖ Expense</a>
    <a href="manageNotifications.jsp">📢 Notifications</a>
    <a href="flatDetails">🏢 Flat Details</a>
    <a href="Logout">🚪 Logout</a>

</div>

<!-- MAIN -->

<div class="main">

    <!-- TOPBAR -->

    <div class="topbar">

        <div class="left-top">

            <div class="menu-toggle"
            onclick="toggleSidebar()">

                ☰

            </div>

            <h1>Admin Panel</h1>

        </div>

        <div class="welcome">

            Welcome <b><%=user%></b>

        </div>

    </div>

    <!-- DASHBOARD -->

    <div class="dashboard">

        <div class="cards">

            <div class="card">
                <div class="card-title">
                    💰 Current Balance
                </div>

                <h2>₹${balance}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📥 Maintenance Income
                </div>

                <h2>₹${maintenance}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📦 Other Income
                </div>

                <h2>₹${otherIncome}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    ⏳ Pending Amount
                </div>

                <h2>₹${pendingAmount}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📅 Expense This Year
                </div>

                <h2>₹${expenseThisYear}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📆 Expense Last Year
                </div>

                <h2>₹${expenseLastYear}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📅 Income This Year
                </div>

                <h2>₹${incomeThisYear}</h2>
            </div>

            <div class="card">
                <div class="card-title">
                    📆 Income Last Year
                </div>

                <h2>₹${incomeLastYear}</h2>
            </div>

        </div>

        <!-- CHART -->

        <div class="chart-container">

            <h2 style="margin-bottom:12px;">
                📊 Financial Report
            </h2>

            <div class="chart-box">

                <canvas id="paymentChart"></canvas>

            </div>

        </div>

    </div>

    <!-- FOOTER -->

    <div class="footer">

        The Bharat Solutions, Ahmedabad

    </div>

</div>

<script>

function toggleSidebar(){

    document.getElementById("sidebar")
    .classList.toggle("active");
}

new Chart(document.getElementById('paymentChart'), {

    type:'bar',

    data:{

        labels:[
            'Income',
            'Expense',
            'Balance'
        ],

        datasets:[{

            label:'Financial Report',

            data:[
                ${maintenance},
                ${expenseThisYear},
                ${balance}
            ],

            backgroundColor:[
                '#60a5fa',
                '#f87171',
                '#4ade80'
            ]
        }]
    },

    options:{

        responsive:true,
        maintainAspectRatio:false
    }

});

</script>

</body>
</html>