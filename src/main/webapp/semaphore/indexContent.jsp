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
            padding: 5px;
            overflow-x: auto; /* Allow horizontal scrolling */
            white-space: nowrap; /* Prevent line wrapping */
            border-radius: 5px; /* Rounded corners */
            font-family: "Courier New", Courier, monospace;
            max-width: 100%; /* Ensure the width doesn't overflow the container */
        }

        /* Styling for the actual code */
        code {
            display: block; /* Ensure the code behaves like a block element */
            background-color: #f5f5f5; /* Match pre background */
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 13px;
            white-space: pre; /* Ensure code stays on one line */
        }
    </style>
</head>
<body>
<h2>Semaphore Solutions</h2>
<div class="description">
    <p>
        Semaphores are a frequently used synchronization mechanism for concurrent systems to manage access to resources.
        They are primarily used to prevent race conditions and deadlocks.
        In the following we will use Binary semaphores, which can only take values 0 and 1, this means they will allow access to one thread only.
        The resource is accessible if a semaphore has value 1. The acquiring thread will then decrease the value and the semaphore will be locked.
        Threads trying to acquire a locked semaphore will usually be put into an implicit queue, waiting for the time the initial thread releases the semaphore,
        after which they will be the permitted thread.
    </p>
    <img src="../pictures/semaphore.svg" alt="Dining Philosophers Problem" width="400" height="350">




    <h2>Table Semaphore Solution</h2>
    <p>
        Locking the whole table with a semaphore is the simplest solution to avoid deadlocks for the dining philosophers.
        Of course, this approach eliminates concurrency from our system,
        and is therefor just useful for an introductory example on how to avoid deadlocks using semaphores.

    </p>

    <p>The implementation is fairly simple: Philosophers need to acquire the table semaphore before eating.</p>
    <pre><code>
        codeee
        codeee
    </code></pre>

    <p>Now let us evaluate the Table Semaphore solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Animation</a>



    <h2>Dijkstra Solution</h2>
    <p>
        This Solution was proposed by Dijkstra and...
    </p>

    <pre><code>
        codeee
        codeee
    </code></pre>

    <p>Now let us evaluate the Table Semaphore solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=DIJKSTRA" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=DIJKSTA" class="button">Table Semaphore Animation</a>




    <h2>Tanenbaum Solution</h2>
    <p>

    </p>

    <pre><code>
        codeee
        codeee
    </code></pre>

    <p>Now let us evaluate the Table Semaphore solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TANENBAUM" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=TANENBAUM" class="button">Table Semaphore Animation</a>




</div>
</body>
</html>
