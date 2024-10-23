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
</head>
<body>
<h2>Chandy-Misra Solution</h2>
<div class="description">
    <img src="../pictures/chandymisra.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The classic Dining Philosophers Problem does not allow communication between philosophers.
        For the following solution we want to ignore this and explore an approach that depends on messages.
        In 1984 Chandy and Misra presented a highly scalable solution,
        that also enables philosophers to contend for an arbitrary amount of resources.
        The solution is based on status flags of the chopsticks (clean, dirty), and the transfer of ownership.
        Deadlocks are prevented because philosophers always have to hand out "dirty" chopsticks when requested,
        and they have to "own" both to proceed picking up chopsticks and eating, this lets us avoid the circular wait condition.
        Here are the crucial details of the algorithm:
    </p>
    <ul>
        <li>For every pair of philosophers contending for a resource, create a fork and give it to the philosopher with the lower ID (n for agent Pn). Each fork can either be dirty or clean. Initially, all forks are dirty.</li>
        <li>When a philosopher wants to use a set of resources (i.e., eat), said philosopher must obtain the forks from his contending neighbors. For all such forks the philosopher does not have, he sends a request message.</li>
        <li>When a philosopher with a fork receives a request message, he keeps the fork if it is clean, but give it up when it is dirty. If the philosopher sends the fork over, he cleans the fork before doing so.</li>
        <li>After a philosopher is done eating, all his forks become dirty. If another philosopher had previously requested one of the forks, the philosopher that has just finished eating cleans the fork and sends it.</li>
    </ul>
    <img src="../pictures/chandymisra_init.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Additional properties are:
        The initialization of ownership is asymmetric (the first philosopher owns two chopsticks, the last one none).
        Philosophers should always hand out their "dirty" chopsticks, but only if requested
        When philosophers hand out chopsticks they should by-default receive it back at some later point.
        In principle philosophers have to hand out their chopstick
        As previously mentioned we could expand the algorithm to deal with multiple resources,
        however, for convenience we will focus on the classic problem where they only compete with their adjacent neighbors.
    </p>

    <p>
        <b>Philosopher class: </b>
        To implement theChandy-Misra Solution
    </p>
    <pre><code>
        [PseudoCode]

        class ChandyMisraPhilosopher extends Philosopher {

            ChandyMisraChopstick leftChopstick;
            ChandyMisraChopstick rightChopstick;
            ChandyMisraPhilosopher leftNeighbor;
            ChandyMisraPhilosopher rightNeighbor;
            boolean goingToEatRequest = false;  // indicates if the philosopher is requesting to eat

            // Constructor assigns specific chopsticks and neighbors.
            ChandyMisraPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
                this.leftChopstick = (ChandyMisraChopstick) leftChopstick;
                this.rightChopstick = (ChandyMisraChopstick) rightChopstick;
            }

            @Override
            void run() {
                while (!terminated()) {
                    checkForRequests();  // handle any pending chopstick requests from neighbors.
                    think();
                    checkForRequests();  // ensure any requests are managed before trying to eat.
                    requestChopsticksIfNecessary();  // attempt to acquire both chopsticks.
                    eating();
                    checkForRequests();  //ensure release of chopsticks after eating.
                }
            }

            void requestChopsticksIfNecessary() {
                goingToEatRequest = true;  // signal intention to eat, affecting chopstick transfer logic.
                waitForChopstick(leftChopstick);
                waitForChopstick(rightChopstick);
                goingToEatRequest = false;  // reset the request after obtaining chopsticks.
            }

            void waitForChopstick(ChandyMisraChopstick chopstick) {
                synchronized (chopstick) {
                    // Wait until this philosopher owns the chopstick.
                    while (chopstick.owner != this) {
                        checkForRequests();  // handle potential requests for this chopstick while waiting.
                        chopstick.wait(10);  // re-check requests periodically.
                    }
                }
            }

            void checkForRequests() {
                // respond to any requests for the left or right chopstick from neighbors.
                giveUpChopstickIfRequested(leftChopstick, leftNeighbor);
                giveUpChopstickIfRequested(rightChopstick, rightNeighbor);
            }

            void giveUpChopstickIfRequested(ChandyMisraChopstick chopstick, ChandyMisraPhilosopher receiver) {
                synchronized (chopstick) {
                    // give up the chopstick if the neighbor has requested to eat, it's dirty, and this philosopher holds it.
                    if (receiver.goingToEatRequest && !chopstick.isClean && chopstick.owner == this) {
                        chopstick.isClean = true;  // mark the chopstick as clean before transferring ownership.
                        chopstick.owner = receiver;  // transfer chopstick ownership to the requesting philosopher.
                        chopstick.notifyAll();  // notify the waiting philosopher that they now own the chopstick.
                    }
                }
            }

            void eating() {
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                rightChopstick.isClean = false;  // mark chopsticks as dirty after eating.
                leftChopstick.isClean = false;
                putDownLeftChopstick();
                putDownRightChopstick();
            }

            @Override
            void think() {
                long remainingTime = calculateDuration();

                // Think in small intervals to allow for checking requests during longer thinking times.
                while (remainingTime > 0) {
                    long sleepTime = min(remainingTime, 10);
                    sleep(sleepTime);
                    checkForRequests();  // handle chopstick requests while thinking.
                    remainingTime -= sleepTime;
                }

                sbLog(id, Events.THINK);
                lastAction = Events.THINK;
            }

            void setNeighbors(ChandyMisraPhilosopher leftNeighbor, ChandyMisraPhilosopher rightNeighbor) {
                // Establish references to neighboring philosophers for handling chopstick requests.
                this.leftNeighbor = leftNeighbor;
                this.rightNeighbor = rightNeighbor;
            }
        }

    </code></pre>
    <p>
        <b>Chopstick class: </b>
    </p>
    <pre><code>
        [PseudoCode]
        class ChandyMisraChopstick extends Chopstick {

            ChandyMisraPhilosopher owner;
            boolean isClean = false;

            ChandyMisraChopstick(int id) {
                super(id);
            }

            void setOwner(ChandyMisraPhilosopher owner) {
                this.owner = owner;
            }
        }
    </code></pre>#

    <h3>Chandy Misra Solution Evaluation </h3>

    <p>
        Now let us evaluate the Chandy-Misra Algorithm according to the key challenges:
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
            <td>We avoid deadlocks due to the distributed nature of the algorithm. Philosophers that own a chopstick have to hand over ownership, unless they absolutely need it. This breaks the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation</b></td>
            <td>We avoid starvation because philosophers must hand over ownership to the requesting neighbor eventually. (Either during their own waiting/thinking phase or when they process requests after eating.)</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>We only guarantee that philosophers will get a chance to eat at some point, but do not specifically enhance fairness with this approach.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>The distributed nature of this algorithm yields a high degree of concurrency.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The distributed nature and the need to manage the state of each fork (clean or dirty) and the request communication between philosophers lead to a more challenging implementation.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a negligible overhead with the logic introduced in this solution. Due to its inherently distributed nature, the approach is highly scalable and can be used in large systems.</td>
        </tr>
        </tbody>
    </table>


    <p>
        This approach is very versatile and can be interpreted in many different ways.
        The implementation above is just one way the key concepts of dirty/ clean chopsticks and request messages can be implemented.

        It is harder to find a clear and correct explanation to this approach online, compared to many other of the discussed approaches.
        I have found many chandy misra "solutions" online that misunderstand basic concepts of this solution or are
        flat out incorrect interpretations.
        For example one implementation I found simply forgot that philosophers have to request their chopstick back
        after they handed it to its neighbour, and would just start thinking again.
        In such cases it is more useful to consult the original source, i.e. literature written by chandy and misra or
        works expanding on their concepts.
    </p>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>

    <a href="../simulation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Simulation</a>
    <a href="../animation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Animation</a>





</div>

</body>
</html>
