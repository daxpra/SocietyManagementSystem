<%@ page contentType="text/html;charset=UTF-8" %>

<%

String error =
(String) request.getAttribute("error");

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Login</title>

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
}

/* BACKGROUND */

body::before{
    content:"";
    position:absolute;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:
    linear-gradient(rgba(0,0,0,0.55),
    rgba(0,0,0,0.55)),
    url("images/background.png")
    no-repeat center center/cover;
    z-index:-2;
}

/* BLUR EFFECT */

body::after{
    content:"";
    position:absolute;
    top:0;
    left:0;
    width:100%;
    height:100%;
    backdrop-filter:blur(2px);
    z-index:-1;
}

/* LOGIN CARD */

.login-box{
    width:100%;
    max-width:420px;
    background:rgba(255,255,255,0.96);
    padding:40px 30px;
    border-radius:26px;
    text-align:center;
    box-shadow:0 10px 30px rgba(0,0,0,0.18);
    backdrop-filter:blur(6px);
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

/* LOGO */

.logo{
    width:90px;
    margin-bottom:15px;
}

/* TITLE */

.login-box h2{
    font-size:34px;
    margin-bottom:25px;
    color:#0f172a;
}

/* ERROR */

.error{
    background:#fee2e2;
    color:#dc2626;
    padding:12px;
    border-radius:12px;
    margin-bottom:18px;
    font-size:14px;
}

/* INPUT GROUP */

.input-group{
    position:relative;
    margin-bottom:18px;
}

/* INPUT */

.input-group input{
    width:100%;
    padding:14px;
    border-radius:14px;
    border:1px solid #cbd5e1;
    outline:none;
    font-size:15px;
    transition:0.3s;
    background:#f8fafc;
}

.input-group input:focus{
    border-color:#2563eb;
    background:white;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* BUTTON */

.login-btn{
    width:100%;
    padding:14px;
    background:#2563eb;
    color:white;
    border:none;
    border-radius:14px;
    cursor:pointer;
    font-size:16px;
    font-weight:600;
    transition:0.3s;
}

.login-btn:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
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

/* TABLET */

@media(max-width:768px){

    .login-box{
        padding:30px 22px;
        border-radius:22px;
    }

    .login-box h2{
        font-size:28px;
    }

    .footer{
        font-size:12px;
        line-height:20px;
    }
}

/* MOBILE */

@media(max-width:480px){

    body{
        padding:15px;
    }

    .login-box{
        padding:25px 18px;
    }

    .login-box h2{
        font-size:24px;
    }

    .input-group input{
        padding:12px;
        font-size:14px;
    }

    .login-btn{
        font-size:15px;
        padding:12px;
    }

    .footer{
        font-size:11px;
        padding:10px;
    }
}

</style>

</head>

<body>

<!-- LOGIN BOX -->

<div class="login-box">

    <h2>🔐 Login</h2>

<%

if(error != null){

%>

    <div class="error">

        <%= error %>

    </div>

<%
}
%>

    <form action="loginServlet"
    method="post">

        <!-- USERNAME -->

        <div class="input-group">

            <input type="text"
            name="username"
            placeholder="Enter Username"
            required>

        </div>

        <!-- PASSWORD -->

        <div class="input-group">

            <input type="password"
            name="password"
            placeholder="Enter Password"
            required>

        </div>

        <!-- BUTTON -->

        <button type="submit"
        class="login-btn">

        Login

        </button>

    </form>

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