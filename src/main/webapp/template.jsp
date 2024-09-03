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
            text-align: left;

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
            max-width: 1600px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<header>
    <h1 style="color: white;">Dining Philosophers</h1>
    <nav>
        <a href="/?selected=2">Main Page</a>
        <a href="/simulation">Simulation Page</a>
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
