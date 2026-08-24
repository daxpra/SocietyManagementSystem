<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();

ResultSet rs = st.executeQuery(
    "SELECT * FROM payments WHERE status='Paid' ORDER BY date DESC"
);
%>

<!DOCTYPE html>
<html>
<head>
<title>Income</title>

<style>
body { font-family: Arial; padding:20px; }
table { width:100%; border-collapse: collapse; }
th, td { padding:10px; border:1px solid #ccc; text-align:center; }
th { background:#3498db; color:white; }
</style>

</head>

<body>

<h2>💰 Income List</h2>

<table>
<tr>
    <th>ID</th>
    <th>Amount</th>
    <th>Penalty</th>
    <th>Date</th>
</tr>

<%
while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td>₹<%= rs.getInt("amount") %></td>
    <td>₹<%= rs.getInt("penalty") %></td>
    <td><%= rs.getString("date") %></td>
</tr>
<%
}
%>

</table>

</body>
</html>