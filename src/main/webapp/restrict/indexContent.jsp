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

        .description {
            line-height: 1.4; /* Increases spacing between lines for readability */
            color: #333;
            padding: 14px;
            margin-bottom: 15px;
            max-width: 800px;
        }

        pre {
            background-color: #f5f5f5;
            border: 1px solid #ccc;
            padding: 15px;
            overflow: auto;
            white-space: pre-wrap; /* Wrap lines */
            word-wrap: break-word; /* Break long lines */
            border-radius: 5px; /* Rounded corners */
            font-family: "Courier New", Courier, monospace;
        }


        code {
            background-color: #f5f5f5; /* Match pre background */
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 14px;
        }
    </style>
</head>
<body>
<h2>Restrict Solution</h2>
<div class="description">
    <p>The Restrict Solution </p>
    <img src="../pictures/restrict.svg" alt="Dining Philosophers Problem" width="400" height="350">#
    <p>
        Another way to prevent deadlocks is to restrict the number of philosophers that can attempt to eat at any moment.
    </p>

    <p>Now let us evaluate the Restrict solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>
    <pre><code>
        codeee
        codeee
    </code></pre>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=RESTRICT" class="button">Restrict Simulation</a>
    <a href="../animation/?algorithm=RESTRICT" class="button">Restrict Animation</a>
</div>

</body>
</html>
