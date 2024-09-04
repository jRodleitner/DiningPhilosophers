<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Dining Philosophers Page</title>
    <style>
        /* CSS for Button-like Links */
        .button {
            display: inline-block; /* Allows padding to be applied properly */
            color: white; /* White font color */
            background-color: #216477; /* Teal background color */
            text-decoration: none; /* Removes the underline from links */
            padding: 10px 20px; /* Adds padding to make the link look like a button */
            border-radius: 20px; /* Rounds the corners of the button */
            font-weight: bold; /* Makes the text bold */
            transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition on hover */
            margin: 5px 0; /* Adds space between buttons */
        }

        /* Hover Effect */
        .button:hover {
            background-color: #438699; /* Darker teal on hover */
            color: #e0e0e0; /* Optional: Change text color slightly on hover */
        }
    </style>
</head>
<body>
<h1>Dining Philosophers Landing Page</h1>
<br/>
<a href="asymmetric" class="button">Asymmetric Solution</a>
<br/>
<a href="hierarchy" class="button">Resource Hierarchy Solution</a>
<br/>
<a href="timeout" class="button">Timeout Solution</a>
<br/>
<a href="token" class="button">Token Solution</a>
<br/>
<a href="waiter" class="button">Waiter Solution</a>
<br/>
<a href="semaphore" class="button">Semaphore Solution</a>
<br/>
<a href="simulation" class="button">Simulation Page</a>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</body>
</html>

