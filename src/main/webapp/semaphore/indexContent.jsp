<%--
  Created by IntelliJ idEA.
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
<h2>Semaphore Solutions</h2>
<div class="description">
    <p>
        Semaphores are a frequently used synchronization mechanism for concurrent systems to manage access to resources.
        The concept was introduced to the computer science community by none other than Edsger Dijkstra himself.
        The resource is accessible if a semaphore has a value greater than one. The acquiring thread will then decrease the value and the
        semaphore will be locked, if the semaphore reaches a value of zero.
        Usually, semaphores have only one permit. In this case they are called binary semaphores.
    </p>
    <img src="../pictures/semaphore.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <div class="separator"></div>

    <h2>Table Semaphore Solution</h2>
    <p>
        Locking the whole table with a fair semaphore during pickup phase is one of the simplest solutions
        to avoid deadlocks for the Dining Philosophers.
        Philosophers have to acquire the semaphore before picking up their chopsticks,
        if the semaphore is currently not available, they wait until it becomes free again.
        After they are done picking up, they release the semaphore, and another philosopher can proceed.

        Functionally, this approach is similar to the previously presented Pickup Permission Waiter Solution.
        In fact, it could even be argued that in this case the Semaphore acts as an implicit waiter,
        because it maintains a FIFO queue, due to the enabled fairness parameter.
    </p>

    <p>
        <b>Table Semaphore class:</b>
        A semaphore that needs to acquired during pick-up.
        We have to enable the fairness parameter to prevent barging.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class TableSemaphore {
    Semaphore semaphore;

    TableSemaphore(){
        // enable fairness parameter to prevent barging
        semaphore = new Semaphore(1, true);
    }
}
    </code></pre>

    <p>
        <b>Philosopher class:</b>
        Philosophers need to acquire the table semaphore before picking up their
        chopsticks and release it, once they are finished picking up.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class SemaphorePhilosopher extends Philosopher {

    final Semaphore semaphore;
    SemaphorePhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, TableSemaphore tableSemaphore) {
        super(id, leftChopstick, rightChopstick);
        this.semaphore = tableSemaphore.semaphore;
    }

    @Override
    void run() {
        while (!terminated()) {
            think();

            // acquire the table-semaphore before pickup
            semaphore.acquire();
            pickUpLeftChopstick();
            pickUpRightChopstick();

            // release semaphore after pickup
            semaphore.release();
            eat();
            putDownLeftChopstick();
            putDownRightChopstick();

        }
    }
}

    </code></pre>

    <h3>Table Semaphore Solution Evaluation </h3>

    <p>Now let us evaluate the Table Semaphore solution based on the key challenges and performance in simulations:</p>
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
            <td>The Table Semaphore approach prevents deadlocks by allowing only one pickup at a time, breaking the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation</b></td>
            <td>
                Starvation-free: Starvation is prevented due to the implicit semaphore-queue, which eventually allows all philosophers to eat.
                Eat-chance and time-fairness depend heavily on the chosen distribution and are not managed here.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Limited: There is a possibility for high concurrency, but similar to the Pickup Waiter Solution, philosophers adjacent to eating neighbors may acquire the semaphore. </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The utilization of semaphores in this way proves to be very simple and requires only minimal modifications to the philosopher class.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a moderate performance overhead due to the globally accessed semaphore.
                Scalability is limited due to the managed FIFO queue,
                but should be slightly more light weight than that of the waiter solution (depends heavily on semaphore implementation). </td>
        </tr>
        </tbody>
    </table>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Animation</a>




    <div class="separator"></div>




    <h2>Restrict Solution</h2>
    <img src="../pictures/restrict.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Another effective method to prevent deadlocks in the Dining Philosophers problem is to limit the number of
        philosophers that are allowed to attempt pickups at the same time.
        For a group of n philosophers, we restrict this number to n-1, meaning only n-1 philosophers can try to pick up
        their chopsticks simultaneously.
        To achieve this, we use a semaphore initialized with (n-1) permits.

    </p>

    <p>
        <b>Global Semaphore class: </b>Philosophers have to acquire one of the permits before they are allowed to pick up.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class MultiPermitSemaphore {
    Semaphore semaphore;

    MultiPermitSemaphore(int nrPhilosophers) {
        // enable fairness parameter to prevent barging
        semaphore = new Semaphore(nrPhilosophers - 1, true);
    }

}
    </code></pre>
    <p>
        <b>Philosopher class:</b>
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class RestrictPhilosopher extends Philosopher {

        GlobalSemaphore multiPermitSemaphore;

        public RestrictPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, GlobalSemaphore multiPermitSemaphore) {
            super(id, leftChopstick, rightChopstick);
            this.multiPermitSemaphore = multiPermitSemaphore;
        }

        @Override
        void run() {

            while (!terminated()) {
                think();
                multiPermitSemaphore.semaphore.acquire(); // acquire the semaphore before pickup, one philosopher will always be blocked
                pickUpLeftChopstick();
                pickUpRightChopstick();
                multiPermitSemaphore.semaphore.release(); // release the semaphore after pickup
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
            }
        }
    }
    </code></pre>

    <h3>Restrict Solution Evaluation</h3>

    <p>Now let us evaluate the Restrict Solution based on the key challenges and performance in simulations:</p>
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
            <td>By limiting the number of philosophers allowed to attempt pick-up to (n-1), we break the circular wait condition, as defined by Coffman.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Starvation-free: Due to the enabled fairness parameter (prevents barging) and the immediate pickup after put-down (FIFO-enhanced pickup), starvation is prevented.
                Eat-chance and time-fairness depend heavily on the chosen distribution and are not managed here.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Limited: Good concurrency is possible, but in many situations long waiting chains occur, leading to low or no concurrency in simulation runs.  </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>
                The changes required to implement this solution are very simple using the Java Semaphore mechanism.
                It is important to keep in mind that the queueing has to be enabled via the fairness parameter
                to prevent starvation due to repeated barging.
            </td>
        </tr>
        <tr>
            <td><b>Performance: </b></td>
            <td>
                There is a moderate overhead using the multiple-permit Semaphore. The approach is also scalable, but highly dependent on the semaphore implementation.
                Compared to a waiter that has to process requests one after another and having to maintain a queue, the semaphore will usually be more light-wait. (usually only 1 philosopher waiting in the queue of the multi-permit semaphore)</td>
            </tr>
        </tbody>
    </table>





    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=RESTRICT" class="button">Restrict Simulation</a>
    <a href="../animation/?algorithm=RESTRICT" class="button">Restrict Animation</a>


    <div class="separator"></div>


    <h2>Tanenbaum Solution</h2>
    <p>
        This classic Solution was proposed by Andrew S. Tanenbaum in his famous book "Modern Operating Systems".
        We introduce a Monitor that utilizes a fair Semaphore as a mutex and maintains an array of Semaphores per philosopher that they need to acquire before eating.
        Additionally, we maintain an array that contains the current states of all philosophers.
        The process is as follows:
    </p>
    <ul>
        <li>Philosophers Think (State is initially set to "Thinking")</li>
        <li>Philosophers acquire the Monitors Semaphore and update their state to "Hungry", and call the test() function to determine whether the two adjacent philosophers are not eating.
            Subsequently, the monitor semaphore is released. If this test is successful (no neighbor eats), philosophers update their state to "Eating" and the respective semaphore in the array is released.</li>
        <li>Once their respective semaphore is released, the philosophers start eating, if not, they wait until the semaphore is released in a later call to the test() function.</li>
        <li>When philosophers are done eating, they will again acquire the monitor semaphore and call the test() function on both their neighbors. This enables the neighbors to check again whether either of the two adjacent philosophers is currently eating. If this is the case they will continue to wait until a later call to the test() function</li>
        <li>Finally, they set their state to "Thinking" and release the monitors semaphore, and the process starts anew</li>
    </ul>

    <p>
        <b>Monitor class: </b>
        The access to the Monitor is exclusive via the philosophers usage of the Monitor Semaphore (called mutex here).
        We use arrays to keep track of the philosophers' states and an array that contains a semaphore for each philosopher.
        The monitor class is very similar to a waiter, but philosophers do not ask the monitor for permission,
        therefor the different naming.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class Monitor {
    // array to keep track of the philosophers states
    String[] states;
    // array of semaphores per philosopher
    Semaphore[] semaphores;
    Semaphore mutex;

    Monitor(int nrPhilosophers) {
        states = new String[nrPhilosophers];
        semaphores = new Semaphore[nrPhilosophers];
        for (int i = 0; i < nrPhilosophers; i++) {
            //all philosophers think initially
            states[i] = Events.THINK;
            // initialize semaphores with 0 permissions
            semaphores[i] = new Semaphore(0);
        }
        // enable fairness parameter and initialize semaphore to one permit for mutual exclusion
        mutex = new Semaphore(1, true);
    }

    // tests whether either the two adjacent philosophers is currently eating
    // when no neighbor is eating the semaphore is released
    void test(int id) {
        int left = (id + states.length - 1) % states.length;
        int right = (id + 1) % states.length;

        if (states[id] == Events.HUNGRY &&
            states[left] != Events.EAT &&
            states[right] != Events.EAT) {

            states[id] = Events.EAT;

            // release the semaphore of the philosopher that can now eat
            semaphores[id].release();
        }
    }
}

    </code></pre>
    <p>
        <b>Philosopher class:</b>
        Philosophers need to acquire their semaphore to eat.
        The semaphore is released via the test() method.
        If the initial test() failed, philosophers have to wait until a neighbor calls it on them.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">
class TanenbaumPhilosopher extends Philosopher {

    Monitor monitor;

    tanenbaumPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Monitor monitor) {
        super(id, leftChopstick, rightChopstick);
        this.monitor = monitor;
    }

    @Override
    void run() {
        while (!terminated()) {
            think();
            pickUp();
            eat();
            putDown();
        }
    }

    void pickUp() {
        monitor.mutex.acquire(); // gain exclusive access to the monitor

        // update the state to hungry
        monitor.states[id] = Events.HUNGRY;

        // test whether eating is possible
        monitor.test(id);

        // release exclusive access to the monitor
        monitor.mutex.release();

        // wait until test() is called on self successfully
        monitor.semaphores[id].acquire();

        pickUpLeftChopstick();
        pickUpRightChopstick();
    }

    void putDown() {
        putDownLeftChopstick();
        putDownRightChopstick();

        // gain exclusive access to the monitor
        monitor.mutex.acquire();

        // update the state to thinking
        monitor.states[id] = Events.THINK;
        int left = (id + monitor.states.length - 1) % monitor.states.length;
        int right = (id + 1) % monitor.states.length;

        // test for each neighbour
        monitor.test(left);
        monitor.test(right);

        // release exclusive access to the monitor
        monitor.mutex.release();
    }
}


    </code></pre>

    <h3>Tanenbaum Solution Evaluation </h3>

    <p>Now let us evaluate the Tanenbaum solution based on the key challenges and performance in simulations:</p>

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
            <td>Prevents deadlocks by avoiding the circular-wait condition. Only philosophers who have both chopsticks available may proceed. </td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Unfortunately, the Tanenbaum Solution is not starvation-free.
                There are repeating patterns where a philosophers neighbors can alternate eating.
                This philosopher then never gets a chance to eat due to a repeated failing of the test.
                Indefinite starvation scenarios are not very likely but still theoretically possible.
                Since we do not prevent starvation, there is no guaranteed fairness in the system.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>This algorithm theoretically allows for a maximum degree of concurrency. The test() function only permits ideal philosophers.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The implementation is more complex than some of the simpler solutions to the problem. We need to be careful about the correct setting of states and correctly synchronized access to the monitor.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a modest overhead due to the management of the philosophers via the monitor and the maintained arrays. Similar to the discussed Waiter solutions, the utilization of a monitor limits the scalability of this approach.</td>
        </tr>
        </tbody>
    </table>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TANENBAUM" class="button">Tanenbaum Simulation</a>
    <a href="../animation/?algorithm=TANENBAUM" class="button">Tanenbaum Animation</a>



    <div class="separator"></div>

    <h2>Fair Tanenbaum Solution</h2>
    <p>
        We can try to enhance the performance and fairness of the Tanenbaum solution by tracking the eat-chances/ eat-times.
        For this purpose, we maintain an additional array of eat chances/eat times that is updated whenever philosophers are done eating.
        We then check this array whenever a philosopher puts the chopsticks down.
        Instead of calling test() on the two adjacent philosophers, we now call the test() function on all philosophers, prioritized by the previously tracked eat-chances.
    </p>

    <p>
        <b>Monitor class:</b>
        We now call the test() method on all philosophers after a pick-up.
        To promote fairness, we reorder the philosophers according to their eat-chances,
        and call those who had the least chance/ time to eat first.
        The "eat-time alternative:" comments highlight the sections of code that need to be changed to account for eat-time fairness.
    </p>
    <pre style="font-size: 14px;"><code class="language-java">

    class FairTanenbaumMonitor {

    // array to keep track of the philosophers states
    String[] states;
    // array of semaphores per philosopher
    Semaphore[] semaphores;
    // array to track the number of times each philosopher has eaten
    // eat-time alternative: long[] eatTimes;
    int[] eatChances;
    Semaphore mutex;

    FairTanenbaumMonitor(int nrPhilosophers) {
        //eat-time alternative eatTimes = new long[nrPhilosophers];
        eatChances = new int[nrPhilosophers];

        states = new String[nrPhilosophers];
        semaphores = new Semaphore[nrPhilosophers];
        for (int i = 0; i < nrPhilosophers; i++) {
            // all philosophers think initially
            states[i] = Events.THINK;
            semaphores[i] = new Semaphore(0);
        }
        // enable fairness parameter and initialize semaphore to one permit for mutual exclusion
        mutex = new Semaphore(1, true);
    }

    // tests whether either the two adjacent philosophers is currently eating
    // when no neighbor is eating the semaphore is released
    void test(int id) {
        int left = (id + states.length - 1) % states.length;
        int right = (id + 1) % states.length;

        if (states[id] == Events.HUNGRY &&
            states[left] != Events.EAT &&
            states[right] != Events.EAT) {

            states[id] = Events.EAT;

            // release the semaphore of the philosopher that can eat now
            semaphores[id].release();
        }
    }

    //called by philosophers to upadate for current eat-chances
    //eat-time alternative: void updateEatTimes(int id, long eatTime)
    void updateEatChances(int id) {
        // increment the number of times the philosopher has eaten
        // eat-time alternative: eatTimes[id] += eatTime;

        eatChances[id]++;
    }

    void updateState(int id, String state) {
        // update the state of the specified philosopher
        states[id] = state;
    }

    void checkAll() {
        // sort philosophers by how many times they have eaten
        // eat-time alternative: sort by least cumulated eat-time
        int[] sortedIndices = sortByEatChances();

        // call test() in order from least to most eat-chances/ eat-time
        for (int index : sortedIndices) {
            test(index);
        }
    }

    int[] sortByEatChances() {
        // create an array to hold cumulated eat-chances/eat-time with indices
        CumulatedWithIndex[] sortArray = new CumulatedWithIndex[eatChances.length];
        for (int i = 0; i < eatChances.length; i++) {

        // fill the array with eat times and corresponding philosopher index
            sortArray[i] = new CumulatedWithIndex(eatChances[i], i);
        }

        // sort the array by eat chances/ eat-time in ascending order
        Arrays.sort(sortArray, Comparator.comparingInt(e -> e.eatChances));

        // create an array to hold sorted philosopher indices
        int[] sortedIndices = new int[eatChances.length];
        for (int i = 0; i < sortArray.length; i++) {
            // extract the philosopher indices from the sorted array
            sortedIndices[i] = sortArray[i].index;
        }

        return sortedIndices;
    }

    // class to intermediately store ids + cumulated eat-chances/ eat-time per philosopher
    static class CumulatedWithIndex {
        // stores the number of times a philosopher has eaten
        // eat-time alternative: long eatTimes;
        int eatChances;

        int index;

        //eat-time alternative: CumulatedWithIndex(long eatTimes, int index) {}
        CumulatedWithIndex(int eatChances, int index) {

            // initialize eat chances
            // eat-time alternative: this.eatTimes = eatTimes;
            this.eatChances = eatChances;

            // initialize philosopher ID
            this.index = index;
        }
    }
}


    </code></pre>

    <p>
        <b>Philosopher class:</b>
    </p>

    <pre style="font-size: 14px;"><code class="language-java">
    class FairTanenbaumPhilosopher extends Philosopher {

    FairTanenbaumMonitor monitor;

    FairTanenbaumPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, FairMonitor monitor) {
        super(id, leftChopstick, rightChopstick);
        this.monitor = monitor;
    }

    @Override
    void run() {
        while (!terminated()) {
            think();
            pickUp();
            eats();
            putDown();
        }
    }

    void pickUp() {
        // gain exclusive access to the monitor
        monitor.mutex.acquire();

        // update the state to hungry
        monitor.updateState(id, Events.HUNGRY);

        // test whether eating is possible
        monitor.test(id);

        // release exclusive access to the monitor
        monitor.mutex.release();

        // wait until test() is called on self successfully
        monitor.semaphores[id].acquire();

        pickUpLeftChopstick();
        pickUpRightChopstick();
    }

    void eats() {
        //eat-time alternative: long duration = eatFair();
        eat();

        // gain exclusive access to the monitor
        monitor.mutex.acquire();

        // update the number of times the philosopher has eaten
        // eat-time alternative: monitor.updateEatTimes(id, duration)
        monitor.updateEatChances(id);

        // release exclusive access to the monitor
        monitor.mutex.release();
    }

    void putDown() {
        putDownLeftChopstick();
        putDownRightChopstick();

        // gain exclusive access to the monitor
        monitor.mutex.acquire();

        // update the philosophers state to thinking
        monitor.updateState(id, Events.THINK);

        // call test() on all philosophers prioritized by least eat-chances/ eat-times
        monitor.checkAll();

        // release exclusive access to the monitor
        monitor.mutex.release();
    }
    /*
    // eat-time alternative:
    // modified eat() method for tracking times spent eating
    long eatFair() {
        //calculate sleep time according to distribution
        Long duration = calculateDuration();
        sleep(duration);
        sbLog("[ E ]", VirtualClock.getTime());
        return duration;
    }
    */
}

    </code></pre>




    <h3>Fair Tanenbaum Solution Evaluation </h3>

    <p>
        Now let us evaluate the Fair Tanenbaum solution based on the key challenges and performance in simulations:
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
            <td>Deadlock-free, as deadlocks are prevented by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation and Fairness</b></td>
            <td>
                Situations where philosophers are being skipped, even if prioritized by least eat-chance/ eat-time, are possible.
                Therefore, this solution is prone to starvation.
                Unfortunately there seems to be only a slim chance of improving eat-chance or eat-time fairness in certain execution orders.
            </td>
        </tr>

        <tr>
            <td><b>Concurrency</b></td>
            <td>Again potentially ideal concurrency. In this approach, we still prioritize concurrent performance over fairness and permit only ideal philosophers to eat. </td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are a little more extensive compared to the "simple" Tanenbaum Solution. We need to take good care that the states and eat-chances are managed correctly.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>As with the Tanenbaum Solution, we produce an overhead by using the state and semaphore arrays.
                Additionally, we now sort the philosophers in a separate array after each put-down, producing significant computational effort.
                This further limits the scalability of this approach, as philosophers will have to wait while the waiter reorders the eating states.
                The usage of insertion sort in this approach (which has a complexity of n<sup>2</sup>) would indeed scale poorly and force long waiting times in systems with larger numbers of philosophers.</td>
        </tr>
        </tbody>
    </table>



    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=FAIR_CHANCE_TANENBAUM" class="button">Fair Tanenbaum (Chance-based) Simulation</a>
    <a href="../animation/?algorithm=FAIR_CHANCE_TANENBAUM" class="button">Fair Tanenbaum (Chance-based) Animation</a>
    <a href="../simulation/?algorithm=FAIR_TIME_TANENBAUM" class="button">Fair Tanenbaum (Time-based) Simulation</a>
    <a href="../animation/?algorithm=FAIR_TIME_TANENBAUM" class="button">Fair Tanenbaum (Time-Based) Animation</a>



</div>

<a href="../distributed/" class="button">➡ Next: Distributed Solutions ➡</a>
</body>
</html>
