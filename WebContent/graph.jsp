<%@ page import="java.sql.*,model.DBConnection, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<title>Dynamic Graph</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial;
    background:#f5f6fa;
    margin:0;
    padding:0;
}

/* Heading */
h2{
    text-align:center;
    margin-top:30px;
    color:#2c3e50;
}

/* Chart Container (MEDIUM SIZE + CLEAN UI) */
.chart-container {
    width: 600px;
    margin: 40px auto;
    background: white;
    padding: 20px;
    border-radius: 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
}

/* Control chart height */
#paymentChart {
    height: 300px !important;
}
</style>

</head>
<body>

<h2>📊 Members Per House</h2>

<%
List<String> labels = new ArrayList<>();
List<Integer> data = new ArrayList<>();

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT house_no, COUNT(*) as total FROM members GROUP BY house_no"
    );

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
        labels.add("House " + rs.getString("house_no"));
        data.add(rs.getInt("total"));
    }

} catch(Exception e){
    e.printStackTrace();
}
%>

<div class="chart-container">
    <canvas id="paymentChart"></canvas>
</div>

<script>
const labels = <%= labels.toString() %>;
const data = <%= data.toString() %>;

const ctx = document.getElementById('paymentChart');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [{
            label: 'Members',
            data: data,
            backgroundColor: '#4e73df',
            borderRadius: 8
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                display: true,
                position: 'top'
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
</script>

</body>
</html>