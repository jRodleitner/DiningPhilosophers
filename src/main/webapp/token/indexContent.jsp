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
            border: 4px solid #ccc;
            text-decoration: none; /* Removes the underline from links */
            padding: 10px 20px; /* Adds padding to make the link look like a button */
            border-radius: 10px; /* Rounds the corners of the button */
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
<h2>Global Token Solution</h2>
<div class="description">

    <img src="../pictures/token.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Token Solution is surely one of the most intuitive solutions to avoid deadlocks.
        At the start of the simulation a token is handed to the first philosopher, who holds on to it until the eating
        is finished.
        After which the token is handed on counter-clock wise to the adjacent philosopher, thus only one philosopher can
        eat at a time.
    </p>

    <p>
        We introduce a Global Token class:
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    public class GlobalToken {

        TokenPhilosopher philosopher;

        public GlobalToken(TokenPhilosopher philosopher){
            this.philosopher = philosopher;
        }


        protected synchronized void passToken(){
            philosopher.rightPhilosopher.acceptToken(this);
            philosopher.token = null;
            philosopher = philosopher.rightPhilosopher;
        }


    }

    </code></pre>
    <p>
        <b>Philosopher class:</b>
        We modify the Philosopher class and introduce a lock functionality.
        Philosophers will wait on the "lock" object until notified that a token has been passed to them.
        After they are finished they pass on the token.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
    public class TokenPhilosopher extends Philosopher {
        // Reference to the philosopher to the right of this one, used for passing the token.
        TokenPhilosopher rightPhilosopher = null;

        // The global token that controls the ability to access the chopsticks.
        volatile GlobalToken token;

        // Object used for waiting for the passing of a token
        final Object tokenLock = new Object();

        TokenPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick) {
            super(id, leftChopstick, rightChopstick);
        }

        void setToken(GlobalToken token) {
            this.token = token;
        }

        // Method to set the philosopher to the right of this one for token passing.
        void setRightPhilosopher(TokenPhilosopher rightPhilosopher) {
            this.rightPhilosopher = rightPhilosopher;
        }

        // Method to accept a token when it is passed from another philosopher.
        void acceptToken(GlobalToken token) {
            synchronized (tokenLock) {
                this.token = token; // Update the local reference to the token.
                tokenLock.notify(); // Notify the waiting philosopher that the token is now available.
            }
        }

        @Override
        public void run() {
            while (!terminated()) {
                think();

                // Wait until this philosopher has the token.
                synchronized (tokenLock) {
                    while (token == null) {
                        tokenLock.wait(); // Wait for the token to become available.
                    }
                }

                // Once the token is acquired, the philosopher can attempt to eat.
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();

                putDownLeftChopstick();
                putDownRightChopstick();

                // Pass the token to the next philosopher.
                token.passToken();
            }
        }
    }
    </code></pre>
    <p>
        <b>Table class:</b>
        We initialize the Philosophers and give a token to the first philosopher:
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    List chopsticks;
    List philosophers;

    for (int i = 0; i < nrPhilosophers; i++) {
        chopsticks.add(new Chopstick(i)); // Adds a chopstick for each philosopher
    }

    for (int i = 0; i < nrPhilosophers; i++) {

        TokenPhilosopher philosopher = new TokenPhilosopher(
            i,
            chopsticks.get(i), // Left chopstick
            chopsticks.get((i + 1) % nrPhilosophers) // Right chopstick
        );
        philosophers.add(philosopher);
    }

    // Set the reference to the right-hand neighbor for each philosopher
    for (int i = 0; i < nrPhilosophers; i++) {
        TokenPhilosopher philosopher = philosophers.get(i);
        philosopher.setRightPhilosopher(philosophers.get((i + 1) % nrPhilosophers));
    }

    // Select the initial philosopher to start with the token
    TokenPhilosopher initialPhilosopher = philosophers.getFirst();

    // Create the global token and assign it to the initial philosopher
    GlobalToken token = new GlobalToken(initialPhilosopher);
    initialPhilosopher.setToken(token); // The initial philosopher now holds the token
    </code></pre>

    <h3>Global Token Solution Evaluation</h3>
    <p>
        Now Let us evaluate the Global Token solution according to the key-challenges
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
            <td>We effectively prevent deadlocks by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation</b></td>
            <td>No starvation as each philosopher will eventually get the chance to eat.</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>Fair eat-chances, as each philosopher gets a turn at eating once every round. Eat-time fairness depends heavily on the chosen distribution.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>No concurrency since only one philosopher can eat at a time.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The implementation is rather simple and easy to understand.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>The introduced logic's overhead is minimal and managed in a distributed way. No central entity, and thus highly scalable.</td>
        </tr>
        </tbody>
    </table>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=GLOBALTOKEN" class="button">Global Simulation</a>
    <a href="../animation/?algorithm=GLOBALTOKEN" class="button">Global Animation</a>


    <div class="separator"></div>


    <h2>Multiple Token Solution</h2>
    <img src="../pictures/multiple-token_questionmanrk.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Global Token Solution is hardly ideal. It does prevent deadlocks and provides fairness to the system,
        but it essentially eliminates Concurrency.
        The next idea would be to introduce multiple tokens into the system. We know that the maximum concurrency in our
        system under ideal conditions to [n/2] for even n and &lfloor;n/2&rfloor; for uneven n.
        Two adjacent philosopher can never eat at the same time, so the idea is to just hand
        every other philosopher a token and prevent the token from being passed on to the next philosopher if it holds a
        token.
        If we have an uneven number of philosophers the last one is skipped automatically (We do not hand them a token).
        We pass the token only after the other philosopher has passed on its token. In theory, we can reach
        maximum concurrency of [n/2]/ &lfloor;n/2&rfloor;, if there are few or no outliers for the execution times of
        eating and if eating and thinking times are similarly distributed.
    </p>
    <img src="../pictures/multipletoken_working.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <p>
        We only modify the Token class, for cases where the next philosopher still holds on to a token.
        This is not likely to happen, because the philosophers cannot eat until the adjacent philosopher is done eating,
        and thus cannot pass on the token.
        We include this change just for completeness.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class Token {
        int id;
        TokenPhilosopher philosopher;
        public Token(int id, TokenPhilosopher philosopher){
            this.id = id;
            this.philosopher = philosopher;
        }


        synchronized void passToken() {
            while (philosopher.rightPhilosopher.token != null){
                Thread.sleep(10);
            }
            philosopher.rightPhilosopher.acceptToken(this);
            philosopher.token = null;
            philosopher = philosopher.rightPhilosopher;
        }
    }

    </code></pre>
    <p>
        <b>Table class:</b>
        We hand every other philosopher a token, for example like this:
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    List chopsticks;
    List philosophers;

    for (int i = 0; i < nrPhilosophers; i++) {
        chopsticks.add(new Chopstick(i)); // Create a new chopstick with ID 'i' and add it to the list.
    }


    for (int i = 0; i < nrPhilosophers; i++) {
        TokenPhilosopher philosopher = new TokenPhilosopher(
            i,
            chopsticks.get(i), // Left chopstick
            chopsticks.get((i + 1) % nrPhilosophers) // Right chopstick
        );
        philosophers.add(philosopher);
    }

    // Set reference to the right-hand neighbor for each philosopher.
    for (int i = 0; i < nrPhilosophers; i++) {
        TokenPhilosopher philosopher = philosophers.get(i);
        philosopher.setRightPhilosopher(philosophers.get((i + 1) % nrPhilosophers));
    }

    // Assign tokens to every other philosopher.
    for (int i = 0; i < nrPhilosophers - 1; i += 2) {
        TokenPhilosopher philosopher = philosophers.get(i);
        philosopher.setToken(new Token(i, philosopher));
    }

    </code></pre>
    <h3>Multiple Token Solution Evaluation</h3>
    <p>
        Now Let us evaluate the Multiple Token solution according to the key-challenges
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
            <td>We again prevent deadlocks by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation</b></td>
            <td>No starvation as each philosopher will eventually get the chance to eat.</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>Fair eat-chances, as each philosopher repeatedly earns permission when they receive a token. Potentially unfair eat-times, depending on the chosen distributions of eat- and think-times.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>Potential high concurrency, as multiple tokens are passed around permitting ⌊n/2⌋ philosophers to eat at a time.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes that need to be made are a little more extensive than, for example, the asymmetric solution, but the logic is rather easily expanded on, using the Global Token Solution.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>Again, there is a negligible performance overhead utilizing this additional logic. There is no central entity that philosophers have to go through, so there is high scalability present in this approach.</td>
        </tr>
        </tbody>
    </table>


    <p>
        Although this solution shows promising results (potential high concurrency, eat chance fairness and no deadlocks) and is clearly highly scalable in distributed environments
        (if we know the number of philosophers, that is and none drop out or "die") there are still some major issues with this approach.
        First, congestion could occur when a philosopher eats for a very long time. In such situations the philosophers
        are prevented from passing the token as long as the "long-eating" philosopher still holds its token.
        This means that this approach's improvements on concurrency only work properly if we assume similarly distributed eat times.
        Secondly, we assume that philosophers will want to eat when they receive a token, however if very long thinking times occur they will hold onto the token,
        until they finished eating, again leading to possible congestion in such cases.
        In total for this solution to perform optimally we have to assume similar distributions in thinking and eating times,
        to not result in unnecessary long blocked times for other philosophers.
        We could improve this algorithm a little by allowing "long thinking" philosophers to pass the token to the next philosopher.
        For this approach, however we would have to utilize a purposeful heuristic to define what a "long thinking time" is.
        If the chosen heuristic is not adequate we could end up passing a philosopher multiple times, and when it tries to eat it might have to wait to receive a token.
        This is hard to manage and highly dependent on the simulation-settings.

    </p>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Simulation</a>
    <a href="../animation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Animation</a>
</div>
</body>
</html>
