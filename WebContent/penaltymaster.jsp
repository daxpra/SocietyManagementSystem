<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Penalty Master</title>

<style>
body { font-family: Arial; background:#f5f6fa; }

.container {
    width:90%;
    margin:auto;
    margin-top:30px;
    background:white;
    padding:20px;
    border-radius:10px;
}

h2 {
    text-align:center;
    color:#273c75;
}

table {
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
}

th, td {
    padding:10px;
    border:1px solid #ddd;
    text-align:center;
}

th {
    background:#dcdde1;
}

button {
    padding:8px 15px;
    background:#273c75;
    color:white;
    border:none;
}
body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background:
        linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
        url("<%=request.getContextPath()%>/images/background.png") no-repeat center/cover;
    filter: blur(3px);
    z-index: -1;
}
.footer {
    position: fixed;
    bottom: 0;
    width: 100%;
    background: #2c3e50;
    color: #fff;
    text-align: center;
    padding: 8px;
    font-size: 13px;
    border-top: 2px solid #000;
}

.footer a {
    color: #00c3ff;
    text-decoration: none;
}
</style>
</head>

<body>
<a href="adminDashboard">
    <button>⬅ Back to Dashboard</button>
</a>
<div class="container">

<h2>Penalty Master</h2>

<form action="<%=request.getContextPath()%>/addPenalty" method="post" enctype="multipart/form-data">

    <input type="date" name="startDate" required>
    <input type="text" name="type" placeholder="Type of Penalty" required>
    <input type="number" name="amount" placeholder="Charge per Day" required>

    <input type="file" name="photo">

    <button type="submit">Add</button>

</form>

<table>
<tr>
    <th>Start Date</th>
    <th>Type of Penalty</th>
    <th>Charge/Per Day</th>
    <th>Photo</th> <!-- ✅ Added -->
    <th>Delete</th>
</tr>
<c:forEach var="p" items="${penaltyList}">
<tr>
<td>${p.start_date}</td>
<td>${p.type}</td>
<td>${p.amount}</td>
<td>${p.photo}</td>
<td>${p.id}</td>
</tr>
</c:forEach>
<%
    java.util.List<String[]> list = (java.util.List<String[]>)request.getAttribute("penaltyList");
    if(list != null){
        for(String[] p : list){
%>
<tr>
    <td><%=p[0]%></td>
    <td><%=p[1]%></td>
    <td><%=p[2]%></td>

    <!-- ✅ Show Image -->
    
    <td>
        <img src="<%=request.getContextPath()%>/uploads/<%=p[3]%>" 
             width="60" height="60" style="border-radius:8px;">
    </td>

    <!-- ✅ Correct ID index -->
    <td>
        <a href="<%=request.getContextPath()%>/deletePenalty?id=<%=p[4]%>">❌</a>
    </td>
</tr>
<%
        }
    }
%>

</table>

</div>
<div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div>
</body>
</html>