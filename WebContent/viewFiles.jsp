<%@ page import="java.io.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String user = (String) session.getAttribute("username");

if (user == null) {
    response.sendRedirect("index.jsp");
}
%>
<html>
<head>
<title>View Files</title>

<style>
body {
    font-family: Arial;
    background: #f4f6f9;
    padding: 20px;
}

h2 {
    text-align: center;
}

table {
    width: 60%;
    margin: auto;
    border-collapse: collapse;
    background: white;
}

th, td {
    padding: 10px;
    border: 1px solid #ccc;
    text-align: center;
}

a {
    text-decoration: none;
    color: white;
    background: #27ae60;
    padding: 5px 10px;
    border-radius: 5px;
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

<h2>Uploaded Files</h2>

<form method="get" style="text-align:center; margin-bottom:20px;">
    <input type="text" name="search" placeholder="Search file..." 
           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">

    <button type="submit">Search</button>
</form>

<table>
<tr>
    <th>File Name</th>
    <th>Action</th>
</tr>

<%
String uploadPath = application.getRealPath("") + File.separator + "uploads";
File folder = new File(uploadPath);

if(folder.exists()){
	String search = request.getParameter("search");

	File[] files = folder.listFiles();

	if(files != null){
	    for(File file : files){

	        String fileName = file.getName();

	        if(search == null || fileName.toLowerCase().contains(search.toLowerCase())){
	%>

	<tr>
	    <td><%= fileName %></td>
	    <td>
	        <a href="uploads/<%= fileName %>" target="_blank">View</a>

	        <a href="uploads/<%= fileName %>" download>
	            <button style="background:blue; color:white;">Download</button>
	        </a>

	        <a href="deleteFile?name=<%= fileName %>">
	            <button style="background:red; color:white;">Delete</button>
	        </a>
	    </td>
	</tr>

	<%
	        }
	    }
	}

    for(File file : files){
    	String fileName = file.getName();
%>
<tr>
    <td><%= file.getName() %></td>
    <td>
        <a href="uploads/<%= file.getName() %>" target="_blank">View</a>

<a href="downloadFile?name=<%= fileName %>">
    <button style="background:blue; color:white;">Download</button>
</a>
        
        <!-- DELETE BUTTON -->
        
        <a href="deleteFile?name=<%= file.getName() %>">
            <button style="background:red; color:white;">Delete</button>
        </a>
    </td>
</tr>
<%
    }
}
%>

</table>
<div style="text-align:left; margin:15px;">
    <a href="adminDashboard" 
       style="text-decoration:none; 
              background:#2f80ed; 
              color:white; 
              padding:8px 15px; 
              border-radius:8px;
              font-size:14px;">
        ⬅ Back to Dashboard
    </a>
</div>
<div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div>
</body>
</html>