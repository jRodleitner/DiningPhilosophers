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
<h2>Global Token Solution</h2>
<div  class="description">

    <img src="../pictures/token.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Token Solution is surely one of the most intuitive solutions to avoid deadlocks.
        At the start of the simulation a token is handed to the first philosopher, who holds on to it until the eating is finished.
        After which the token is handed on counter-clock wise to the adjacent philosopher, thus only one philosopher can eat at a time.
        This effectively prevenChopstickeadlocks by avoiding the circular wait condition as defined by Coffman.
    </p>

    <p>
        We introduce a Global Token class:
    </p>
    <pre><code>
        [Pseudocode]

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
        We modify the Philosopher class and introduce a lock functionality.
        Philosophers will wait on their respective object until notified that a token has been passed to them.
        After they are finished they pass on the token.

    </p>
    <pre><code>
        [Pseudocode]

        public class TokenPhilosopher extends Philosopher {
            TokenPhilosopher rightPhilosopher = null;
            volatile GlobalToken token;
            final Object tokenLock = new Object();

            TokenPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
            }

            void setToken (GlobalToken token){
                this.token = token;
            }

            void setRightPhilosopher(TokenPhilosopher rightPhilosopher){
                this.rightPhilosopher = rightPhilosopher;
            }

            void acceptToken(GlobalToken token) {
                synchronized (tokenLock) {
                    this.token = token;
                    tokenLock.notify();
                }
            }

            public void run() {
                while (!terminated()) {
                    think();
                    synchronized (tokenLock) {
                        while (token == null) {
                            tokenLock.wait();
                        }
                    }
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                    token.passToken();
                    }
            }
        }
    </code></pre>
    <p>
        We initialize the Philosophers like this:
    </p>
    <pre><code>
        [Pseudocode]
        List philosophers;
        List chopsticks;

        for (int i = 0; i < nrPhilosophers; i++) {
            chopsticks.add(new Chopstick(i));
        }
        for (int i = 0; i < nrPhilosophers; i++) {
            TokenPhilosopher philosopher = new TokenPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers));
            philosophers.add(philosopher);
        }

        for (int i = 0; i < nrPhilosophers; i++) {
            TokenPhilosopher philosopher =  philosophers.get(i);
            philosopher.setRightPhilosopher( philosophers.get((i + 1) % nrPhilosophers));
        }
        TokenPhilosopher initialPhilosopher = philosophers.getFirst();
        GlobalToken token = new GlobalToken( initialPhilosopher);
        initialPhilosopher.setToken(token);
    </code></pre>

    <p>
        Now Let us evaluate the Global Token solution according to the key-challenges
    </p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fair, as each philosopher gets a turn at eating </li>
        <li>Concurrency: No concurrency since only one philosopher can eat.</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as... </li>
        <li>Performance: ... </li>
    </ul>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=GLOBALTOKEN" class="button">Global Simulation</a>
    <a href="../animation/?algorithm=GLOBALTOKEN" class="button">Global Animation</a>

    <h2>Multiple Token Solution</h2>
    <img src="../pictures/multiple-token_questionmanrk.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Global Token Solution is hardly ideal. It does prevent deadlocks and provides fairness to the system,
        but it essentially eliminates Concurrency.
        The next idea would be to introduce multiple tokens into the system. We know that the maximum concurrency in our system under ideal conditions to [n/2] for even n and  &lfloor;n/2&rfloor; for uneven n.
        Two adjacent philosopher can never eat at the same time, so the idea is to just hand
        every other philosopher a token and prevent the token from being passed on to the next philosopher if it holds a token.
        If we have an uneven number of philosophers the last one is skipped automatically.
        We pass the token only after the other philosopher has passed on its token. In theory we can reach
        maximum concurrency of [n/2]/ &lfloor;n/2&rfloor;, if there are few or no outliers for the execution times of eating and if eating and thinking times are similarly distributed.
    </p>
    <img src="../pictures/multipletoken_working.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <p>
        We only modify the Token class, for cases where the next philosopher still holds on to a token.
        This is not likely to happen, because the philosophers cannot eat until the adjacent philosopher is done eating, and thus cannot pass on the token.
        We include this change just for completeness.
    </p>
    <pre><code>
        [Pseudocode]

        class Token {
            int id;
            TokenPhilosopher philosopher;
            public Token(int id, TokenPhilosopher philosopher){
                this.id = id;
                this.philosopher = philosopher;
            }


            synchronized void passToken() {
                while (philosopher.rightPhilosopher.token != null){ //wait for a short while, until next philosopher handed on token
                    Thread.sleep(10);
                }
                philosopher.rightPhilosopher.acceptToken(this);
                philosopher.token = null;
                philosopher = philosopher.rightPhilosopher;
            }
        }

    </code></pre>
    <p>
        We hand every other philosopher a token, for example like this:
    </p>
    <pre><code>
        [Pseudocode]

        List philosophers;
        List chopsticks;

        for (int i = 0; i < nrPhilosophers; i++) {
            chopsticks.add(new Chopstick(i));
        }
        for (int i = 0; i < nrPhilosophers; i++) {
            TokenPhilosopher philosopher = new TokenPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers));
            philosophers.add(philosopher);
        }

        for (int i = 0; i < nrPhilosophers; i++) {
            TokenPhilosopher philosopher =  philosophers.get(i);
            philosopher.setRightPhilosopher( philosophers.get((i + 1) % nrPhilosophers));
        }
        for (int i = 0; i < nrPhilosophers - 1; i += 2) {
            TokenPhilosopher philosopher = philosophers.get(i);
            philosopher.setToken(new Token(i, philosopher));
        }

    </code></pre>

    <p>
        Now Let us evaluate the Multiple Token solution according to the key-challenges
    </p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: Fair, as each philosopher gets a turn at eating </li>
        <li>Concurrency: Concurrent, as multiple tokens are passed around permitting [n/2]/ &lfloor;n/2&rfloor; at a time to eat</li>
        <li>Implementation: The changes that need to be made are a little more extensive, as... </li>
        <li>TODO::Performance: ... </li>
    </ul>

<p>
    You can find the respective Simulation and Animation pages here:
</p>
    <a href="../simulation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Simulation</a>
    <a href="../animation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Animation</a>
</div>
</body>
</html>
