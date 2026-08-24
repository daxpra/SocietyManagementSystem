<%@ page language="java" %>

<%
    // 🔥 Destroy session
    session.invalidate();

    // 🔥 Redirect to login page
    response.sendRedirect("index.jsp");
%>