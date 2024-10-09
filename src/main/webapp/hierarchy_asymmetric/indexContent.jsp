<%--
  Created by IntelliJ IDEA.
  User: jonar
  Date: 08.10.2024
  Time: 06:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Token Solution</title>
    <style>
        .button {
            display: inline-block; /* Allows padding to be applied properly */
            color: white; /* White font color */
            background-color: #216477; /* Teal background color */
            text-decoration: none; /* Removes the underline from links */
            padding: 5px 10px; /* Adds padding to make the link look like a button */
            border-radius: 20px; /* Rounds the corners of the button */
            font-weight: bold; /* Makes the text bold */
            transition: background-color 0.4s ease, color 0.4s ease; /* Smooth transition on hover */
            margin: 5px 0; /* Adds space between buttons */
        }

        /* Hover Effect */
        .button:hover {
            background-color: #438699; /* Darker teal on hover */
            color: #e0e0e0; /* Optional: Change text color slightly on hover */
        }

        .description {
            line-height: 1.4; /* Increases spacing between lines for readability */
            color: #333;
            padding: 14px;
            margin-bottom: 15px;
            max-width: 800px;
        }
    </style>
</head>
<body>
<h2>Resource Hierarchy Solution</h2>
<div class="description">
    <p>The Resource Hierarchy Solution </p>
    <img src="../pictures/resource.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <a href="../simulation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Simulation</a>
    <a href="../animation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Animation</a>
</div>
<h2>Asymmetric Solution</h2>
<div class="description">
    <p>The Token Solution </p>
    <img src="../pictures/asymmetric.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <a href="../simulation/?algorithm=ASYMMETRIC" class="button">Asymmetric Simulation</a>
    <a href="../animation/?algorithm=ASYMMETRIC" class="button">Asymmetric Animation</a>
</div>
</body>
</html>
