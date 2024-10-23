<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%= request.getParameter("pageTitle") %></title>
    <style>
        /* Add your generic CSS here */

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
            content: ''; /* Create the line */
            display: block; /* Allows the line to take up the correct space */
            width: 0; /* Start with no width */
            height: 2px; /* Thickness of the underline */
            background-color: #e0e0e0; /* Color of the underline */
            position: relative; /* Position it relative to the text */
            left: 0;
            bottom: 0;
            transition: width 0.3s ease; /* Smooth transition */
        }

        .nav-button:hover::after {
            width: 100%; /* Expand the line to full width of the text on hover */
        }


        .nav-button:not(:last-child) {
            border-right: 1px solid #ccc; /* Add vertical line between buttons */
            padding-right: 20px; /* Add padding to make space for the line */
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
    <p>Jona Albin Elia Rodleitner - Johannes Kepler University Linz - 2024</p>
</footer>
</body>
</html>
