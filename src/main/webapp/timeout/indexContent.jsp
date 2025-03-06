
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
            padding: 10px 20px;
            border-radius: 10px;
            border: 4px solid #ccc;
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
            padding: 12px;
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
        If a philosopher reaches the timeout before acquiring both chopsticks, they put down the chopstick they initially picked up and wait for a short time before trying to attempt a pickup again.
    </p>

    <p>
        <b>Philosopher class:</b>
        Philosophers start eating if the pickup of the right chopstick was successful, else they put down the left chopstick and wait for a short while before they try again.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class TimeoutPhilosopher extends Philosopher {

    TimeoutChopstick leftTimeoutChopstick;
    TimeoutChopstick rightTimeoutChopstick;

    TimeoutPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
        super(id, leftChopstick, rightChopstick);
        leftTimeoutChopstick = (TimeoutChopstick) leftChopstick;
        rightTimeoutChopstick = (TimeoutChopstick) rightChopstick;
    }

    @Override
    void run() {

        while (!terminated()) {
            think();
            pickUpLeftChopstick();
            boolean successfulPickup = pickUpRightWithTimeout();

            // if the philosopher fails to pick up the right chopstick, it releases the left and re-attempts pickup after a short wait
            while (!successfulPickup) {
                putDownLeftChopstick();
                // randomized wait time between 1 and 50ms
                int random = randomValue(1, 50);
                sleep(random);
                pickUpLeftChopstick();
                successfulPickup = pickUpRightWithTimeout();
            }

            // once both chopsticks are acquired, the philosopher eats
            eat();
            putDownLeftChopstick();
            putDownRightChopstick();
        }
    }

    boolean pickUpRightWithTimeout() {
        // attempts to pick up the right chopstick with a timeout
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
        // tracks time to ensure the philosopher does not wait indefinitely
        long startTime = currentTime();
        long remainingTime = timeout;

        // wait until the chopstick is available or the timeout expires
        while (!isAvailable) {
            if (remainingTime <= 0) {
                return false;
            }

            wait(remainingTime);
            remainingTime = timeout - (currentTime() - startTime);
        }

        // if the chopstick becomes available, it is marked as taken
        isAvailable = false;
        return true;
    }

    @Override
    boolean pickup(Philosopher philosopher){
        while(!isAvailable){ wait();}
        isAvailable = false;
        return true;
    }

    @Override
    void putDown(Philosopher philosopher){
        isAvailable = true;
        notify();
    }
}
    </code></pre>
    <h3>Timeout Solution Evaluation </h3>
    <p>
        Now let us evaluate the Timeout Algorithm according to the key challenges:
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
            <td>With this approach, the goal is to prevent deadlocks via removing the hold-and-wait condition.
                Unfortunately this algorithm is not completely deadlock free.
                There are highly unlikely situations where even a randomized wait time can lead to recurring deadlocks.
                Therefor this is not a correct solution.
            </td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation is unlikely, but philosophers are not guaranteed to be able to eat due to the timeout and the possibility of deadlocks.
                Additionally the wait(), notify() pattern, makes re-acquiring possible.
                Depending on the chosen timeout, starvation likeliness can change. (Very low timeout values likely increase the risk)
                Due to these issues, we cannot guarantee any fairness to the philosophers using this solution.
            </td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>The concurrency potential of this solution is dependent on the chosen timeout.
                With longer timeouts the degree of concurrency we achieve is practically identical to the naive implementation,
                due to potential wait chains.
                In the case of a short timeout, a high degree of concurrency is possible, because long wait chains are prevented.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>Minimal changes are required, and the concept is rather easy to understand/implement.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>The approach is highly scalable, and we essentially do not need any information on the system for this approach to work. Low performance overhead, but frequent timeouts may increase computational effort.</td>
        </tr>
        </tbody>
    </table>

    <p>
        A major limitation of this approach is that when a timeout occurs, philosophers must wait for a certain time to
        re-attempt their pickup. When the timeout is chosen very low, frequent re-attempts might happen.
        On the contrary, if we choose high values for the timeout, a long time goes by before a deadlock is detected, harming concurrency/ system progress.
        The waiting time has to be reasonably chosen and randomized, to lower the risk recurring deadlocks.
        If we choose fixed values, for example 10ms, it might happen that the philosophers all try to pick up their left
        chopsticks again and again, just with a delay of 10ms. This would (arguably) result in an even worse condition: A livelock (Consuming resources without system progress)
        Many real-world systems use approaches like these in non-critical systems, where unlikely occurrence of deadlock is sufficient.
    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TIMEOUT" class="button">Timeout Simulation</a>
    <a href="../animation/?algorithm=TIMEOUT" class="button">Timeout Animation</a>
</div>

<a href="../token/" class="button">➡ Next: Token Solutions ➡</a>
</body>
</html>
