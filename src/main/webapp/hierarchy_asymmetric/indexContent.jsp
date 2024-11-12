
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Token Solution</title>

    <style>
        .button {
            display: inline-block;
            color: white;
            background-color: #216477;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 10px;
            font-weight: bold;
            border: 4px solid #ccc;
            transition: background-color 0.4s ease, color 0.4s ease;
            margin: 5px 0;
        }

        .button:hover {
            background-color: #438699;
            color: #e0e0e0;
        }

        .description {
            line-height: 1.4;
            color: #333;
            padding: 14px;
            margin-bottom: 15px;
            max-width: 800px;
        }

        pre {
            background-color: #f5f5f5;
            border: 1px solid #ccc;
            padding: 5px;
            overflow-x: auto;
            white-space: nowrap;
            border-radius: 5px;
            font-family: "Courier New", Courier, monospace;
            max-width: 100%;
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
        With this approach, we guarantee that at least one philosopher can proceed.

    <p>
        <b>Philosopher class:</b>
        To implement the Resource Hierarchy solution, only the run function in the philosopher class has to be modified:
        If the left chopstick id is lower, pick up left first, if the right chopstick id is lower, pick up the right
        first.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class HierarchyPhilosopher extends Philosopher {

        HierarchyPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
            super(id, leftChopstick, rightChopstick);
        }

    @Override
        run() {
            while (!terminate()) {
                think();

                // pick up chopstick with lower id first
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
        Now let us evaluate the Resource Hierarchy algorithm according to the key challenges:
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
            <td>The Resource Hierarchy Solution effectively prevents deadlocks via avoiding the circular-wait condition, as defined by Coffman.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                The Resource Hierarchy Solution, in itself,
                does not guarantee that a philosopher will get a chance to eat.
                We combine this approach with the FIFO (First in First Out) enhanced chopstick pickup,
                guaranteeing that philosophers will eventually get the chance
                to acquire their chopsticks.
                This transforms Resource Hierarchy to a starvation-free solution,
                with guaranteed acquiring of chopsticks.
                We take no additional measures to enhance both eat-chance and time-fairness.
                They depend heavily on the chosen distribution.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>
                Concurrency of the system is enhanced, compared to the naive approach.
                Theoretically, this approach should provide us with improved concurrency,
                since the longest path in the precedence graph is now one shorter.
            </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement are straightforward.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>Next to no overhead with the newly introduced logic.
                Highly scalable, but the strict ordering of resources necessitates a highly static environment.
                The larger the number of philosophers, the less the benefit of only turning one philosopher "right-handed".</td>
        </tr>
        </tbody>
    </table>

    <p>
        Full knowledge about the system
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
        The Asymmetric Solution takes a slightly different approach
        by assigning a specific order to the philosophers rather than to the chopsticks.
        Philosophers with an even number pick up the left chopstick first, while those with an odd number pick up the
        right chopstick first.

    </p>
    <br>
    <p>
        <b>Philosopher class:</b>
        To implement the Asymmetric solution, we again only have to modify the run function in the philosopher class.
        We assign philosophers with even id as left-handed, philosophers with odd id as right-handed.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class AsymmetricPhilosopher extends Philosopher {

        AsymmetricPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
            super(id, leftChopstick, rightChopstick);
        }

        @Override
        run() {
            // philosophers with even id pick up left first, philosophers with odd id pick up right first
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
        Let us again evaluate the given Algorithm according to the key challenges:
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
            <td>The Asymmetric Solution effectively prevents deadlocks by again avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Again, the resource Asymmetric Solution does not guarantee that a philosopher will get a chance to eat by itself.
                We enhance this solution, using the FIFO-enabled pickup of chopsticks to transform it to a starvation-free solution,
                with a guarantee of eventual pickup.
                We take no additional measures to enhance both eat-chance and time-fairness. They depend heavily on the chosen distribution.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Concurrency of the system is further improved on.
                We increase concurrency in our system due to the now minimal paths in the precedence graph.
                Compared to the naive and the Resource Hierarchy implementation, we achieve better concurrency.
                Note that this effect is often barely noticeable
                in simulation runs with five or four philosophers and low simulation times.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are quite minimal, again very straightforward and even a little more intuitive than Resource Hierarchy.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>
                No performance overhead due to the introduced logic. Highly scalable to arbitrary numbers of philosophers.
                This approach is also more applicable to dynamic situations.
            </td>
        </tr>
        </tbody>
    </table>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ASYMMETRIC" class="button">Asymmetric Simulation</a>
    <a href="../animation/?algorithm=ASYMMETRIC" class="button">Asymmetric Animation</a>
</div>

<a href="../timeout/" class="button">➡ Next: Timeout Solution ➡</a>


</body>
</html>
