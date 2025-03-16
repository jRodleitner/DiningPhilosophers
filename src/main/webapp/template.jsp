<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%= request.getParameter("pageTitle") %></title>
    <style>


        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        header {
            background-color: #216477;
            color: #333;
            padding: 10px 0;
            text-align: center;

        }

        .navbar {
            text-align: center;
            display: flex;
            gap: 5px;
            background-color: #216477;
        }

        .nav-button {
            text-decoration: none;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 10px 10px;
            transition: color 0.3s;
            position: relative;
            margin-left: 10px;
        }

        .nav-button::after {
            content: '';
            display: block;
            width: 0;
            height: 2px;
            background-color: #e0e0e0;
            position: relative;
            left: 0;
            bottom: 0;
            transition: width 0.3s ease;
        }

        .nav-button:hover::after {
            width: 100%;
        }


        .nav-button:not(:last-child) {
            border-right: 1px solid #ccc;
            padding-right: 20px;
        }

        footer {
            background-color: #333;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        main {
            padding: 20px;
            background-color: white;
            margin: 20px auto;
            max-width: 1300px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<header>
    <nav class = "navbar">
        <a  href="${pageContext.request.contextPath}/?selected=2" class = "nav-button" >Main Page</a>
        <a  href="${pageContext.request.contextPath}/simulation" class = "nav-button" >Simulation Page</a>
        <a  href="${pageContext.request.contextPath}/animation" class = "nav-button" >Animation</a>
        <a  href="${pageContext.request.contextPath}/about" class = "nav-button" >About</a>
    </nav>
</header>

<main>
    <!-- Dynamic Content -->

    <% String contentPage = request.getParameter("contentPage"); %>
    <jsp:include page ="<%= contentPage %>" />
</main>

<footer>
    <p>Jona Rodleitner -2025-</p>
</footer>
</body>
</html>
