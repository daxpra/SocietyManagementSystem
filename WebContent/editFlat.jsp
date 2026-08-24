<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Flat</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Segoe UI',sans-serif;
    background:#f1f5f9;
    overflow-x:hidden;
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
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
    linear-gradient(rgba(0,0,0,0.45),
    rgba(0,0,0,0.45)),

    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;

    filter:blur(2px);

    z-index:-1;
}

/* CARD */

.form-card{
    width:100%;
    max-width:500px;
    background:rgba(255,255,255,0.97);
    padding:35px;
    border-radius:24px;
    box-shadow:0 8px 25px rgba(0,0,0,0.12);
    backdrop-filter:blur(5px);
}

/* TITLE */

h2{
    text-align:center;
    margin-bottom:30px;
    font-size:32px;
    color:#0f172a;
}

/* FORM GROUP */

.form-group{
    margin-bottom:22px;
}

/* LABEL */

label{
    display:block;
    margin-bottom:8px;
    font-size:15px;
    font-weight:600;
    color:#334155;
}

/* INPUT + SELECT */

input,
select{
    width:100%;
    padding:14px;
    border-radius:14px;
    border:1px solid #cbd5e1;
    font-size:15px;
    outline:none;
    transition:0.3s;
}

input:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* READONLY */

input[readonly]{
    background:#f1f5f9;
    cursor:not-allowed;
}

/* BUTTON BOX */

.button-box{
    display:flex;
    gap:12px;
    margin-top:25px;
}

/* BUTTON */

.btn{
    flex:1;
    padding:14px;
    border:none;
    border-radius:14px;
    cursor:pointer;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
    text-decoration:none;
    text-align:center;
}

/* UPDATE BUTTON */

.update-btn{
    background:#16a34a;
    color:white;
}

.update-btn:hover{
    background:#15803d;
    transform:translateY(-2px);
}

/* BACK BUTTON */

.back-btn{
    background:#2563eb;
    color:white;
}

.back-btn:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
}

/* MOBILE */

@media(max-width:768px){

    .form-card{
        padding:25px 20px;
        border-radius:20px;
    }

    h2{
        font-size:26px;
    }

    .button-box{
        flex-direction:column;
    }

    .btn{
        width:100%;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    body{
        padding:15px;
    }

    h2{
        font-size:22px;
    }

    input,
    select{
        font-size:14px;
        padding:12px;
    }

    .btn{
        font-size:14px;
    }
}

</style>

</head>

<body>

<div class="form-card">

<h2>🏢 Edit Flat Details</h2>

<form action="updateFlat" method="post">

<!-- FLAT NO -->

<div class="form-group">

<label>Flat No</label>

<input type="text"
name="flat_no"
value="${flat_no}"
readonly />

</div>

<!-- WING -->

<input type="hidden"
name="wing"
value="${wing}">

<!-- NAME -->

<div class="form-group">

<label>Name</label>

<input type="text"
name="name"
value="${owner_name}"
required />

</div>

<!-- RESIDENT TYPE -->

<div class="form-group">

<label>Resident Type</label>

<select name="resident_type" required>

<option value="Owner">
Owner
</option>

<option value="Tenant">
Tenant
</option>

</select>

</div>

<!-- BUTTONS -->

<div class="button-box">

<button type="submit"
class="btn update-btn">

Update Flat

</button>

<a href="flatDetails"
class="btn back-btn">

⬅ Back

</a>

</div>

</form>

</div>

</body>
</html>