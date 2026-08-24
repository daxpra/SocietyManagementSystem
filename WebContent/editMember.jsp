<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Flat Details</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Poppins',sans-serif;
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:20px;
    overflow:hidden;
    position:relative;
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
    linear-gradient(rgba(15,23,42,0.75),
    rgba(15,23,42,0.82)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    z-index:-2;
}

/* BLUR */

body::after{
    content:"";
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    backdrop-filter:blur(4px);
    z-index:-1;
}

/* CONTAINER */

.container{
    width:100%;
    max-width:520px;
    background:rgba(255,255,255,0.12);
    backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.12);
    padding:35px;
    border-radius:28px;
    box-shadow:0 10px 35px rgba(0,0,0,0.35);
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

/* BACK BUTTON */

.back{
    display:inline-block;
    text-decoration:none;
    color:white;
    background:rgba(255,255,255,0.12);
    padding:10px 18px;
    border-radius:14px;
    margin-bottom:25px;
    transition:0.3s;
    font-size:14px;
    font-weight:500;
}

.back:hover{
    background:#2563eb;
    transform:translateX(-3px);
}

/* TITLE */

h2{
    text-align:center;
    margin-bottom:30px;
    font-size:32px;
    font-weight:700;
    color:white;
}

/* LABEL */

.label{
    margin-bottom:8px;
    display:block;
    font-size:15px;
    font-weight:500;
    color:#e2e8f0;
}

/* INPUT */

input{
    width:100%;
    padding:14px;
    border:none;
    outline:none;
    border-radius:16px;
    margin-bottom:22px;
    font-size:15px;
    background:rgba(255,255,255,0.12);
    color:white;
    border:1px solid rgba(255,255,255,0.10);
    transition:0.3s;
}

input::placeholder{
    color:#cbd5e1;
}

input:focus{
    border-color:#60a5fa;
    box-shadow:0 0 0 4px rgba(96,165,250,0.18);
    background:rgba(255,255,255,0.16);
}

/* READONLY */

input[readonly]{
    opacity:0.8;
    cursor:not-allowed;
}

/* BUTTON */

button{
    width:100%;
    padding:15px;
    border:none;
    border-radius:18px;
    background:linear-gradient(135deg,#2563eb,#7c3aed);
    color:white;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:0.35s;
    box-shadow:0 10px 20px rgba(37,99,235,0.35);
}

button:hover{
    transform:translateY(-3px);
    box-shadow:0 14px 28px rgba(37,99,235,0.45);
}

/* FOOTER */

.footer{
    position:fixed;
    bottom:0;
    left:0;
    width:100%;
    background:rgba(15,23,42,0.92);
    backdrop-filter:blur(10px);
    color:#e2e8f0;
    text-align:center;
    padding:12px;
    font-size:13px;
    line-height:22px;
    border-top:1px solid rgba(255,255,255,0.08);
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

    .container{
        padding:28px 24px;
        border-radius:24px;
    }

    h2{
        font-size:26px;
    }

    input{
        padding:13px;
    }

    button{
        padding:14px;
    }
}

/* MOBILE */

@media(max-width:480px){

    body{
        padding:15px;
        overflow:auto;
    }

    .container{
        padding:24px 18px;
        border-radius:22px;
    }

    h2{
        font-size:22px;
    }

    .back{
        width:100%;
        text-align:center;
    }

    input{
        font-size:14px;
    }

    button{
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

<a href="viewMembers" class="back">

⬅ Back

</a>

<h2>

🏢 Edit Flat Details

</h2>

<form action="updateMember" method="post">

<!-- FLAT NO -->

<label class="label">

Flat No

</label>

<input type="text"
name="flat_no"
value="${flat_no}"
readonly>

<!-- OWNER -->

<label class="label">

Owner Name

</label>

<input type="text"
name="owner"
value="${owner}"
placeholder="Enter owner name">

<!-- TENANT -->

<label class="label">

Tenant Name

</label>

<input type="text"
name="tenant"
value="${tenant}"
placeholder="Enter tenant name">

<!-- BUTTON -->

<button type="submit">

Update Details

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