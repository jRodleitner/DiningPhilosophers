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
<h2>Resource Hierarchy Solution</h2>
<div class="description">
    <img src="../pictures/resource.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>

    <p>Probably one of the most famous solutions to the Dining Philosophers problem, it tries to prevent deadlocks
        by ordering the available resources 0 through n
        <br>
        Philosophers will then always try to pick up the chopstick that is assigned the lower ordering first.
        <br>
        This essentially turns one of them into a right-handed philosopher while the others try picking up the left
        chopstick first.
        <br>
        This is effective in avoiding deadlocks, because it avoids the circular wait condition as defined by Coffman.
        <br>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fails at providing fairness to the system, as no such measures are taken.</li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating by this approach.</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
    </ul>
    <p>To implement the Resource Hierarchy solution, only the run function has to be modified:</p>
    <pre><code>
        run() {
            while (!terminate()) {
                think();
                if(leftChopstick.getId() < rightChopstick.getId()){
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                } else {
                    pickUpRightChopstick();
                    pickUpLeftChopstick();
                    eat();
                    putDownRightChopstick();
                    putDownLeftChopstick();
                }
        }
    </code></pre>

    </p>
    <a href="../simulation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Simulation</a>
    <a href="../animation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Animation</a>
</div>

<h2>Asymmetric Solution</h2>
<div class="description">
    <img src="../pictures/asymmetric.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>The Asymmetric Solution takes things one step further, but instead of using the ordering of resources we assign an order to the philosophers.
        Those with even order pick up the left chopstick first, whereas the ones with odd order pick up their right chopstick first.
        This solution again prevents deadlocks by avoiding the circular wait condition.
    </p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fails at providing fairness to the system, as no such measures are taken.</li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating by this approach.</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
    </ul>
    <br>
    <p>To implement the Asymmetric solution, only the run function has to be modified:</p>
    <pre><code>
        run() {
            boolean even = id % 2 == 0;
            while (!terminated()) {
                think();
                if(even){
                    pickUpLeftFork();
                    pickUpRightFork();
                    eat();
                    putDownLeftFork();
                    putDownRightFork();
                } else {
                    pickUpRightFork();
                    pickUpLeftFork();
                    eat();
                    putDownRightFork();
                    putDownLeftFork();
                }
            }
        }
    </code></pre>
    <a href="../simulation/?algorithm=ASYMMETRIC" class="button">Asymmetric Simulation</a>
    <a href="../animation/?algorithm=ASYMMETRIC" class="button">Asymmetric Animation</a>
</div>
</body>
</html>
