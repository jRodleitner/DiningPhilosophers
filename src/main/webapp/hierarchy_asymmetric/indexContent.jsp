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

        .separator {
            width: 100%;
            height: 4px;
            background: linear-gradient(to right,
            transparent 0%,
            #ddd 10%,
            #ddd 90%,
            transparent 100%);
            border-radius: 10px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
<h2>Resource Hierarchy Solution</h2>
<div class="description">
    <img src="../pictures/resource.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>

    <p>
        The resource hierarchy solution to the Dining Philosophers Problem works by assigning a unique id to the
        chopsticks (resources), numbered from 0 to (n−1).
        Philosophers always attempt to pick up the lower-numbered chopstick first before picking up the higher-numbered
        one.
        This forces all philosophers, except one, to act "left-handed" (they pick up the left chopstick first).
        One philosopher (the last one in the circle) will act as the "right-handed," picking up their right chopstick
        first.
        At least one philosopher is guaranteed be able to proceed.

    <p>
        <b>Philosopher class:</b>
        To implement the Resource Hierarchy solution, only the run function in the philosopher class has to be modified:
        If the left chopstick id is lower pick up left first, if the right chopstick id is lower, pick up the right
        first.
    </p>
    <pre><code>
        [PseudoCode]

        class HierarchyPhilosopher extends Philosopher {
            //pickup chopstick with lower id first

            HierarchyPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
            }

        @Override
            run() {
                while (!terminate()) {
                    think();

                    //pick up chopstick with lower id first
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
        }
    </code></pre>

    <h3>Hierarchy Solution Evaluation</h3>
    <img src="../pictures/precedence_hierarchy.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Now let us evaluate the Algorithm according to the key challenges we face for designing a dining
        philosophers solution:
    </p>
    <ul>
        <li>Deadlocks: The Resource Hierarchy Solution effectively prevents deadlocks via avoiding the circular-wait condition,
            as defined by Coffman.
        </li>
        <li>Starvation: We do not guarantee that a philosopher will get a chance to eat, thus Starvation is possible.
        </li>
        <li>Fairness: Resource Hierarchy fails at providing fairness to the system, as no such measures are taken.</li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not blocked from eating by this
            approach.
            Theoretically this approach should provide us with a little higher concurrency, since the longest path in
            the precedence graph is now one shorter.
            However, in practice this advantage is not noticeable when running the simulations with 5 or fewer
            philosophers.
        </li>
        <li>Implementation: The changes required to implement are straightforward.</li>
        <li>Performance: Next to no overhead with the newly introduced logic. Theoretically highly scalable but the
            strict ordering of resources necessitates a static environment during the execution.
        </li>
        .
    </ul>

    <p>
        The practicality of this approach in the real world is partly questionable, as full knowledge about the system
        is necessary in advance to properly initialize the hierarchy.
        This is often hard to achieve in real-world systems.
        Dynamic changes are also hard to account for: What if a philosopher joins the table? We would essentially need
        to halt execution and re-initialize the whole table.

    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>

    <a href="../simulation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Simulation</a>
    <a href="../animation/?algorithm=HIERARCHY" class="button">Resource Hierarchy Animation</a>

    <div class="separator"></div>

    <h2>Asymmetric Solution</h2>

    <img src="../pictures/asymmetric.svg" alt="Dining Philosophers Problem" width="400" height="350"> <br>
    <p>
        The Asymmetric Solution takes a slightly different approach by assigning an order to the philosophers instead of
        the chopsticks.
        Philosophers with an even number pick up the left chopstick first, while those with an odd number pick up the
        right chopstick first.

    </p>
    <br>
    <p>
        <b>Philosopher class:</b>
        To implement the Asymmetric solution, we again only have to modify the run function in the philosopher class.
        We assign Philosophers with even id as left-handed, philosophers with odd id as right-handed.
    </p>
    <pre><code>
        [PseudoCode]

        public class AsymmetricPhilosopher extends Philosopher {

            public AsymmetricPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
            }

            @Override
            run() {
                //philosophers with even id pick up left first, philosophers with odd id pick up right first
                boolean even = id % 2 == 0;
                while (!terminated()) {
                    think();
                    if(even){
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
            }
        }
    </code></pre>

    <h3>Asymmetric Solution Evaluation</h3>
    <img src="../pictures/precedence_asymmetric.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Let us again evaluate the given Algorithm according to the key-challenges:
    </p>
    <ul>
        <li>Deadlocks: The Asymmetric Solution effectively prevents deadlocks by again avoiding the circular-wait
            condition.
        </li>
        <li>Starvation: We again do not guarantee that a philosopher will get a chance to eat, so Starvation is
            possible.
        </li>
        <li>Fairness: The Asymmetric Solution fails at providing fairness to the system, as no such measures are
            taken.
        </li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating.
            Additionally, we again should theoretically increase concurrency in our system, due to the now minimal paths
            in the precedence graph.
            Compared to the naive and the resource hierarchy implementation we now achieve a slightly higher
            concurrency, but again, this effect is only barely noticeable in simulation runs with 5 or fewer
            philosophers.
        </li>
        <li>Implementation: The changes required to implement this solution are quite minimal, again very
            straightforward and even a little more intuitive than Resource Hierarchy.
        </li>
        <li>Performance: No performance overhead due to the introduced logic. Theoretically highly scalable to arbitrary
            numbers of philosophers.
        </li>
    </ul>
    <p>
        The main drawback to this solution, however, is that it is very close natured to the dining philosophers
        problem,
        meaning that it is not applicable to cases, where processes share more than one resource with each other.
        Additionally, we still do not address Fairness and Starvation in our system.
    </p>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ASYMMETRIC" class="button">Asymmetric Simulation</a>
    <a href="../animation/?algorithm=ASYMMETRIC" class="button">Asymmetric Animation</a>
</div>
</body>
</html>
