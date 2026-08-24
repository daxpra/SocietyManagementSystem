<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Files</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#f1f5f9;
    min-height:100vh;
    display:flex;
    flex-direction:column;
    overflow-x:hidden;
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

/* MAIN CONTAINER */

.container{
    flex:1;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:20px;
}

/* BOX */

.box{
    width:100%;
    max-width:500px;
    background:#ffffff;
    padding:40px 30px;
    border-radius:22px;
    text-align:center;
    box-shadow:0 8px 25px rgba(0,0,0,0.08);
    transition:0.3s;
}

.box:hover{
    transform:translateY(-4px);
}

.box h2{
    font-size:32px;
    margin-bottom:18px;
    color:#0f172a;
}

.box p{
    font-size:16px;
    color:#475569;
    line-height:28px;
    margin-bottom:30px;
}

/* BUTTON */

.btn{
    display:inline-block;
    text-decoration:none;
    background:#2563eb;
    color:white;
    padding:12px 24px;
    border-radius:12px;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.btn:hover{
    background:#1d4ed8;
    transform:scale(1.03);
}

/* FOOTER */

.footer{
    width:100%;
    background:#0f172a;
    color:#ffffff;
    text-align:center;
    padding:14px 18px;
    font-size:13px;
    line-height:24px;
    border-top:2px solid #1e293b;
}

.footer a{
    color:#38bdf8;
    text-decoration:none;
    font-weight:500;
}

.footer a:hover{
    text-decoration:underline;
}

/* TABLET */

@media(max-width:768px){

    .box{
        padding:35px 22px;
    }

    .box h2{
        font-size:26px;
    }

    .box p{
        font-size:15px;
        line-height:26px;
    }

    .btn{
        width:100%;
        padding:12px;
    }

    .footer{
        font-size:12px;
        line-height:22px;
    }
}

/* MOBILE */

@media(max-width:480px){

    .container{
        padding:15px;
    }

    .box{
        padding:30px 18px;
        border-radius:18px;
    }

    .box h2{
        font-size:22px;
    }

    .box p{
        font-size:14px;
    }

    .btn{
        font-size:14px;
    }
}

</style>

</head>

<body>

<div class="container">

    <div class="box">

        <h2>📂 Files Page</h2>

        <p>
            Here you will see all uploaded society documents,
            files, reports and important records.
        </p>

        <a href="adminDashboard" class="btn">
            ⬅ Back to Dashboard
        </a>

    </div>

</div>

<!-- FOOTER -->

<div class="footer">

    The Bharat Solutions, 224, Samruddhi Business Hub,
    Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat - 382330.

    <br>

    Contact: +91-95865 05037

    &nbsp; | &nbsp;

    Visit:
    <a href="https://thebharatsolutions.com" target="_blank">
        Thebharatsolutions.com
    </a>

</div>

</body>
</html>