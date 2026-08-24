<%@ page contentType="text/html;charset=UTF-8" %>

<%

String role =
(String) session.getAttribute("role");

String user =
(String) session.getAttribute("username");

if (user == null ||
!"security".equals(role)) {

    response.sendRedirect("index.jsp");
}

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Visitor Entry</title>

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
    linear-gradient(rgba(0,0,0,0.45),
    rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* MAIN */

.main{
    margin-left:0px;
    height:100vh;
    display:flex;
    flex-direction:column;
    transition:0.3s;
}

/* HEADER */

.header{
    height:70px;
    background:rgba(22,163,116,0.95);
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

/* CONTENT */

.container{
    flex:1;
    overflow-y:auto;
    padding:25px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
}

/* FORM BOX */

.form-box{
    width:100%;
    max-width:550px;
    background:rgba(255,255,255,0.97);
    padding:35px;
    border-radius:28px;
    box-shadow:0 10px 25px rgba(0,0,0,0.12);
    backdrop-filter:blur(6px);
}

/* TITLE */

.form-box h2{
    text-align:center;
    margin-bottom:28px;
    font-size:32px;
    color:#0f172a;
}

/* INPUT */

input,
select{
    width:100%;
    padding:14px;
    margin-bottom:16px;
    border-radius:14px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:15px;
    transition:0.3s;
}

input:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* BUTTON */

.submit-btn{
    width:100%;
    padding:14px;
    background:#16a085;
    color:white;
    border:none;
    border-radius:14px;
    cursor:pointer;
    font-size:16px;
    font-weight:600;
    transition:0.3s;
}

.submit-btn:hover{
    background:#13856b;
    transform:translateY(-2px);
}

/* BACK BUTTON */

.back-btn{
    display:block;
    width:100%;
    text-align:center;
    margin-top:14px;
    padding:14px;
    background:#2563eb;
    color:white;
    text-decoration:none;
    border-radius:14px;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    background:#1d4ed8;
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

    .sidebar.show{
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

    .container{
        padding:18px;
    }

    .form-box{
        padding:25px 20px;
        border-radius:22px;
    }

    .form-box h2{
        font-size:26px;
    }

    input,
    select{
        font-size:14px;
        padding:12px;
    }

    .submit-btn,
    .back-btn{
        font-size:14px;
    }

    .footer{
        font-size:12px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    .form-box h2{
        font-size:22px;
    }

    .sidebar h2{
        font-size:24px;
    }
}

</style>

</head>

<body>

<!-- MAIN -->

<div class="main">

<!-- HEADER -->

<div class="header">

<div class="menu-btn"
id="menuBtn">


</div>

<div>
Visitor Entry
</div>

<div>
Welcome
<b><%= user %></b>
</div>

</div>

<!-- CONTENT -->

<div class="container">

<div class="form-box">

<h2>🚪 Add Visitor</h2>

<form action="visitorEntry"
method="post">

<input type="text"
name="name"
placeholder="Visitor Name"
required>

<input type="text"
name="vehicleNo"
placeholder="Vehicle Number"
required>

<input type="text"
name="phone"
placeholder="Mobile Number"
maxlength="10"

oninput="this.value=this.value.replace(/[^0-9]/g,'')"
required>

<input type="text"
name="purpose"
placeholder="Purpose"
required>

<select name="flat_no" required>

<option value="">
Select Flat
</option>

<%

char[] wings =
{'A','B','C','D','E'};

for(char w : wings){

    for(int floor = 1;
    floor <= 7;
    floor++){

        for(int flat = 1;
        flat <= 4;
        flat++){

            String flatNo =
            w + "-" +
            floor + "0" +
            flat;

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

<button type="submit"
class="submit-btn">

Submit Visitor

</button>

</form>

<a href="securityDashboard.jsp"
class="back-btn">

⬅ Back to Dashboard

</a>

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

const menuBtn =
document.getElementById("menuBtn");

const sidebar =
document.querySelector(".sidebar");

menuBtn.onclick = () => {

if(window.innerWidth <= 768){

    sidebar.classList.toggle("show");

}else{

    sidebar.classList.toggle("hide");
}

};

</script>

</body>
</html>