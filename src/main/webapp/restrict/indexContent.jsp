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
<h2>Restrict Solution</h2>
<div class="description">
    <p>The Restrict Solution </p>
    <img src="../pictures/restrict.svg" alt="Dining Philosophers Problem" width="400" height="350">#
    <p>
        One effective method to prevent deadlocks in the dining philosophers problem is to limit the number of
        philosophers allowed to attempt eating at the same time.
        Usually this approach would "remove a seat", however this would prevent one of the philosophers from eating at
        all, so we introduce kind of a reverse token system.
        For a group of n philosophers, we restrict this number to n-1, meaning only n-1 philosophers can try to pick up
        their chopsticks simultaneously.
        To not block one philosopher permanently, we pass this restriction around the philosophers.
        Whenever a philosopher finishes picking up their chopsticks, the restriction is passed to the next philosopher
        (continually passed around in a circle, during the course of the simulation).

    </p>

    <p>
        <b>Restrict class: </b>This class keeps track of the current id that determines which philosopher is currently
        restricted from picking up a chopstick. It utilizes a counter (restrict) that cycles through all the philosophers.
        The updateRestricted method advances this restriction to the next philosopher.
    </p>
    <pre><code>
        [PseudoCode]

        class Restrict {

            int restrict;
            int numberOfPhilosophers;

            Restrict(int numberOfPhilosophers) {
                restrict = 0;
                this.numberOfPhilosophers = numberOfPhilosophers;
            }

            synchronized void updateRestricted() {
                // Cycles the restriction to the next philosopher in sequence.
                restrict = (restrict + 1) % numberOfPhilosophers;
            }

            synchronized int getRestricted() {
                // Returns the current restricted philosopher's ID.
                return restrict;
            }
        }
    </code></pre>
    <p>
        <b>Chopstick class:</b>
        The updated class allows philosophers to pick up the chopstick only if they are available and the philosopher is not
        the one currently restricted.
        If the philosopher attempting to pick up the chopstick is restricted, it will wait until the restriction is
        lifted. Additionally, if the philosopher successfully picks up their right chopstick, the restriction is updated
        to apply to the next philosopher.
    </p>
    <pre><code>
        [PseudoCode]

        class RestrictChopstick extends Chopstick {

            Restrict restrict;

            RestrictChopstick(int id, Restrict restrict) {
                super(id);
                this.restrict = restrict;
            }

            @Override
            synchronized boolean pickUp(Philosopher philosopher) {
                // Waits until the chopstick is available and the philosopher is not restricted.
                while (!isAvailable || philosopher.getPhId() == restrict.getRestricted()) {
                    wait();
                }

                // Updates the restriction if this chopstick is the philosopher's right chopstick.
                if (this == philosopher.getRightChopstick()) {
                    restrict.updateRestricted();
                }

                // Marks the chopstick as taken.
                isAvailable = false;
                return true;
            }
        }
    </code></pre>

    <h3>Restrict Solution Evaluation</h3>

    <p>Now let us evaluate the Restrict solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: By limiting the number of philosophers to (n-1), we eliminate the possibility of the circular
            wait condition, as defined by Coffman.
        </li>
        <li>Starvation: We do not guarantee that a philosopher will get the chance to eat, so starvation is possible.
            However, we at least do not starve one philosopher purposefully, as in some other Restrict approaches, found online or in the literature.</li>
        <li>Fairness: We do not provide any fairness to the system using this solution.</li>
        <li>Concurrency: We do not explicitly prevent concurrency but in many situations we block a philosopher from eating,
            when it would be possible. The overall act of blocking one philosopher from eating frequently results in lower performance than the naive implementation.
            This is simply due to the fact, that we "blindly" block philosophers one after another, irrespective of their current ability to eat.
        </li>
        <li>Implementation: The changes required to implement this solution are simple.</li>
        <li>
            Performance: For this approach to work we need to know the number of philosophers at the table, so in dynamic situations (philosophers can leave/ come to the table), careful handling would be necessary.
            We do not get great scalability, as the Restrict entity has to be accessed frequently.
            This could lead to a performance overhead in bigger systems.
        </li>
    </ul>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=RESTRICT" class="button">Restrict Simulation</a>
    <a href="../animation/?algorithm=RESTRICT" class="button">Restrict Animation</a>









<h2>Restrict Waiter Solution</h2>

<p>
    There is a naive version of the waiter solution, in which we track the number of forks on the table.
    The waiter always provides the chopsticks when requested by a philosopher,
    unless there are less than two chopsticks remaining on the table.
    In this case we let the philosopher wait until another philosopher is done eating, and two forks are again on the table.
    This is very similar to the above restrict solution, but we now block philosophers from picking up by chance.
</p>


<p>

</p>
<pre><code>
        [Pseudocode]

    </code></pre>
<p>

</p>
<pre><code>
        [Pseudocode]

    </code></pre>
<p>Now let us evaluate the Classic Waiter approach based on the key-challenges:</p>
<ul>
    <li>Deadlocks: Prevents deadlocks</li>
    <li>Fairness: We ...</li>
    <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
    <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
        needed.
    </li>
    <li>Performance:</li>
</ul>
<p>
    You can find the respective Simulation and Animation pages here:
</p>
<a href="../simulation/?algorithm=ATOMICWAITER" class="button">Classic Waiter Simulation</a>
<a href="../animation/?algorithm=ATOMICWAITER" class="button">Classic Waiter Animation</a>

</div>
</body>
</html>
