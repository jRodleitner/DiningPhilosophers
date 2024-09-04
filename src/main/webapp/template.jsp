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
            gap: 10px;
            background-color: #216477;
        }

        .nav-button {
            text-decoration: none;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 5px 10px;
            transition: color 0.3s;
            position: relative;
        }

        .nav-button:hover {
            color: #0073e6; /* Change color on hover */
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
    <h1 style="color: white;">Dining Philosophers</h1>
    <nav class = "navbar">
        <a  href="/?selected=2" class = "nav-button" >Main Page</a>
        <a  href="/simulation" class = "nav-button" >Simulation Page</a>
    </nav>
</header>

<main>
    <!-- Dynamic Content -->

    <% String contentPage = request.getParameter("contentPage"); %>
    <jsp:include page ="<%= contentPage %>" />
</main>

<footer>
    <p>Jona Albin Elia Rodleitner - &copy; 2024</p>
</footer>
</body>
</html>
