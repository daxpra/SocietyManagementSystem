<%@ page import="model.Member" %>

<%
Member m = (Member) request.getAttribute("member");
%>

<html>
<head>
<title>Edit Member</title>
</head>

<body>

<h2>Edit Member</h2>

<form action="updateMember" method="post">

    <input type="hidden" name="id" value="<%= m.getId() %>">

    Name: <input type="text" name="name" value="<%= m.getName() %>"><br><br>

    Block: <input type="text" name="block" value="<%= m.getBlock() %>"><br><br>

    Flat No: <input type="text" name="flatNo" value="<%= m.getFlatNo() %>"><br><br>

    <input type="submit" value="Update">

</form>

</body>
</html>