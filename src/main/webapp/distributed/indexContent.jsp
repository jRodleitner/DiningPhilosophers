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
            display: inline-block;
            color: white;
            background-color: #216477;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            border: 4px solid #ccc;
            transition: background-color 0.3s ease, color 0.3s ease;
            margin: 5px 0;
        }


        /* Hover Effect */
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
<h2>Chandy-Misra Solution</h2>
<div class="description">
    <img src="../pictures/chandymisra.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The classic Dining Philosophers Problem does not allow communication between philosophers.
        For the following solution, we want to ignore this and explore an approach that depends on messages.
        In 1984, Chandy and Misra presented a highly scalable solution
        that also enables philosophers to contend for an arbitrary amount of resources.
        The solution is based on status flags of the chopsticks (clean, dirty), and the transfer of ownership.
        Deadlocks are prevented because philosophers always have to hand out "dirty" chopsticks when requested,
        and they have to "own" both to proceed to pick up chopsticks and eat,
        this lets us avoid the circular wait condition.
        Here are the crucial details of the algorithm:
    </p>
    <ul>
        <li>For every pair of philosophers contending for a resource, create a chopstick and give it to the philosopher
            with the lower id (n for agent Pn).
            Each chopstick can either be dirty or clean.
            Initially, all chopsticks
            are <b>dirty</b>.
        </li>
        <li>When philosophers want to use a set of resources (i.e., eat), said philosophers must obtain the chopsticks
            from their contending neighbors.
            For all such chopsticks the philosophers do not have, they send a request
            message.
        </li>
        <li>When philosophers with a chopstick receive a request message, they keep the chopstick if it is clean, but
            give it up when it is dirty.
            If philosophers send a chopstick over, they clean the chopstick before doing
            so.
        </li>
        <li>After philosophers are done eating, all their chopsticks become dirty.
            If another philosopher had previously
            requested one of the chopsticks, the philosopher that just finished eating cleans the chopstick and sends
            it.
        </li>
    </ul>
    <img src="../pictures/chandymisra_init.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Additional properties are:
        The initialization of ownership is asymmetric (the first philosopher owns two chopsticks, the last one none).
        Philosophers should always hand out their "dirty" chopsticks, but only if requested
        When philosophers hand out chopsticks, they should by-default receive it back at some later point.
        In principle, philosophers have to hand out their chopstick
        As previously mentioned we could expand the algorithm to deal with multiple resources,
        however, for convenience we will focus on the classic problem where they only compete with their adjacent
        neighbors.
    </p>

    <p>
        <b>Philosopher class: </b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
    class ChandyMisraPhilosopher extends Philosopher {

        ChandyMisraChopstick leftChopstick;
        ChandyMisraChopstick rightChopstick;
        ChandyMisraPhilosopher leftNeighbor;
        ChandyMisraPhilosopher rightNeighbor;
        boolean goingToEatRequest = false;  // indicates if the philosopher is attempting to eat

        ChandyMisraPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
            super(id, leftChopstick, rightChopstick);
            this.leftChopstick = (ChandyMisraChopstick) leftChopstick;
            this.rightChopstick = (ChandyMisraChopstick) rightChopstick;
        }

        @Override
        void run() {
            while (!terminated()) {
                checkForRequests();  // handle any pending chopstick requests
                think();
                checkForRequests();  // handle requests before trying to eat
                requestChopsticksIfNecessary();  // request chopsticks if not owned
                eating();
                checkForRequests();  // check if release of chopsticks is necessary after eating
            }
        }

        void requestChopsticksIfNecessary() {
            goingToEatRequest = true;  // signal intention to eat
            waitForChopstick(leftChopstick);
            waitForChopstick(rightChopstick);
            goingToEatRequest = false;  // reset the request after obtaining chopsticks
        }

        void waitForChopstick(ChandyMisraChopstick chopstick) {
            synchronized (chopstick) {
                // wait until this philosopher owns the chopstick
                while (chopstick.owner != this) {
                    checkForRequests();  // handle requests while waiting
                    chopstick.wait(10);  // re-check for requests periodically
                }
            }
        }

        void checkForRequests() {
            // respond to any requests for the left or right chopstick from neighbors
            giveUpChopstickIfRequested(leftChopstick, leftNeighbor);
            giveUpChopstickIfRequested(rightChopstick, rightNeighbor);
        }

        void giveUpChopstickIfRequested(ChandyMisraChopstick chopstick, ChandyMisraPhilosopher receiver) {
            synchronized (chopstick) {
                // give up the chopstick if the neighbor has requested to eat,it is dirty, and this philosopher owns it
                if (receiver.goingToEatRequest && !chopstick.isClean && chopstick.owner == this) {
                    chopstick.isClean = true;  // mark the chopstick as clean
                    chopstick.owner = receiver;  // transfer chopstick ownership
                    chopstick.notifyAll();  // notify the waiting philosopher
                }
            }
        }

        void eating() {
            pickUpLeftChopstick();
            pickUpRightChopstick();
            eat();
            rightChopstick.isClean = false;  // mark chopsticks as dirty
            leftChopstick.isClean = false;
            putDownLeftChopstick();
            putDownRightChopstick();
        }

        @Override
        void think() {
            long remainingTime = calculateDuration();

            // think in small intervals to allow for checking requests during longer thinking times
            while (remainingTime > 0) {
                long sleepTime = min(remainingTime, 10);
                sleep(sleepTime);
                checkForRequests();  // handle chopstick requests while thinking
                remainingTime -= sleepTime;
            }

            sbLog(id, Events.THINK);
            lastAction = Events.THINK;
        }

        void setNeighbors(ChandyMisraPhilosopher leftNeighbor, ChandyMisraPhilosopher rightNeighbor) {

            this.leftNeighbor = leftNeighbor;
            this.rightNeighbor = rightNeighbor;
        }
    }

    </code></pre>
    <p>
        <b>Chopstick class: </b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
    class ChandyMisraChopstick extends Chopstick {

        ChandyMisraPhilosopher owner;
        boolean isClean = false; //chopsticks are initially dirty

        ChandyMisraChopstick(int id) {
            super(id);
        }

        void setOwner(ChandyMisraPhilosopher owner) {
            this.owner = owner;
        }
    }
    </code></pre>

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
            <td>We avoid deadlocks due to the distributed nature of the algorithm.
                Philosophers that own a chopstick
                have to hand over ownership unless they absolutely need it.
                This breaks the circular-wait condition.
            </td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: We avoid starvation because philosophers must hand over ownership to the requesting
                neighbor eventually.
                (Either during their own waiting/thinking phase or when they process requests after
                eating.)
                We only guarantee that philosophers will get a chance to eat at some point,
                but do not specifically
                enhance chance/ time—fairness with this approach.
            </td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>Great: The distributed handling of pickups and the avoidance of waiting chains yields a high degree
                of concurrency.
            </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The distributed nature and the need to manage the state of each chopstick (clean or dirty) and the
                request communication between philosophers lead to a more challenging implementation.
            </td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a slight overhead with the logic introduced in this solution.
                By design of this solution, philosophers are required to fulfill requests during their think and pickup
                phase,
                thus philosophers repeatedly check for requests during thinking/ waiting. (busy waiting)
                Due to its inherently distributed nature, the approach is highly scalable and can be used in large
                systems.
            </td>
        </tr>
        </tbody>
    </table>


    <p>
        This approach is very versatile and can be interpreted in many different ways.
        The implementation above is just one way the key concepts of dirty/ clean chopsticks and request messages can be
        implemented.

        It is harder to find a clear and correct explanation to this approach online, compared to many others of the
        discussed approaches.
        I have found many chandy misra "solutions" online that misunderstand basic concepts of this solution or are
        flat out incorrect interpretations.
        For example, one implementation I found simply forgot that philosophers have to request their chopstick back
        after they handed it to its neighbor, and would just start thinking again.
        In such cases, it is more useful to consult the original source, i.e., literature written by chandy and misra or
        works expanding on their concepts.
    </p>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>

    <a href="../simulation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Simulation</a>
    <a href="../animation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Animation</a>


    <div class="separator"></div>


    <h2>Restrict Token Solution</h2>
    <p>
        This approach combines the ideas of tokens, the Restrict Solution and a distributed approach.
        As in the Restrict Solution, we again reduce the number of concurrent pick-ups to (n - 1) via
        introducing a restricting token.
        Those who hold the token may not attempt to pick up and wait until they are asked to hand over the token by a
        neighbor.
        Philosophers request the token from their neighbors whenever they finish eating.
        The requested philosopher will then hand over the token if present, and the number of eatChances/ eatTime is
        lower than that of the requester.
        This approach again ignores the "silent" philosophers rule, to achieve a fully distributed algorithm.
    </p>

    <p>
        <b>RestrictToken class: </b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">


        class RestrictToken {

            int restrictId;


            RestrictToken() {
                restrictId = 0;
            }


            synchronized void waitIfRestricted(int id) {
                // if the current restriction id matches the philosophers id they wait
                while (restrictId == id) {
                    wait();  // wait until the restriction changes
                }
            }

            synchronized void updateRestricted(int id) {
                restrictId = id;  // set the restriction to apply to the new philosopher id
                notify();
            }
        }
    </code></pre>
    <p>
        <b>Philosopher class:</b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">


        class RestrictTokenPhilosopher extends Philosopher {

            RestrictToken restrictToken;
            RestrictTokenPhilosopher leftNeighbour, rightNeighbour;
            int eatChances = 0;


            RestrictTokenPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, RestrictToken restrictToken) {
                super(id, leftChopstick, rightChopstick);
                this.restrictToken = restrictToken;
            }

            @Override
            void run() {

                while (!terminated()) {
                    think();
                    if (restrictToken != null) {
                        restrictToken.waitIfRestricted(id);  // when holding a token, wait
                    }
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    eatChances++;  // increment the number of eat times
                    requestTokenFromNeighbours();  // request tokens from neighbors
                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }

            synchronized void requestTokenFromNeighbours() {
                // request tokens from both the left and right neighbors
                RestrictToken receivedLeft = leftNeighbour.handOverTokenIfHolding(this);
                RestrictToken receivedRight = rightNeighbour.handOverTokenIfHolding(this);

                // if a token was received from a neighbor, assign it to this philosopher
                if (receivedLeft != null) restrictToken = receivedLeft;
                if (receivedRight != null) restrictToken = receivedRight;
            }

            synchronized RestrictToken handOverTokenIfHolding(RestrictTokenPhilosopher requester) {
                // checks if this philosopher holds a token and if the requester has had fewer eating chances
                if (restrictToken != null && requester.eatChances > eatChances) {
                    restrictToken.updateRestricted(requester.getPhId());  // update the restriction to apply to the requester-id
                    RestrictToken token = restrictToken;
                    restrictToken = null;  // remove the token from this philosopher after transfer
                    return token;  // return the token to the requester
                } else {
                    return null;  // return null if no token is transferred
                }
            }

            void setNeighbors(RestrictTokenPhilosopher left, RestrictTokenPhilosopher right) {
                leftNeighbour = left;
                rightNeighbour = right;
            }
        }

    </code></pre>

    <h3>Restrict Token Solution Evaluation</h3>

    <p>Now let us evaluate the Restrict Token solution based on the key challenges:</p>
    <table class="styled-table">
        <thead>
        <tr>
            <th>Aspect</th>
            <th>Description</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><b>Deadlocks </b></td>
            <td>By limiting the number of philosophers to (n-1), we avoid the circular wait condition and thus prevent
                deadlocks.
            </td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness </b></td>
            <td>
                Starvation-free due to the FIFO-enhanced pickup of chopsticks.
                Due to the additional check of lesser eating time/ eat chances of philosophers who are requested for the
                token,
                we guarantee
                that the token will be held longer by philosophers who had more chances/ time to
                eat.
                However, it is not guaranteed that all philosophers will eventually hold the token, so we only prevent
                unfair treatment of certain philosophers.
                In usual executions, fairness is enhanced,
                but works better for smaller numbers of philosophers.
                When the number of philosophers is low, the token will be passed around all philosophers and improve
                eat-time or eat-chance fairness.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Limited: Due to the distributed nature of this algorithm, concurrent performance is usually good, but
                waiting chains are still an issue.
                Additionally, one philosopher is always being blocked (not attempting
                pickups at all); this shortens the longest precedence path, thus waiting chains are shortened.
            </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The implementation is more challenging than most of the presented algorithms.
                We need to be careful about the
                correct communication between philosophers, and make sure that they will wake up when they pass the
                token.
            </td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td> The produced overhead is not too significant, and the distributed nature of the approach makes it
                highly
                scalable.
                Anyhow, the fairness enhancing functionality might not scale very well for big arrangements
                since it is not guaranteed that all philosophers will get hold of the token in finite simulation time,
                and thus adjust for eat-chance/ eat-time unfairness.
            </td>
        </tr>
        </tbody>
    </table>

    <p>
        Depending on the implementation, we account for eat-chance fairness or eat-time fairness, when handing over the
        token.
    </p>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>

    <a href="../simulation/?algorithm=CHANCE_RESTRICT_TOKEN" class="button">Restrict Token (Chance-based) Simulation</a>
    <a href="../animation/?algorithm=CHANCE_RESTRICT_TOKEN" class="button">Restrict Token (Chance-based) Animation</a>
    <a href="../simulation/?algorithm=TIME_RESTRICT_TOKEN" class="button">Restrict Token (Time-based) Simulation</a>
    <a href="../animation/?algorithm=TIME_RESTRICT_TOKEN" class="button">Restrict Token (Time-based) Animation</a>


</div>


</body>
</html>
