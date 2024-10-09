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
<h2>Timeout Solution</h2>
<div class="description">
    <img src="../pictures/timeout_.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>The Timeout solution tries to prevent deadlocks through stopping the philosophers from holding on to chopsticks indefinitely.
        <br>
        The timout is set before the start of the simulation and is the same across all philosophers.
        They try to pick up the first chopstick as usual

        When the timeout is reached a philosopher puts back the initially picked up fork and resumes thinking.
        <br>
        Deadlocks are prevented by avoiding the Hold-And-Wait condition as defined by Coffman.
        One big issue with this approach is that when a timeout occurs philosophers will have to enter a new cycle,
        instead of being allowed to eat in its previous cycle.

    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fails at providing fairness to the system, as no such measures are taken.</li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not actively blocked from eating by this approach.</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as both the Philosopher and Fork classes have to be modified. </li>
        <li>Performance: Not a giant overhead but total eat time might be reduced when frequent timeouts occur. </li>
    </ul>
    <p>Pseudocode: Modifications to the philosopher class:</p>
    <pre><code>
        public void run() {
            while (!terminated()) {
                think();
                pickUpLeftChopstick();
                boolean succPickup = pickUpRightWithTimeout();
                if(succPickup){
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                } else {
                    putDownLeftChopstick();
                }
            }
        }

        protected boolean pickUpRightWithTimeout() {
            boolean succPickup = rightTimeoutFork.pickUpRight();
            if(succPickup){
                Log(id, Events.PICKUPRIGHT, table.getCurrentTime());
            }
            return succPickup;
        }
    </code></pre>
    <p>
        Pseudocode: modifications to the Chopstick Class.
    </p>
    <pre><code>
        synchronized boolean pickUpRight() {
            long startTime = System.currentTimeMillis();
            long remainingTime = timeout;

            while (!isAvailable) {
                if (remainingTime <= 0) {
                    return false;
                }
                wait(remainingTime);
                remainingTime = timeout - (System.currentTimeMillis() - startTime);
            }
            isAvailable = false;
            return true;
        }
    </code></pre>
    <a href="../simulation/?algorithm=TIMEOUT" class="button">Timeout Simulation</a>
    <a href="../animation/?algorithm=TIMEOUT" class="button">Timeout Animation</a>
</div>
</body>
</html>
