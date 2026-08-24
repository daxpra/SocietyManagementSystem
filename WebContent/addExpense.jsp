<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Add Expense</title>
</head>
<body>

<h2>Add Expense</h2>

<form action="AddExpenseServlet" method="post">
    Amount: <input type="number" name="amount" required><br><br>
    Description: <input type="text" name="description"><br><br>
    Date: <input type="date" name="date" required><br><br>

    <button type="submit">Add Expense</button>
</form>

</body>
</html>