<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Society Management</title>

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
    min-height:100vh;
    display:flex;
    flex-direction:column;
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
    linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.45)),
    url("<%=request.getContextPath()%>/images/background.png")
    no-repeat center center/cover;
    filter:blur(2px);
    z-index:-1;
}

/* CONTAINER */

.container{
    width:95%;
    max-width:1400px;
    margin:25px auto;
    background:rgba(255,255,255,0.97);
    padding:28px;
    border-radius:24px;
    box-shadow:0 8px 25px rgba(0,0,0,0.12);
    backdrop-filter:blur(5px);
}

/* TITLE */

h2{
    text-align:center;
    margin-bottom:25px;
    font-size:34px;
    color:#0f172a;
}

/* BACK BUTTON */

.back-btn{
    display:inline-block;
    text-decoration:none;
    margin-bottom:20px;
}

.back-btn button{
    background:#2563eb;
    color:white;
    border:none;
    padding:10px 20px;
    border-radius:12px;
    cursor:pointer;
    font-size:15px;
    transition:0.3s;
}

.back-btn button:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
}

/* TABS */

.tabs{
    text-align:center;
    margin-bottom:30px;
}

.tabs button{
    padding:12px 28px;
    border:none;
    border-radius:30px;
    margin:5px;
    background:#dbe4f0;
    cursor:pointer;
    font-size:15px;
    font-weight:600;
    transition:0.3s;
}

.tabs button:hover{
    transform:translateY(-2px);
}

.tabs .active{
    background:#2563eb;
    color:white;
}

/* FORM CONTAINER */

.form-container{
    display:flex;
    gap:30px;
    flex-wrap:wrap;
}

/* LEFT RIGHT */

.left,
.right{
    flex:1;
    min-width:320px;
}

/* INPUTS */

input,
select{
    width:100%;
    padding:12px 14px;
    margin:10px 0;
    border-radius:12px;
    border:1px solid #cbd5e1;
    font-size:14px;
    outline:none;
    transition:0.3s;
}

input:focus,
select:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 3px rgba(37,99,235,0.15);
}

/* LABEL */

label{
    font-size:14px;
    font-weight:600;
    color:#334155;
}

/* VEHICLE CONTAINER */

#vehicleContainer div,
#tenantVehicleContainer div{
    display:flex;
    gap:10px;
    margin-top:10px;
}

/* PLUS BUTTON */

.add-btn{
    width:50px;
    border:none;
    background:#16a34a;
    color:white;
    border-radius:10px;
    cursor:pointer;
    font-size:18px;
    transition:0.3s;
}

.add-btn:hover{
    background:#15803d;
}

/* REMOVE BUTTON */

.remove-btn{
    width:50px;
    border:none;
    background:#ef4444;
    color:white;
    border-radius:10px;
    cursor:pointer;
    font-size:18px;
}

/* UPLOAD BOX */

.upload-box{
    border:2px dashed #94a3b8;
    padding:18px;
    margin-bottom:18px;
    border-radius:16px;
    text-align:center;
    background:#f8fafc;
    transition:0.3s;
}

.upload-box:hover{
    border-color:#2563eb;
    background:#eff6ff;
}

.upload-box input{
    border:none;
    margin-top:10px;
    background:none;
}

/* OWNER AUTO BOX */

.owner-info{
    border:1px solid #cbd5e1;
    padding:15px;
    border-radius:14px;
    margin-bottom:18px;
    background:#f8fafc;
}

/* SUBMIT BUTTON */

.submit{
    display:block;
    margin:30px auto 0;
    padding:14px 40px;
    background:#2563eb;
    color:white;
    border:none;
    border-radius:14px;
    font-size:16px;
    cursor:pointer;
    transition:0.3s;
    font-weight:600;
}

.submit:hover{
    background:#1d4ed8;
    transform:translateY(-2px);
}

/* FOOTER */

.footer{
    margin-top:auto;
    width:100%;
    background:#0f172a;
    color:#fff;
    text-align:center;
    padding:14px 18px;
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

@media(max-width:992px){

    h2{
        font-size:28px;
    }

    .container{
        padding:22px;
    }
}

/* MOBILE */

@media(max-width:768px){

    .container{
        width:95%;
        padding:18px;
        border-radius:18px;
    }

    h2{
        font-size:24px;
    }

    .form-container{
        flex-direction:column;
        gap:20px;
    }

    .left,
    .right{
        width:100%;
        min-width:100%;
    }

    .tabs button{
        width:100%;
        margin:6px 0;
    }

    #vehicleContainer div,
    #tenantVehicleContainer div{
        flex-direction:column;
    }

    .add-btn,
    .remove-btn{
        width:100%;
        height:42px;
    }

    .submit{
        width:100%;
    }

    .footer{
        font-size:12px;
        line-height:22px;
    }
}

/* SMALL MOBILE */

@media(max-width:480px){

    h2{
        font-size:21px;
    }

    input,
    select{
        font-size:13px;
    }

    .submit{
        font-size:15px;
    }
}

</style>

<script>

function showForm(type){

    document.getElementById("ownerForm").style.display =
    (type=="owner") ? "block":"none";

    document.getElementById("tenantForm").style.display =
    (type=="tenant") ? "block":"none";

    document.getElementById("ownerBtn").classList.remove("active");
    document.getElementById("tenantBtn").classList.remove("active");

    document.getElementById(type+"Btn").classList.add("active");
}

window.onload = function(){
    showForm('owner');
}

/* OWNER VEHICLE */

function addVehicle(){

    let container =
    document.getElementById("vehicleContainer");

    let div = document.createElement("div");

    div.innerHTML = `
        <input type="text"
        name="vehicle"
        placeholder="Vehicle No">

        <button type="button"
        class="remove-btn"
        onclick="this.parentElement.remove()">
        -
        </button>
    `;

    container.appendChild(div);
}

/* TENANT VEHICLE */

function addTenantVehicle(){

    let container =
    document.getElementById("tenantVehicleContainer");

    let div = document.createElement("div");

    div.innerHTML = `
        <input type="text"
        name="tenantVehicle"
        placeholder="Vehicle No">

        <button type="button"
        class="remove-btn"
        onclick="this.parentElement.remove()">
        -
        </button>
    `;

    container.appendChild(div);
}

</script>

</head>

<body>

<div class="container">

<h2>🏢 Society Management System</h2>

<a href="adminDashboard" class="back-btn">
    <button type="button">⬅ Back to Dashboard</button>
</a>

<!-- TABS -->

<div class="tabs">

    <button id="ownerBtn"
    onclick="showForm('owner')">
    Owner
    </button>

    <button id="tenantBtn"
    onclick="showForm('tenant')">
    Tenant
    </button>

</div>

<!-- OWNER FORM -->

<form id="ownerForm"
action="AddMemberServlet"
method="post"
enctype="multipart/form-data">

<div class="form-container">

<div class="left">

<select name="block" required>

<option value="">Select Block</option>
<option>A</option>
<option>B</option>
<option>C</option>
<option>D</option>
<option>E</option>

</select>

<input type="text"
name="flat_no"
placeholder="House No"
required>

<input type="text"
name="name"
placeholder="Owner Name"
required>

<input type="text"
name="phone"
placeholder="Mobile Number"
maxlength="10"
oninput="this.value=this.value.replace(/[^0-9]/g,'')"
required>

<input type="date"
name="purchaseDate">

<input type="number"
name="members"
placeholder="No of Members">

<!-- VEHICLE -->

<div id="vehicleContainer">

<div>

<input type="text"
name="vehicle"
placeholder="Vehicle No">

<button type="button"
class="add-btn"
onclick="addVehicle()">
+
</button>

</div>

</div>

</div>

<!-- RIGHT -->

<div class="right">

<div class="upload-box">

Share Certificate

<input type="file" name="shareDoc">

</div>

<div class="upload-box">

Index Copy

<input type="file" name="indexDoc">

</div>

<div class="upload-box">

Other Document

<input type="file" name="otherDoc">

</div>

</div>

</div>

<button class="submit">
Save Owner
</button>

</form>

<!-- TENANT FORM -->

<form id="tenantForm"
action="addTenant"
method="post"
style="display:none;">

<div class="form-container">

<div class="left">

<select name="block" required>

<option value="">Select Block</option>
<option>A</option>
<option>B</option>
<option>C</option>
<option>D</option>
<option>E</option>

</select>

<input type="text"
name="flatNo"
placeholder="House No"
required>

<input type="text"
name="tenantName"
placeholder="Tenant Name"
required>

<input type="text"
name="phone"
placeholder="Mobile Number"
maxlength="10"
oninput="this.value=this.value.replace(/[^0-9]/g,'')"
required>

<label>Rent Start Date</label>

<input type="date"
name="startDate">

<label>Rent End Date</label>

<input type="date"
name="endDate">

<input type="number"
name="members"
placeholder="No of Members">

<!-- VEHICLE -->

<div id="tenantVehicleContainer">

<div>

<input type="text"
name="tenantVehicle"
placeholder="Vehicle No">

<button type="button"
class="add-btn"
onclick="addTenantVehicle()">
+
</button>

</div>

</div>

</div>

<!-- RIGHT -->

<div class="right">

<div class="owner-info">

<input type="text"
placeholder="Owner Name (Auto)"
readonly>

<input type="text"
placeholder="Owner Phone (Auto)"
readonly>

</div>

<div class="upload-box">

Rent Agreement

<input type="file" name="rentDoc">

</div>

<div class="upload-box">

Police Verification

<input type="file" name="policeDoc">

</div>

<div class="upload-box">

Other Document

<input type="file" name="otherDoc">

</div>

</div>

</div>

<button class="submit">
Save Tenant
</button>

</form>

</div>

<!-- FOOTER -->

<div class="footer">

The Bharat Solutions, 224, Samruddhi Business Hub,
Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat - 382330.

<br>

Contact no: +91-95865 05037

&nbsp; | &nbsp;

Visit:
<a href="https://thebharatsolutions.com"
target="_blank">
Thebharatsolutions.com
</a>

</div>

</body>
</html>