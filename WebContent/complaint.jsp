<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Submit Complaint</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    overflow:hidden;
    position:relative;
    padding:20px;
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
    linear-gradient(rgba(0,0,0,0.50),
    rgba(0,0,0,0.50)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* CONTAINER */

.container{
    width:100%;
    max-width:520px;
    background:rgba(255,255,255,0.95);
    backdrop-filter:blur(8px);
    padding:35px;
    border-radius:28px;
    box-shadow:0 10px 30px rgba(0,0,0,0.18);
    animation:fadeIn 0.5s ease;
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
    text-align:center;
    margin-bottom:25px;
    font-size:32px;
    color:#0f172a;
}

/* SUCCESS MESSAGE */

.success-msg{
    background:#dcfce7;
    color:#15803d;
    padding:14px;
    border-radius:14px;
    margin-bottom:18px;
    text-align:center;
    font-weight:600;
}

/* INPUT */

input,
textarea{
    width:100%;
    padding:14px;
    margin-bottom:18px;
    border-radius:14px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:15px;
    transition:0.3s;
    background:#f8fafc;
}

input:focus,
textarea:focus{
    border-color:#2563eb;
    background:white;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* TEXTAREA */

textarea{
    min-height:140px;
    resize:none;
}

/* BUTTON */

.submit-btn{
    width:100%;
    padding:14px;
    background:linear-gradient(135deg,#2563eb,#4f46e5);
    color:white;
    border:none;
    border-radius:14px;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:0.3s;
}

.submit-btn:hover{
    transform:translateY(-2px);
    opacity:0.95;
}

/* BACK BUTTON */

.back-btn{
    display:inline-block;
    margin-bottom:20px;
    text-decoration:none;
    background:#0f172a;
    color:white;
    padding:12px 18px;
    border-radius:14px;
    font-size:14px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    background:#1e293b;
}

/* FOOTER */

.footer{
    position:fixed;
    bottom:0;
    left:0;
    width:100%;
    background:#0f172a;
    color:white;
    text-align:center;
    padding:12px 18px;
    font-size:13px;
    line-height:22px;
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

    .container{
        padding:28px 22px;
        border-radius:22px;
    }

    h2{
        font-size:26px;
    }

    .footer{
        font-size:12px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    body{
        padding:15px;
    }

    .container{
        padding:24px 18px;
    }

    h2{
        font-size:22px;
    }

    input,
    textarea{
        padding:12px;
        font-size:14px;
    }

    .submit-btn{
        font-size:15px;
    }

    .footer{
        font-size:11px;
        padding:10px;
    }
}

</style>

</head>

<body>

<div class="container">

<%

String role =
(String) session.getAttribute("role");

String dashboard =
"index.jsp";

if("admin".equals(role)){

    dashboard =
    "adminDashboard";

}else if(
"security".equals(role)
){

    dashboard =
    "securityDashboard";

}else if(
"user".equals(role)
){

    dashboard =
    "userDashboard.jsp";
}

%>

<%

String success =
request.getParameter("success");

if(success != null){

%>

<div class="success-msg">

✅ Complaint submitted successfully!

</div>

<%
}
%>

<!-- BACK BUTTON -->

<a href="userDashboard.jsp">
            <button class="back-btn">⬅ Back Dashboard</button>
        </a>


<!-- TITLE -->

<h2>

📝 Submit Complaint

</h2>

<!-- FORM -->

<form action="ComplaintServlet"
method="post">

<input type="text"
name="name"
placeholder="Enter your name"
required>

<textarea
name="message"
placeholder="Write your complaint..."
required></textarea>

<button type="submit"
class="submit-btn">

Submit Complaint

</button>

</form>

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