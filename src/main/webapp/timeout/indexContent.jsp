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
            border-radius: 10px; /* Rounds the corners of the button */
            border: 4px solid #ccc;
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
            padding: 12px;
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

        .styled-table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
            margin: 20px 0;
            font-size: 16px;
            text-align: left;
        }

        .styled-table thead tr {
            background-color: #216477;
            color: #ffffff;
            text-align: left;
            font-weight: bold;
        }

        .styled-table th,
        .styled-table td {
            padding: 12px 15px;
            border: 1px solid #dddddd;
        }

        .styled-table tbody tr {
            border-bottom: 1px solid #dddddd;
        }

        .styled-table tbody tr:nth-of-type(even) {
            background-color: #f3f3f3;
        }


        .styled-table td {
            vertical-align: top;
        }

        .styled-table th {
            border-bottom: 2px solid #009879;
        }
    </style>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js" defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js" defer></script>
</head>
<body>
<h2>Timeout Solution</h2>
<div class="description">
    <img src="../pictures/timeout_.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>
        The Timeout solution aims to prevent deadlocks by stopping philosophers from holding onto chopsticks indefinitely.
        The philosophers first attempt to pick up the first chopstick as usual and then try to pick up their second chopstick with a time limit.
        If a philosopher reaches the timeout before acquiring both chopsticks, they put down the chopstick they initially picked up and wait for a short time before trying to pick up again.

    </p>

    <p>
        <b>Philosopher class:</b>
        Philosophers start eating if the pickup of the right chopstick was successful, else they put down the left chopstick and wait for a short while before they try again.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class TimeoutPhilosopher extends Philosopher {

        TimeoutChopstick rightTimeoutChopstick;

        TimeoutPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
            super(id, leftChopstick, rightChopstick);
            rightTimeoutChopstick = (TimeoutChopstick) rightChopstick;
        }

        @Override
        void run() {
            // The philosopher attempts to think and then pick up chopsticks.
            while (!terminated()) {
                think();
                pickUpLeftChopstick();
                boolean successfulPickup = pickUpRightWithTimeout();

                // If the philosopher fails to pick up the right chopstick, it releases the left and retries pickup after a short wait.
                while (!successfulPickup) {
                    putDownLeftChopstick();
                    int random = randomValue(1, 25); //random wait time between 1 and 25ms
                    sleep(random);
                    pickUpLeftChopstick();
                    successfulPickup = pickUpRightWithTimeout();
                }

                // Once both chopsticks are acquired, the philosopher eats.
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
            }
        }

        boolean pickUpRightWithTimeout() {
            // Attempts to pick up the right chopstick with a timeout.
            boolean successfulPickup = rightTimeoutChopstick.pickUpRight(this);

            if (successfulPickup) {
                Log("[PUR]", virtualClock.getTime());
            }

            return successfulPickup;
        }
    }
    </code></pre>
    <p>
        <b>Chopstick class:</b>
        We introduce a timeout for the pickup of the right chopstick. When the timeout is reached we abort the pickup and return false.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
    class TimeoutChopstick extends Chopstick {

        int timeout;

        TimeoutChopstick(int id, int timeout) {
            super(id);
            this.timeout = timeout;
        }

        synchronized boolean pickUpRight(Philosopher philosopher) {
            // Tracks time to ensure the philosopher does not wait indefinitely.
            long startTime = currentTime();
            long remainingTime = timeout;

            // Waits until the chopstick is available or the timeout expires.
            while (!isAvailable) {
                if (remainingTime <= 0) {
                    return false;
                }

                wait(remainingTime);
                remainingTime = timeout - (currentTime() - startTime);
            }

            // If the chopstick becomes available, it is marked as taken.
            isAvailable = false;
            return true;
        }
    }
    </code></pre>
    <h3>Timeout Solution Evaluation </h3>
    <p>
        Now let us evaluate the Timeout Algorithm according to the key-challenges:
    </p>
    <table class="styled-table">
        <thead>
        <tr>
            <th>Aspect</th>
            <th>Description</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><b>Deadlocks</b></td>
            <td>With this approach, we prevent deadlocks by avoiding the Hold-and-Wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation is unlikely, but philosophers are not guaranteed to be able to eat due to the timeout.
                Depending on the chosen timeout, starvation likeliness can change. (Very low timeout values increase the risk)
                Due to these issues, we can not guarantee any fairness to the philosophers using this solution.
            </td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>The concurrency potential of the system is limited.
                The degree of concurrency we achieve is practically identical to the naive implementation,
                as we ideally only intervene when a deadlock has occurred.
                In the case of a timeout, there is a kind of "soft reset" and we start the pickup process anew,
                lowering concurrency.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>Minimal changes are required, and the concept is rather easy to understand/implement.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>The approach is highly scalable, and we essentially do not need any information on the system for this approach to work. Not a giant performance overhead, but total eat time might be reduced when frequent timeouts occur and philosophers have to re-attempt picking up.</td>
        </tr>
        </tbody>
    </table>

    <p>
        A major limitation of this approach is that when a timeout occurs, philosophers must wait for a certain time to
        re-attempt their pickup. When the timeout is chosen very low, frequent re-attempts might happen.
        On the contrary if we choose high values for the timeout we might take a very long to realize a deadlock has occurred, harming concurrency/ system progress.
        The waiting time has to be reasonably chosen and randomized, to prevent recurring deadlocks.
        If we choose fixed values, for example 10ms, it might happen that the philosophers all try to pick up their left
        chopsticks again and again, just with a delay of 10ms. This would (arguably) result in an even worse condition: A livelock (Consuming resources without system progress)
    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TIMEOUT" class="button">Timeout Simulation</a>
    <a href="../animation/?algorithm=TIMEOUT" class="button">Timeout Animation</a>
</div>
</body>
</html>
