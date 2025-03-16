<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Waiter Solution</title>
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

<div class="description">


    <h2>Eat Permission Waiter Solution</h2>
    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Waiter Solution introduces a central entity to manage access to chopsticks and prevent deadlocks.
        Note that such solutions are known under several names, including "Monitor Solution", "Arbitrator Solution", "Footman Solution" and "Supervisor Solution".
        In the Eat Permission Waiter solution, philosophers must notify the waiter whenever they want to eat.
        The waiter maintains a queue of requests and grants permission to eat based on the order in which philosophers
        were added to the queue.
        When philosophers are first in the queue, they are given permission to pick up both chopsticks and eat.
        Once they finished putting down the chopsticks, they return the permission, and the waiter grants it to the next
        philosopher in the queue.
        In this solution, we view the whole picking-up chopsticks, eating and putting down chopsticks as an atomic
        process, and is thus very similar in performance to the Global-Token Solution.
        Viewing the whole eating process is of course unnecessary, we will therefore improve on this in the following
        solutions on this page.

    </p>

    <p>
        <b>Waiter class:</b>
        We introduce a waiter class that handles the received requests using a queue.
        Whenever a request is received the waiter pushes the philosopher onto the queue and then processes one
        philosopher at a time,
        permitting the next one in the queue to eat at a time.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class Waiter {

    Philosopher permittedPhilosopher;
    // queue of philosophers waiting for permission
    Queue queuedPhilosophers;

    Waiter(int nrPhilosophers) {
        permittedPhilosopher = null;
        queuedPhilosophers = new Queue();
    }

    synchronized void requestPermission(Philosopher philosopher) {
        queuedPhilosophers.add(philosopher);

        // if no philosopher has permission, assign the first in the queue
        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll();
        }

        // wait until this philosopher is the one permitted to proceed
        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }
    }

    // return permission and picking the next philosopher
    synchronized void returnPermission() {
        // grant permission to the next philosopher in the queue.
        permittedPhilosopher = queuedPhilosophers.poll();

        // wake up all philosophers to check whether they are now permitted
        notifyAll();
    }
}
    </code></pre>
    <p>

    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class EatPermissionPhilosopher extends Philosopher {

    Waiter waiter;
    EatPermissionPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
        super(id, leftChopstick, rightChopstick);
        this.waiter = waiter;
    }

    @Override
    public void run() {

        while (!terminated()) {
            think();
            // request permission before pickup
            waiter.requestPermission(this);

            pickUpLeftChopstick();
            pickUpRightChopstick();
            eat();
            putDownLeftChopstick();
            putDownRightChopstick();

            // return permission after put-down
            waiter.returnPermission();
        }
    }
}

    </code></pre>
    <h3>Eat Permission Waiter Solution Evaluation</h3>

    <p>Now let us evaluate the Eat Permission Waiter approach based on the key challenges and performance in simulations:</p>
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
            <td>We prevent deadlocks by avoiding the circular-wait condition. Only one philosopher is to pick up chopsticks at any time.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: The introduction of a queue on the philosophers requests guarantees that each philosopher will eventually get a chance to eat.
                Both, Eat-chance and time-fairness depend heavily on the chosen distribution. The waiter will hand out permission eventually, but does not account for additional fairness.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>The Eat Permission Waiter algorithm removes concurrency from the system, permitting only one philosopher at a time.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are straightforward. A new waiter class is introduced, and philosophers have to request and await the waiter's permission before eating.</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>There is a performance overhead using this solution, as the waiter has to process one
                philosophers request after another and has to maintain a queue of size r (number of requests).
                Scalability is poor because of the central "Waiter" entity being accessed one by one. </td>
        </tr>
        </tbody>
    </table>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Eat Permission Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Eat Permission Waiter Animation</a>




    <div class="separator"></div>
    <h2>Pickup Permission Waiter Solution</h2>
    <p>
        We can reintroduce some concurrency into the system by limiting the waiters permission to just the
        pickup phase. This way, multiple philosophers can receive permission from the waiter and eat at the same time.
        This approach helps us attain concurrency again, but still prevents deadlocks by avoiding the circular wait
        condition.
        The main drawback of this solution is that the waiter will always assign the permission to the philosopher that
        requested the chopsticks first.
        Thus, an adjacent philosopher will frequently attain permission, limiting the concurrency. (similar to the naive approach)
    </p>

    <p>
        <b>Philosopher class:</b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class PickupPermissionPhilosopher extends Philosopher {

    Waiter waiter;
    PickupPermissionPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
        super(id, leftChopstick, rightChopstick);
        this.waiter = waiter;
    }

    @Override
    public void run() {

        while (!terminated()) {
            think();
            // request permission before pickup
            waiter.requestPermission(this);

            pickUpLeftChopstick();
            pickUpRightChopstick();

            // return permission after pickup
            waiter.returnPermission();

            eat();
            putDownLeftChopstick();
            putDownRightChopstick();
        }
    }
}
    </code></pre>

    <h3>Pickup Permission Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Pickup Permission Waiter approach based on the key challenges and performance in simulations:</p>
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
            <td>As in the Eat Permission Waiter Solution, we effectively avoid deadlocks by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: As in the Eat Permission Waiter solution, every philosopher, when requested, will eventually get a chance to eat.
                Both, Eat-chance and time-fairness depend heavily on the chosen distribution. The waiter will hand out permission eventually, but does not account for additional fairness.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>
                We reintroduce concurrency, but it is not ideal.
                Philosophers have to wait while another is granted permission.
                Additionally, permission is frequently given to philosophers adjacent to currently eating neighbors.
                The waiter will then block until this philosopher finished picking up.
                Depending on the order of the requests, this limits the degree of concurrency for this solution. </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>Very simple, we only need to move one line in the Eat Permission Waiter Solution to regain concurrency.</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>Slight performance overhead and poor scalability, same as in the Eat Permission Waiter Solution.</td>
        </tr>
        </tbody>
    </table>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=PICKUPWAITER" class="button">Pickup Permission Waiter Simulation</a>
    <a href="../animation/?algorithm=PICKUPWAITER" class="button">Pickup Permission Waiter Animation</a>







    <div class="separator"></div>

    <h2>Intelligent Waiter Solution</h2>
    <p>
        To improve our Pickup Permission Waiter solution, we check if the requesting philosopher first in the queue is next to a philosopher
        that is currently eating.
        If that is the case, we skip this philosopher and allow another philosopher in the queue (that is not adjacent
        to a currently eating philosopher and is not a currently eating philosopher) to eat.
        In the case that no such philosopher is found, we just pick the first philosopher in the queue.
        This potentially helps us to attain more concurrency in our system.

    </p>

    <p>
        <b>Waiter class: </b>
        Additional to the queue, we utilize a boolean array to keep track of the philosophers eating states.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class IntelligentWaiter {

    Philosopher permittedPhilosopher;
    // queue of philosophers waiting for permission
    Queue philosophersQueue;
    int nrPhilosophers;
    // boolean array that tracks whether a philosopher is eating
    boolean[] eatStates;

    IntelligentWaiter(int nrPhilosophers) {
        this.nrPhilosophers = nrPhilosophers;
        permittedPhilosopher = null;
        philosophersQueue = new Queue();
        eatStates = new boolean[nrPhilosophers];
    }

    synchronized void requestPermission(Philosopher philosopher) {
        philosophersQueue.add(philosopher);

        // if no philosopher has permission, assign the first one from the queue
        if (permittedPhilosopher == null) {
            permittedPhilosopher = philosophersQueue.poll();
        }

        // wait until this philosopher is the one permitted to eat
        while (philosopher != permittedPhilosopher) {
            wait();
        }
        // update the now permitted philosophers state to eating
        setEatState(philosopher);
    }

    // method to return permission, and to find a philosopher in  the queue that has no eating neighbors
    synchronized void returnPermission() {
        // iterate through the queued philosophers
        for Each philosopher in philosophersQueue {
            int leftPhilosopher = (philosopher.getPhId() - 1 + nrPhilosophers) % nrPhilosophers;
            int rightPhilosopher = (philosopher.getPhId() + 1) % nrPhilosophers;

            // check if neighboring philosophers are not eating
            if (!eatStates[leftPhilosopher] && !eatStates[rightPhilosopher] && philosopher != permittedPhilosopher) {

                // if found, grant permission to this philosopher
                permittedPhilosopher = philosopher;
                philosophersQueue.remove(philosopher);

                // wake up all philosophers to check whether they are now permitted
                notifyAll();
                return;
            }
        }

        // if no suitable philosopher is found, assign the next one in the queue
        permittedPhilosopher = philosophersQueue.poll();
        // wake up all philosophers to check whether they are now permitted
        notifyAll();
    }

    // update state to eating
    void setEatState(Philosopher philosopher) {
        eatStates[philosopher.getPhId()] = true;
    }

    // update state to not eating
    synchronized void removeEatState(Philosopher philosopher) {
        eatStates[philosopher.getPhId()] = false;
    }
}

    </code></pre>
    <p>
        <b>Philosopher class:</b>
        Here we need to notify the waiter when eating is finished.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class IntelligentPickupPermissionPhilosopher extends Philosopher {

    IntelligentWaiter waiter;

    IntelligentPickupPermissionPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, IntelligentWaiter waiter) {
        super(id, leftChopstick, rightChopstick);
        this.waiter = waiter;
    }

    @Override
    void run() {
        while (!terminated()) {
            think();

            // request permission before pickup and set their "eating" state to true
            waiter.requestPermission(this);
            pickUpLeftChopstick();
            pickUpRightChopstick();

            // return permission after pickup
            waiter.returnPermission();

            eat();
            putDownLeftChopstick();
            putDownRightChopstick();

            // notify waiter after put-down that eating is finished
            waiter.removeEatState(this);
        }
    }
}

    </code></pre>

    <h3>Intelligent Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Intelligent Waiter approach based on the key challenges and performance in simulations:</p>
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
            <td>As in the previous solutions, we avoid the circular-wait condition by only allowing one philosopher to pickup at a time.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Unfortunately, starvation is possible in some rare cases.
                There is a slim chance of a philosopher being skipped indefinitely in a bad execution order.
                We always prefer philosophers that are currently able to eat over those that requested first.
                This skipping potentially reduces the eat-chance and eat-time fairness in our system.
            </td>

        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>This approach lets us enhance concurrency in our system by avoiding handing permission to a philosopher adjacent to a currently eating neighbor, whenever possible. Therefor this solution -on average- outperforms Pickup Permission Waiter.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>We introduce some additional logic to the waiter solution. We have to be careful in how we manage and process the queue. This makes the approach a little more elaborate to implement correctly (compared to the previous approaches).</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>This solution produces significant overhead. There is now processing of the queue and an array tracking eat-states. Additionally, philosophers now have to access the waiter an additional time when removing their "eating" state. This additional effort leads to poor scalability since the waiter potentially has to go through a queue of r (number of requests) to check whether adjacent philosophers are eating each time a request is returned. During this time, the waiter cannot accept requests, put-downs and removal of eat-states, forcing other philosophers to wait.</td>
        </tr>
        </tbody>
    </table>

    <p>

        The Solution yields good results concerning concurrency, however,
        there is still no account of additional fairness,
        and starvation is possible.
    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Waiter Simulation</a>
    <a href="../animation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Waiter Animation</a>





    <div class="separator"></div>

    <h2>Fair Waiter Solution</h2>
    <img src="../pictures/fairwaiter.svg" alt="Dining Philosophers Problem" width="520" height="455">
    <p>
        We can enhance fairness in the Waiter Solution by tracking how many times each philosopher has had the
        chance to eat during the simulation, enabling us to address eat-chance fairness.
        Alternatively, we could track how much time philosophers spent
        eating previously; this allows us to address Eat-Time Fairness.
        The waiter will then prioritize the philosopher with the least accumulated eating time, or least chances to eat,
        attempting to ensure that all philosophers get a fair opportunity.
        This, of course, can only react to previous eating times/ number of eat-chances.
    </p>

    <h4>Eat Time Fairness implementation: </h4>
    <p>
        <b>Waiter class:</b>
        When philosophers request permission, they are added to a queue, and if no other philosopher is currently allowed,
        the first in the queue gains permission. Philosophers wait until it is their turn. After a philosopher finishes eating,
        they return the permission, and the waiter selects the next philosopher who has eaten the least, if present in the queue.
        The "eat-chance alternative:" comments highlight the sections of code that need to be changed to account for eat-chance fairness.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class FairWaiter {

    Philosopher permittedPhilosopher;
    Queue philosophersQueue;

    FairWaiter() {
        permittedPhilosopher = null;
        philosophersQueue = new Queue();
    }

    synchronized void requestPermission(Philosopher philosopher) {
        philosophersQueue.add(philosopher);

        if (permittedPhilosopher == null) {
            // assign the first philosopher in the queue if none is permitted
            permittedPhilosopher = philosophersQueue.poll();
        }

        while philosopher != permittedPhilosopher {
            // wait until it is this philosophers turn
            wait();
        }
    }

    synchronized void returnPermission(Philosopher philosopher) {
        boolean foundOtherPhilosopher = false;
        Long minEat = MAX_VALUE;

        //variable to track the current philosopher with the least eat-time
        //eat-chance alternative: FairPhilosopher leastEatChancePhilosopher;
        FairPhilosopher leastEatTimePhilosopher;

        // find the philosopher with the minimum eat-chances/ eat-time
        for Each philosopher in philosophersQueue {

            //eat-chance alternative: if (philosopher.eatChances < minEat && philosopher != currentPhilosopher) {
            if (philosopher.eatTime < minEat && philosopher != currentPhilosopher) {

                // if the current eat-chances/ eat-time are the minimum found so far, assign to minEat
                // eat-chance alternative: minEat = philosopher.eatChances;
                minEat = philosopher.eatTime;

                //eat-chance alternative: leastEatChancePhilosopher = philosopher;
                leastEatTimePhilosopher = philosopher;

                foundOtherPhilosopher = true;
            }
        }

        // if no philosopher is in the queue we set permittedPhilosopher to null
        if (!foundOtherPhilosopher) {
            permittedPhilosopher = null;
        } else {

            //eat-chance alternative: permittedPhilosopher = leastEatChancePhilosopher
            permittedPhilosopher = leastEatTimePhilosopher;

            philosophersQueue.remove(permittedPhilosopher);
        }
        // wake up all philosophers to check whether they are now permitted
        notifyAll();
    }
}

    </code></pre>

    <p><b>Philosopher class:</b>
        We track the philosophers' total eating time by adding it to the previous eat-time once they finish eating.
        The "eat-chance alternative:" comments highlight the sections of code that need to be changed to account for eat-chance fairness.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class FairPhilosopher extends Philosopher {

    FairWaiter waiter;

    // eat-chance alternative: int eatChances;
    long eatTime;

    FairPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, FairEatTimeWaiter waiter) {
        super(id, leftChopstick, rightChopstick);
        this.waiter = waiter;
        eatTime = 0;
    }

    @Override
    void run() {
        while (!terminated()) {
            think();

            //request permission before pickup
            waiter.requestPermission(this);

            pickUpLeftChopstick();
            pickUpRightChopstick();

            //return permission after pickup
            waiter.returnPermission(this);

            //calculate the total eat time until this point.
            //eat-chance alternative: eat(); eatChances++;
            eatTime += eatFair();


            putDownLeftChopstick();
            putDownRightChopstick();
        }
    }

    // modified eat() method for tracking times spent eating
    long eatFair() {
        //calculate sleep time according to distribution
        Long duration = calculateDuration();
        sleep(duration);
        sbLog("[ E ]", VirtualClock.getTime());
        return duration;
    }
}

    </code></pre>

    <h3>Fair Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Fair Waiter approach based on the key challenges and performance in simulations:</p>
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
            <td>We effectively prevent deadlocks with this solution, as in the other waiter solutions, by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: We prioritize those with the least eat-chances/ time or pick the next in line, so any request will eventually be fulfilled.
                For the eat-chance fairness implementation, we allow the philosopher to eat who has eaten the least time. Similarly,
                the eat-time approach additionally takes the distribution of eat-times into account and can potentially compensate for large outliers.
                We act on this prioritization whenever possible (if no philosopher is in the queue, we pick the first one that requests the chopsticks).
                Both approaches let us effectively enhance different aspects of fairness compared to Pickup Permission Waiter.
            </td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>
                Limited: With this solution, we clearly prioritize fairness over parallelism. We frequently assign philosophers adjacent to eating neighbors permission, lowering concurrency.
            </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>We modify the waiter class to check for the requesting philosopher that has eaten the least. This makes things a little more elaborate to implement than the simple Pickup Permission Waiter Solution.</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>
                We have to both maintain a queue and process it every time a request is returned. This produces significant overhead and poor scalability.
            </td>
        </tr>
        </tbody>
    </table>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=FAIR_CHANCE_WAITER" class="button">Fair Waiter (Chance-based) Simulation</a>
    <a href="../animation/?algorithm=FAIR_CHANCE_WAITER" class="button">Fair Waiter (Chance-based) Animation</a>
    <a href="../simulation/?algorithm=FAIR_EATTIME_WAITER" class="button">Fair Waiter (Time-based) Simulation</a>
    <a href="../animation/?algorithm=FAIR_EATTIME_WAITER" class="button">Fair Waiter (Time-based) Animation</a>





    <div class="separator"></div>

    <h2>Two Waiters Solution</h2>
    <img src="../pictures/multiplewaiters.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        One of the main drawbacks of the waiter solution would be its scalability.
        Modern systems often maintain hundreds, if not thousands of threads that compete for resources.
        The waiters being accessed mutually exclusively (one after another) by several hundreds, if not thousands of philosophers,
        instead of being accessed by a few would produce a big overhead with long waiting times.
        An idea to address this, is to introduce more than one waiter into the system.
        Each of the waiters is assigned to manage a subset of the philosophers.
        We focus here on an implementation that utilizes only two waiters to manage the philosophers.
        However, this concept can easily be extended to many waiters if the number of philosophers increases.
    </p>

    <p>
        All we have to do is to reuse the Pickup Permission Waiter and assign it to a subset of
        the given philosophers.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
List chopsticks;
List philosophers;

// initialize chopsticks
for (int i = 0; i < nrPhilosophers; i++) {
    chopsticks.add(new Chopstick(i));
}

//create two waiters
Waiter splitWaiter = new Waiter(nrPhilosophers);
Waiter splitWaiter1 = new Waiter(nrPhilosophers);

Waiter selectedWaiter;

// only assign two waiters if more than 3 philosophers are simulated
boolean assignToTwo = nrPhilosophers > 3;
for (int i = 0; i < nrPhilosophers; i++) {
    // philosophers with lower ids are assigned the first waiter, the remaining to the second
    selectedWaiter = (assignToTwo && i >= nrPhilosophers / 2) ? splitWaiter1 : splitWaiter;

    PickupPermissionPhilosopher philosopher = new PickupPermissionPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), selectedWaiter);
    philosophers.add(philosopher);
}
    </code></pre>

    <h3>Two Waiters Solution Evaluation </h3>

    <p>Now let us evaluate the Two Waiters approach based on the key challenges and performance in simulations:</p>
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
            <td>Prevents deadlocks by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: Each waiter manages its own queue, so each philosopher in the subset will eventually get the chance to eat.
                Unfortunately this approach leads to low eat-chance and eat-time fairness, likely due to the philosophers at the "corners" of the set receiving permission less frequently.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Good: By reducing the overhead of exclusive waiter access, we consistently achieve high concurrency. Due to decentralized requests, we gain the advantage of assigning permission to philosophers adjacent to eating neighbors less often. Therefore, this solution will — on average — outperform the Pickup Permission Waiter in simulations.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are quite minimal; we only need to add additional waiters during the table initialization of the Pickup Permission Waiter Solution.</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>Compared to the previous approaches, we improve on scalability if we choose appropriately sized subsets for the philosophers. Thus, the overhead becomes more manageable, and long waiting times due to exclusive access to the waiter are mitigated.</td>
        </tr>
        </tbody>
    </table>

    <p>
        The advantage of this solution is that we can use some of the previously presented waiters to manage the respective subsets with a few considerations:
        The Fair Waiter Solution is capable of ensuring fairness, but only within the managed subset.
        This approach would likely reduce concurrency significantly since the unfairly treated philosophers at the "corners" of managed sets would be prioritized by both waiters.
        Using Intelligent Waiter would require communication between waiters, exchanging eating/ not eating states of philosophers.
        One main drawback of these kinds of solutions, however, is that we need good knowledge about the system.
        We need to know the number of philosophers and the appropriate waiter assignment in advance to initialize the system.
        Dynamic environments would be harder to manage because of considerations like:
        If a philosopher joins the table, which waiter is responsible?
        When many philosophers join or leave the table, do we reduce/increase the number of waiters and redistribute the subsets?
        The correct balance of subsets is necessary to improve performance.

    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TWOWAITERS" class="button">Two Waiters Simulation</a>
    <a href="../animation/?algorithm=TWOWAITERS" class="button">Two Waiters Animation</a>



    <div class="separator"></div>

    <h2>Restrict Waiter Solution</h2>

    <p>
        There is another version of the waiter solution, in which we simply track the number of forks on the table.
        The waiter always provides the chopsticks when requested by a philosopher,
        unless there are less than two chopsticks remaining on the table.
        In this case, we let the philosopher wait until another philosopher is done eating,
        and two forks are again on the table.
        This algorithm prevents one philosopher from attempting to pick-up at any time.
    </p>


    <p>
        <b>Waiter class: </b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class RestrictWaiter {
    // tracks the number of available chopsticks on the table
    int chopsticksOnTable;
    // fair lock (enabled by true flag)
    Lock lock =  new ReentrantLock(true);
    // condition to wait for available chopsticks
    Condition enoughChopsticks = lock.newCondition();


    RestrictWaiter(int nrPhilosophers) {
        // all chopsticks are on the table initially
        chopsticksOnTable = nrPhilosophers;
    }


    void requestPermission() {
        // acquire the lock for exclusive access to waiter
        lock.lock();
        try {
            // wait until there are at least two chopsticks available on the table
            while (chopsticksOnTable < 2) {
                enoughChopsticks.await();
            }
            // two chopsticks will be removed from the table
            chopsticksOnTable -= 2;
        } finally {
            // release lock to allow other philosophers access to the waiter
            lock.unlock();
        }
    }


    void returnChopsticks() {
        // acquire the lock for exclusive access to waiter
        lock.lock();
        try {
            // two chopsticks are returned to the table
            chopsticksOnTable += 2;
        } finally {
            // notify all that put-down was completed
            enoughChopsticks.signalAll();
            // release lock to allow other philosophers access to the waiter
            lock.unlock();
        }
    }
}

    </code></pre>
    <p>
        <b>Philosopher class:</b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class GuestPhilosopher extends Philosopher {

    RestrictWaiter waiter;


    GuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, RestrictWaiter waiter) {
        super(id, leftChopstick, rightChopstick);
        this.waiter = waiter;
    }

    @Override
    void run() {

        while (!terminated()) {
            think();
            // ask waiter whether more than two chopsticks are still available
            waiter.requestPermission();
            pickUpLeftChopstick();
            pickUpRightChopstick();
            eat();
            putDownLeftChopstick();
            putDownRightChopstick();
            // inform the waiter that the philosopher has put-down the two chopsticks
            waiter.returnChopsticks();
        }
    }
}

    </code></pre>
    <p>Now let us evaluate the Restrict Waiter approach based on the key challenges and performance in simulations:</p>
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
            <td>By limiting the number of philosophers able to pick-up at any point to (n-1), we prevent deadlocks by avoiding the circular wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free, but only due to a fair lock, that manages a FIFO queue on the waiting philosophers and the utilization of the FIFO-enhanced pickups.

            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>
                Limited: We only block philosophers that would not be able to complete a pick-up.
                The main drawback of this solution is that we "blindly"
                base our permission on the number of chopsticks on the table,
                not the capability of eating.
                Therefor long waiting chains that limit concurrency are possible.
            </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are not very complex and are intuitive to understand. But since this solution does not use a queue, we need a fair lock to prevent barging. This lets the waiter hand permission in the order the philosophers requested it.</td>
        </tr>
        <tr>
            <td><b>Overhead and Scalability</b></td>
            <td>The additional logic in this solution produces moderate overhead.
                We still use a central entity to hand out permissions, which limits the scalability of the approach.</td>
        </tr>
        </tbody>
    </table>
    <p>
        Note that this solution cannot be used within a multiple waiters setting
        (blocking one philosopher in each subset makes no sense),
        thus this approach is inherently limited to one waiter.
        This approach further highlights the diversity of possible waiter solutions.
    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=RESTRICTWAITER" class="button">Restrict Waiter Simulation</a>
    <a href="../animation/?algorithm=RESTRICTWAITER" class="button">Restrict Waiter Animation</a>

</div>

<a href="../semaphore/" class="button">➡ Next: Semaphore Solutions ➡</a>

</body>
</html>
