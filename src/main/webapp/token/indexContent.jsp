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

        /* Styling for the actual code */
        code {
            background-color: #f5f5f5; /* Match pre background */
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 14px;
        }

        /* Optional: Additional styling for line numbers (if needed) */
        pre.line-numbers {
            counter-reset: line; /* Reset line counter */
        }

        pre.line-numbers code::before {
            counter-increment: line; /* Increment line counter */
            content: counter(line); /* Display line number */
            display: inline-block;
            width: 2em;
            margin-right: 10px;
            text-align: right;
            color: #999;
        }
    </style>
</head>
<body>
<h2>Global Token Solution</h2>
<div  class="description">

    <img src="../pictures/token.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>The Token Solution is surely one of the most intuitive solutions to avoid deadlocks.
        At the start of the simulation a token is handed to the first philosopher, who holds on to it until the eating is finished.
        After which the token is handed on counter-clock wise to the adjacent philosopher, thus only one philosopher can eat at a time.
        This effectively prevents deadlocks by avoiding the circular wait condition as defined by Coffman.
    </p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fair, as each philosopher gets a turn at eating </li>
        <li>Concurrency: No concurrency since only one philosopher can eat.</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as... </li>
        <li>Performance: ... </li>
    </ul>

    <pre><code>
        codeeee
        codeeee
    </code></pre>

    <h2>Multiple Token Solution</h2>
    <img src="../pictures/multiple-token_questionmanrk.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>The Global Token Solution is hardly ideal. It does prevent deadlocks and provides fairness to the system,
        but it essentially eliminates Concurrency.
        The next idea would be to introduce multiple tokens into the system. We know that the maximum concurrency in our system under ideal conditions to [n/2] for even n and  &lfloor;n/2&rfloor; for uneven n.
        Two adjacent philosopher can never eat at the same time, so the idea is to just hand
        every other philosopher a token and prevent the token from being passed on to the next philosopher if the one next to them also holds a token.
        If we have an uneven number of philosophers the last one is skipped automatically.
        We pass the token only after the other philosopher has passed on its token. In theory we can reach
        maximum concurrency of [n/2]/ &lfloor;n/2&rfloor;, if there are few or no outliers for the execution times of eating and if eating and thinking times are similarly distributed.
    </p>
    <img src="../pictures/multipletoken_working.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fair, as each philosopher gets a turn at eating </li>
        <li>Concurrency: Concurrent, as multiple tokens are passed around permitting [n/2]/ &lfloor;n/2&rfloor; at a time to eat</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as... </li>
        <li>Performance: ... </li>
    </ul>
    <p>the modifications...</p>
    <pre><code>
        codeeee
        codeeee
    </code></pre>
    <p>the modifications...</p>
    <pre><code>
        codeeee
        codeeee
    </code></pre>
</div>
</body>
</html>
