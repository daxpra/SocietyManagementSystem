<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Sahitya Hills</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    overflow:hidden;
    position:relative;
    font-family:'Segoe UI',sans-serif;
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

/* MAIN BOX */

.box{
    width:100%;
    max-width:500px;
    background:rgba(255,255,255,0.15);
    backdrop-filter:blur(12px);
    padding:50px 35px;
    border-radius:28px;
    text-align:center;
    box-shadow:0 10px 35px rgba(0,0,0,0.25);
    animation:fadeIn 0.6s ease;
    border:1px solid rgba(255,255,255,0.2);
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

.box h1{
    color:white;
    font-size:48px;
    margin-bottom:18px;
    font-weight:700;
    letter-spacing:1px;
}

/* SUBTITLE */

.subtitle{
    color:#e2e8f0;
    font-size:17px;
    margin-bottom:35px;
    line-height:28px;
}

/* BUTTON */

.login-btn{
    padding:15px 38px;
    font-size:17px;
    font-weight:600;
    background:#2563eb;
    color:white;
    border:none;
    border-radius:14px;
    cursor:pointer;
    transition:0.3s;
    box-shadow:0 6px 15px rgba(37,99,235,0.35);
}

.login-btn:hover{
    background:#1d4ed8;
    transform:translateY(-3px) scale(1.02);
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

    .box{
        padding:40px 25px;
        border-radius:22px;
    }

    .box h1{
        font-size:38px;
    }

    .subtitle{
        font-size:15px;
        line-height:25px;
    }

    .login-btn{
        width:100%;
        padding:14px;
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

    .box{
        padding:32px 20px;
    }

    .box h1{
        font-size:30px;
    }

    .subtitle{
        font-size:14px;
    }

    .login-btn{
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

<!-- MAIN BOX -->

<div class="box">

    <h1>🏢 Sahitya Hills</h1>

    <p class="subtitle">

        Smart Society Management System

        <br>

        Manage Flats, Members, Payments,
        Notifications & Security Easily

    </p>

    <button class="login-btn"
    onclick="location.href='login.jsp'">

    Login

    </button>

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