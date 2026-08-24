<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<html>
<head>
<title>Complaints</title>

<style>
body { font-family: Arial; }

table {
    width: 80%;
    margin: auto;
    border-collapse: collapse;
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

</style>

</head>

<body>

<h2 style="text-align:center;">Complaints List</h2>

<table>
<tr>
    <th>ID</th>
    <th>Title</th>
    <th>Description</th>
    <th>Status</th>
</tr>

<%
List<String[]> list = (List<String[]>)request.getAttribute("complaintList");

if(list != null){
    for(String[] c : list){
%>

<tr>
    <td><%=c[0]%></td>
    <td><%=c[1]%></td>
    <td><%=c[2]%></td>
    <td><%=c[3]%></td>
</tr>

<%
    }
}
%>

</table>
<div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div>
</body>
</html>