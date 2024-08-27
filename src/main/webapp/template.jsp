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
            background-color: #F8C7A4; /* Pastel apricot color */
            color: #333;
            padding: 10px 0;
            text-align: center;
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
            max-width: 800px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<header>
    <h1>Generic Header</h1>
</header>

<main>
    <!-- Dynamic Content -->

    <% String contentPage = request.getParameter("contentPage"); %>
    <jsp:include page="<%= contentPage %>" />
</main>

<footer>
    <p>Generic Footer - &copy; 2024</p>
</footer>
</body>
</html>
