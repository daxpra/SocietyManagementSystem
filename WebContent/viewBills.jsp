<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<html>
<head>
<title>View Bills</title>

<style>
body {
    font-family: Arial;
    margin: 0;
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

.container {
    width: 80%;
    margin: 50px auto;
    background: rgba(255,255,255,0.9);
    padding: 20px;
    border-radius: 10px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th, td {
    padding: 10px;
    border: 1px solid #ddd;
    text-align: center;
}

th {
    background: #273c75;
    color: white;
}

.back-btn {
    padding: 8px 15px;
    background: #273c75;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}
</style>

</head>

<body>

<div class="container">

<a href="userDashboard.jsp" class="back-btn">⬅ Back to Dashboard</a>

<h2 style="text-align:center;">💰 Bills</h2>

<table>
<tr>
    <th>ID</th>
    <th>Flat No</th>
    <th>Amount</th>
    <th>Status</th>
</tr>

<%
List<String[]> list = (List<String[]>)request.getAttribute("billList");

if(list != null){
    for(String[] b : list){
%>

<tr>
    <td><%=b[0]%></td>
    <td><%=b[1]%></td>
    <td><%=b[2]%></td>
    <td><%=b[3]%></td>
</tr>

<%
    }
}else{
%>

<tr>
    <td colspan="4">No Bills Available</td>
</tr>

<%
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