
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Token Solution</title>
    <style>
        .button {
            display: inline-block;
            color: white;
            background-color: #216477;
            border: 4px solid #ccc;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            transition: background-color 0.3s ease, color 0.3s ease;
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


        code {
            display: block;
            background-color: #f5f5f5;
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 13px;
            white-space: pre;
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
        Then, the token is passed counterclockwise to the adjacent philosopher, so only one philosopher can eat at a time.
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

    // holding philosopher passes the token to the right neighbor
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
class TokenPhilosopher extends Philosopher {

    TokenPhilosopher rightPhilosopher = null;

    volatile GlobalToken token;

    Lock tokenLock = new ReentrantLock(true);

    public TokenPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    public void setToken (GlobalToken token){
        this.token = token;
    }

    public void setRightPhilosopher(TokenPhilosopher rightPhilosopher){
        this.rightPhilosopher = rightPhilosopher;
    }

    //called by left neighbor for handing over token
    protected void acceptToken(GlobalToken token) {
        synchronized (tokenLock) {
            this.token = token;
            tokenLock.notify();
        }
    }

    @Override
    void run() {
        while (!terminated()) {
            think();
            synchronized (tokenLock) {
                while (token == null) {
                    // when not in possession, wait until the token is received
                    tokenLock.wait();
                }
            }

            pickUpLeftChopstick();
            pickUpRightChopstick();
            eat();
            putDownLeftChopstick();
            putDownRightChopstick();
            //pass the token on to the right neighbor
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

// initialize chopsticks
for (int i = 0; i < nrPhilosophers; i++) {
    chopsticks.add(new Chopstick(i));
}

// initialize token philosophers, each with a left and right
chopstick
for (int i = 0; i < nrPhilosophers; i++) {
    TokenPhilosopher philosopher = new TokenPhilosopher(
        i,
        chopsticks.get(i),
        chopsticks.get((i + 1) % nrPhilosophers)
    );
    philosophers.add(philosopher);
}

// set the reference to the right-hand neighbor for each philosopher
for (int i = 0; i < nrPhilosophers; i++) {
    TokenPhilosopher philosopher = philosophers.get(i);
    philosopher.setRightPhilosopher(philosophers.get((i + 1) % nrPhilosophers));
}

TokenPhilosopher initialPhilosopher = philosophers.getFirst();

// create the global token and assign it to the initial philosopher
GlobalToken token = new GlobalToken(initialPhilosopher);
// the first philosopher holds the token
initialPhilosopher.setToken(token);
    </code></pre>

    <h3>Global Token Solution Evaluation</h3>
    <p>
        Now Let us evaluate the Global Token solution according to the key challenges and performance in simulations:
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
            <td>We effectively prevent deadlocks by breaking the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free, as each philosopher will eventually get the chance to eat.
                Fair eat-chances, as each philosopher gets a turn at eating once every round.
                Eat-time fairness depends heavily on the chosen distribution.</td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>No concurrency, only one philosopher can eat at a time.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The implementation is rather simple and requires only an additional Token class, and philosophers passing the token after eating. </td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>The introduced logic's overhead is minimal and managed in a decentralized way. No central entity, and thus highly scalable.</td>
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
        The Global Token Solution is hardly ideal. It does prevent deadlocks and provides eat-chance fairness,
        but it removes concurrency.
        The next idea would be to introduce multiple tokens into the system. We know that the maximum concurrency is limited in our
        system under ideal conditions to [n/2] for even n and &lfloor;n/2&rfloor; for uneven n.
        Two adjacent philosopher can never eat at the same time, so the idea is to just hand
        every other philosopher a token
        and prevent the token from being passed on to the next philosopher if they hold a
        token.
        If we have an uneven number of philosophers, the last one is skipped automatically (We do not hand them a token).
        We pass the token only after the other philosopher has passed on its token.
        In theory, we can reach
        maximum concurrency of [n/2]/ &lfloor;n/2&rfloor;, if eating and thinking times are similarly distributed.
    </p>
    <img src="../pictures/multipletoken_working.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <p>
        We only modify the Token class for cases where the next philosopher still holds on to a token.
        This is not likely to happen
        because the philosophers cannot start eating until the adjacent philosopher is done eating,
        and thus cannot pass on the token.
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
        // do not pass token if right neighbor already holds one
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
        We hand every other philosopher a token:
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

List chopsticks;
List philosophers;

// initialize chopsticks
for (int i = 0; i < nrPhilosophers; i++) {
    chopsticks.add(new Chopstick(i));
}

// initialize token philosophers, each with a left and right
chopstick
for (int i = 0; i < nrPhilosophers; i++) {
    TokenPhilosopher philosopher = new TokenPhilosopher(
        i,
        chopsticks.get(i), // left chopstick
        chopsticks.get((i + 1) % nrPhilosophers) // right chopstick
    );
    philosophers.add(philosopher);
}

// set reference to the right-hand neighbor for each philosopher
for (int i = 0; i < nrPhilosophers; i++) {
    TokenPhilosopher philosopher = philosophers.get(i);
    philosopher.setRightPhilosopher(philosophers.get((i + 1) % nrPhilosophers));
}

// assign tokens to every other philosopher
for (int i = 0; i < nrPhilosophers - 1; i += 2) {
    TokenPhilosopher philosopher = philosophers.get(i);
    philosopher.setToken(new Token(i, philosopher));
}

    </code></pre>
    <h3>Multiple Token Solution Evaluation</h3>
    <p>
        Now Let us evaluate the Multiple Token solution according to the key challenges and performance in simulations:
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
            <td>We again prevent deadlocks by avoiding the circular-wait condition.
            There are only ever ⌊n/2⌋/ [n/2] philosophers allowed to attempt pickup.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free, as each philosopher will eventually get the chance to eat.
                Fair eat-chances, as each philosopher repeatedly earns permission when they receive a token.
                Potentially unfair eat-times, depending on the chosen distributions of eat- and think-times.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Potential high concurrency, as multiple tokens are passed around permitting ⌊n/2⌋/ [n/2] philosophers to eat at a time. However, there is a possibility of "traffic jams" that can eliminate any concurrency. (Explained in more detail below)</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes that need to be made are a little more extensive than, for example, the asymmetric solution, but the logic is rather easily expanded on, using the Global Token Solution.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a negligible performance overhead utilizing this additional logic. Still no central entity, therefor there is a high scalability present in this approach.</td>
        </tr>
        </tbody>
    </table>


    <p>
        This algorithm shows promising results, including high potential concurrency,
        fairness in eating opportunities, and no risk of deadlocks.
        It is also highly scalable,
        provided we know the number of philosophers and none drop out or "die."
        However, several major issues with this approach remain.
        First, congestion could occur when a philosopher eats for a very long time.
        Secondly, we assume that philosophers will want to eat when they receive a token, however,
        if very long thinking times occur, they will hold onto the token until they finish thinking and eating,
        again leading to congestion in such cases.

        In total, for this solution to perform optimally,
        we have to assume similar distributions in thinking and eating times,
        to not result in unnecessary long blocked times for other philosophers.

        We could improve this algorithm a little by allowing "long thinking"
        philosophers to pass the token to the next philosopher.
        For this approach,
        we would have to determine a good heuristic to define what a "long thinking time" is.
        However, this could again lead to starvation, even with a well-chosen heuristic.

    </p>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Simulation</a>
    <a href="../animation/?algorithm=MULTIPLETOKEN" class="button">Multiple Token Animation</a>
</div>

<a href="../waiter/" class="button">➡ Next: Waiter Solutions ➡</a>
</body>
</html>
