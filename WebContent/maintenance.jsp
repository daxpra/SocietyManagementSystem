<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Maintenance</title>

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
}

/* MAIN BOX */

.box{
    width:95%;
    max-width:1450px;
    margin:25px auto;
    background:white;
    padding:25px;
    border-radius:22px;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
}

/* TITLE */

h2{
    margin-bottom:20px;
    color:#0f172a;
}

/* ROW */

.row{
    display:flex;
    gap:14px;
    flex-wrap:wrap;
    align-items:center;
}

/* FORM */

input,
select{
    padding:12px;
    border-radius:12px;
    border:1px solid #cbd5e1;
    min-width:170px;
}

/* BUTTON */

button{
    padding:12px 20px;
    border:none;
    border-radius:12px;
    background:#2563eb;
    color:white;
    cursor:pointer;
    font-weight:600;
}

button:hover{
    background:#1d4ed8;
}

/* TABLE */

.table-wrapper{
    width:100%;
    overflow-x:auto;
    margin-top:20px;
}

table{
    width:100%;
    min-width:1200px;
    border-collapse:collapse;
    background:white;
}

th{
    background:#2563eb;
    color:white;
    padding:14px;
}

td{
    padding:12px;
    text-align:center;
    border-bottom:1px solid #e2e8f0;
}

tr:hover{
    background:#f8fafc;
}

/* BACK BUTTON */

.back-btn{
    display:inline-block;
    margin-top:20px;
    text-decoration:none;
    background:#f59e0b;
    color:white;
    padding:12px 22px;
    border-radius:12px;
}

.back-btn:hover{
    background:#d97706;
}

/* MOBILE */

@media(max-width:768px){

    .row{
        flex-direction:column;
        align-items:stretch;
    }

    input,
    select,
    button{
        width:100%;
    }
}

</style>

</head>

<body>

<div class="box">

<!-- GENERATE -->

<h2>🧾 Maintenance Master</h2>

<form action="generateMaintenance" method="post">

<div class="row">

<label>
<input type="radio"
name="type"
value="all"
required>
All Generate
</label>

<label>
<input type="radio"
name="type"
value="single">
Individual
</label>

<input type="text"
name="flat_no"
placeholder="House No">

<label>
<input type="checkbox"
name="pdf"
value="yes">
PDF
</label>

<button type="submit">
Generate
</button>

</div>

</form>

<hr><br>

<!-- FILTER -->

<form action="viewPayments"
method="get">

<div class="row">

<select name="status">

<option value="all">
All
</option>

<option value="Paid">
Paid
</option>

<option value="Pending">
Pending
</option>

</select>

<button type="submit">
Filter
</button>

</div>

</form>

<br>

<!-- PAYMENT FORM -->

<h2>🏠 House Payment Collection</h2>

<form action="addPayment"
method="post">

<div class="row">

<label>
<input type="radio"
name="type"
value="fixed"
checked>
FIX
</label>

<label>
<input type="radio"
name="type"
value="other">
Other
</label>

<input type="text"
name="flat_no"
placeholder="House No"
required>

<input type="number"
name="amount"
placeholder="Amount"
required>

<input type="number"
name="penalty"
placeholder="Penalty"
value="0">

<input type="date"
name="invoice_date"
required>

<select name="transaction_type"
required>

<option value="">
Txn Type
</option>

<option value="Cash">
Cash
</option>

<option value="UPI">
UPI
</option>

<option value="Card">
Card
</option>

<option value="Bank Transfer">
Bank Transfer
</option>

</select>

<input type="text"
name="transaction_no"
placeholder="Transaction No">

<select name="status">

<option value="Paid">
Paid
</option>

<option value="Pending">
Pending
</option>

</select>

<button type="submit">
Collect
</button>

</div>

</form>

<!-- TABLE -->

<div class="table-wrapper">

<table>

<tr>

<th>Sr No</th>
<th>House No</th>
<th>Date</th>
<th>Txn Type</th>
<th>Txn No</th>
<th>Amount</th>
<th>Penalty</th>
<th>Total</th>
<th>Status</th>
<th>Receipt</th>

</tr>

<c:forEach var="p"
items="${paymentList}"
varStatus="s">

<tr>

<td>${s.index+1}</td>

<td>${p.flat_no}</td>

<td>${p.payment_date}</td>

<td>${p.transaction_type}</td>

<td>${p.transaction_no}</td>

<td>₹${p.amount}</td>

<td>₹${p.penalty}</td>

<td>₹${p.total_amount}</td>

<td>${p.status}</td>

<td>

<a href="receipt?id=${p.id}">

<button type="button">
PDF
</button>

</a>

</td>

</tr>

</c:forEach>

</table>

</div>

<!-- BACK -->

<a href="adminDashboard"
class="back-btn">

⬅ Back to Dashboard

</a>

</div>

<script>

document.querySelectorAll(
"input[name='type']"
).forEach(radio => {

radio.addEventListener(
"change",
function(){

if(this.value === "fixed"){

document.querySelector(
"input[name='amount']"
).value = 1000;

}else{

document.querySelector(
"input[name='amount']"
).value = "";

}

});

});

</script>

</body>
</html>