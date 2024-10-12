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
<h2>Timeout Solution</h2>
<div class="description">
    <img src="../pictures/timeout_.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>
        The Timeout solution aims to prevent deadlocks by stopping philosophers from holding onto chopsticks indefinitely.
        A timeout is set before the simulation begins and is the same for all philosophers.
        They attempt to pick up the first chopstick as usual.
        If a philosopher reaches the timeout before acquiring both chopsticks, they put down the chopstick they initially picked up and return to thinking.
        This prevents deadlocks by avoiding the Hold-and-Wait condition as defined by Coffman.
        However, a major drawback of this approach is that when a timeout occurs, philosophers must start a new cycle instead of completing their eating phase in the current one.
    </p>

    <p>
        Modifications to the philosopher class:
        Philosophers start eating if the pickup of the right chopstick was successful, else they put down the left fork and start thinking again.
        For this purpose we create a Subclass and add the according changes.
    </p>
    <pre><code>
        [PseudoCode]

        class TimeoutPhilosopher extends Philosopher {
            TimeoutChopstick rightTimeoutChopstick;

            TimeoutPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
                rightTimeoutChopstick = (TimeoutChopstick)rightChopstick;
            }



            @Override
            void run() {
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

            boolean pickUpRightWithTimeout() {
                boolean succPickup = rightTimeoutChopstick.pickUpRight(this);
                if(succPickup) Log("[PUR]", VirtualClock.getTime());
                return succPickup;
            }

        }
    </code></pre>
    <p>
        Modifications to the Chopstick Class:
        We introduce a timeout for the pickup of the right chopstick.
        For this purpose we create a Subclass and add the according changes.
    </p>
    <pre><code>
        [PseudoCode]

        class TimeoutChopstick extends Chopstick {
            int timeout;

            TimeoutFork(int id, int timeout) {
                super(id);
                this.timeout = timeout;
            }


            public synchronized boolean pickUpRight(Philosopher philosopher) {
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

        }
    </code></pre>
    <p>
        Now let us evaluate the Timeout Algorithm according to the key-challenges
    </p>
    <ul>
        <li>Deadlocks: The Timeout Solution effectively prevents deadlocks</li>
        <li>Fairness: Fails at providing fairness to the system, as no such measures are taken.</li>
        <li>TODO::Concurrency: Concurrency of the system is given, since the philosophers are not actively blocked from eating by this approach.</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as both the Philosopher and Fork classes have to be modified. </li>
        <li>Performance: Not a giant overhead but total eat time might be reduced when frequent timeouts occur. </li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TIMEOUT" class="button">Timeout Simulation</a>
    <a href="../animation/?algorithm=TIMEOUT" class="button">Timeout Animation</a>
</div>
</body>
</html>
