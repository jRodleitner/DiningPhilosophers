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

    <p>
        The resource hierarchy solution to the Dining Philosophers Problem works by assigning a unique order to the chopsticks (resources), numbered from 0 to (n−1).
        Philosophers always attempt to pick up the lower-numbered chopstick first before picking up the higher-numbered one.
        This forces all philosophers, except one, to act "left-handed" (they pick up the left chopstick first).
        One philosopher (the last one in the circle) will act as the "right-handed," picking up their right chopstick first.

        This strategy is effective in preventing deadlock because it eliminates the circular wait condition by Coffman.
        Since philosophers always pick up chopsticks in a consistent order, no circular chain of waiting can form.
        At least one philosopher will always be able to proceed, ensuring the system avoids deadlock and allowing each philosopher to eventually eat.
    <p>
        Now let us evaluate the given Algorithm according to the key challenges we face for designing a dining philosophers solution:
    </p>
    <ul>
        <li>Deadlocks: Resource Hierarchy effectively prevents deadlocks</li>
        <li>Fairness: Resource Hierarchy fails at providing fairness to the system, as no such measures are taken.</li>
        <li>TODO::Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating by this approach.</li>
        <li>Implementation: The changes required to implement this solution are minimal, no complex logic needed. </li>
        <li>TODO:: Performance:  </li>
    </ul>
    <p>To implement the Resource Hierarchy solution, only the run function in the philosopher class has to be modified:</p>
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

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>

    <a href="../simulation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Simulation</a>
    <a href="../animation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Animation</a>
</div>

<h2>Asymmetric Solution</h2>
<div class="description">
    <img src="../pictures/asymmetric.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>
        The Asymmetric Solution takes a slightly different approach by assigning an order to the philosophers instead of the chopsticks.
        Philosophers with an even number pick up the left chopstick first, while those with an odd number pick up the right chopstick first.
        By alternating the order of chopstick pickups between even and odd philosophers, the system prevents deadlocks by avoiding the circular wait condition by Coffman.
    </p>
    <p>Let us again evaluate the given Algorithm according to the key-challenges:</p>
    <ul>
        <li>Deadlocks: The Asymmetric Solution effectively prevents deadlocks</li>
        <li>Fairness: The Asymmetric Solution fails at providing fairness to the system, as no such measures are taken.</li>
        <li>TODO::Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating by this approach.</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>TODO::Performance: </li>
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
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ASYMMETRIC" class="button">Asymmetric Simulation</a>
    <a href="../animation/?algorithm=ASYMMETRIC" class="button">Asymmetric Animation</a>
</div>
</body>
</html>
