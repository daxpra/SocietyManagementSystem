<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Complaint</title>

<style>
body {
    font-family: Arial;
    margin: 0;
}

/* Background blur */
body::before {
    content: "";
    position: fixed;
    width: 100%;
    height: 100%;
    background: url("images/background.jpg") no-repeat center/cover;
    filter: blur(6px);
    z-index: -1;
}

.container {
    width: 400px;
    margin: 80px auto;
    background: rgba(255,255,255,0.9);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
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

@media (max-width: 768px) {
    .container {
        flex-direction: column;
        padding: 10px;
    }
    
    @media (max-width: 768px) {
    .extra-info {
        display: none;
    }
}

.small-box {
    max-height: 200px;
    overflow-y: auto;
}

.dashboard {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
}

@media (max-width: 768px) {
    .dashboard {
        grid-template-columns: 1fr;
    }
}

    .card {
        width: 100%;
        margin-bottom: 10px;
    }

    .sidebar {
        display: none;
    }
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

<div class="container">

<h2>Add Complaint</h2>

<form action="<%=request.getContextPath()%>/addComplaint" method="post">

    <input type="text" name="title" placeholder="Complaint Title" required><br><br>

    <textarea name="description" placeholder="Enter complaint" required></textarea><br><br>

    <button type="submit">Submit</button>

</form>

</div>
<div class="footer">
    The Bharat Solutions, 224, Samruddhi Business Hub, Naroda Dehgam Road, Naroda, Ahmedabad, Gujarat. 302330.
    <br>
    Contact no: +91-95865 05037 &nbsp; | &nbsp;
    Visit: <a href="https://thebharatsolutions.com" target="_blank">Thebharatsolutions.com</a>
</div>
</body>
</html>