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
</head>
<body>
<h2>Semaphore Solutions</h2>
<div class="description">
    <p>
        Semaphores are a frequently used synchronization mechanism for concurrent systems to manage access to resources.
        The concept was introduced to the computer science community by none other than Edsger Dijkstra himself.
        In the following we will use Binary semaphores, which can only take values 0 and 1, this means they will allow
        access to one thread only (also called mutex).
        The resource is accessible if a semaphore has value 1. The acquiring thread will then decrease the value and the
        semaphore will be locked.
        Threads trying to acquire a locked semaphore will usually be put into an implicit queue, waiting for the time
        the initial thread releases the semaphore,
        after which they will be the permitted thread.
    </p>
    <img src="../pictures/semaphore.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <div class="separator"></div>

    <h2>Table Semaphore Solution</h2>
    <p>
        Locking the whole table with a semaphore is the simplest solution to avoid deadlocks for the dining
        philosophers.
        Philosophers have to acquire the semaphore before picking up their chopsticks,
        if the semaphore is currently not available, they wait until it becomes free again. After they are done picking
        up, they release the semaphore, and another philosopher can proceed.
        Functionally, this approach is similar to the previously presented Pickup Waiter Solution.
        In fact, it could even be argued, that in this case the Semaphore acts as an implicit waiter, because it maintains a FIFO queue, due to the enabled fairness parameter.
        This approach is therefore useful for an introductory example on how semaphores work in principle.
    </p>

    <p>
        <b>Table Semaphore class:</b>
        We have to enable the fairness parameter of the Semaphore in Java.
    </p>
    <pre><code>
        class TableSemaphore {
            Semaphore semaphore;

            TableSemaphore(){
                semaphore = new Semaphore(1, true); //fairness parameter set to true
            }
        }
    </code></pre>

    <p>
        <b>Philosopher class:</b>
        Philosophers need to acquire the table semaphore before picking up their
        chopsticks and release it, once they are finished picking up.
    </p>
    <pre><code>
        class TableSemaphorePhilosopher extends Philosopher {

            final Semaphore semaphore;
            TableSemaphorePhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, TableSemaphore tableSemaphore) {
                super(id, leftChopstick, rightChopstick);
                this.semaphore = tableSemaphore.semaphore;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();

                    //acquire the table-semaphore before pickup
                    semaphore.acquire();
                    pickUpLeftChopstick();
                    pickUpRightChopstick();

                    //release semaphore after pickup
                    semaphore.release();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();

                }
            }

        }

    </code></pre>

    <h3>Table Semaphore Solution Evaluation </h3>

    <p>Now let us evaluate the Table Semaphore solution based on the key-challenges:</p>
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
            <td>The Table Semaphore approach prevents deadlocks by avoiding the circular-wait condition.</td>
        </tr>
        <tr>
            <td><b>Starvation</b></td>
            <td>Starvation is prevented due to the implicit semaphore-queue, which eventually allows all philosophers to eat.</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>Fair eat-chance, as philosophers will eventually get the chance to eat when they try to acquire the table-semaphore. Note that the utilization of the fairness is crucial to prevent barging and to enable the implicit FIFO queue. Eat-time fairness is highly dependent on the chosen distribution and is not managed by this algorithm explicitly.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>There is a possibility for high concurrency, but similar to the Pickup Waiter Solution, philosophers adjacent to eating neighbors may acquire the semaphore. To manage this, we could introduce a monitor to the solution; however, there is a smarter solution called the Tanenbaum solution, which we will explore soon.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The utilization of semaphores in this way proves to be very simple and requires only minimal modifications to the philosopher class.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a very slight performance overhead due to the globally accessed semaphore.</td>
        </tr>
        </tbody>
    </table>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Animation</a>




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
            If this test is successful they update their state to "Eating" and the monitors semaphore is released.</li>
        <li>Once their respective semaphore is released the philosophers start eating, if not, they wait until the semaphore is released in a later call to the test() function.</li>
        <li>When philosophers are done eating they will again acquire the monitor semaphore and call the test() function on both their neighbours, enabling them to check whether either the two adjacent philosophers is currently eating, if this is the case they will continue to wait.</li>
        <li>Finally, they set their state to "Thinking" and release the monitors semaphore and the process starts anew</li>
    </ul>

    <p>
        <b>Monitor class: </b>
        The access to the Monitor is exclusive via the philosophers usage of the Monitor Semaphore (called mutex here).
        We use arrays to keep track of the philosophers states and an array that contains a semaphore for each philosopher.
    </p>
    <pre><code>
        [Pseudocode]

        class Monitor {

            String[] states; //array to keep track of the philosophers states
            Semaphore[] semaphores;
            Semaphore mutex; //semaphore to gain exclusive access to the monitor

            Monitor(int nrPhilosophers) {
                states = new String[nrPhilosophers];
                semaphores = new Semaphore[nrPhilosophers];
                for (int i = 0; i < nrPhilosophers; i++) {
                    states[i] = Events.THINK;
                    semaphores[i] = new Semaphore(0); //initialize to no initial permission
                }
                mutex = new Semaphore(1, true); //enable fairness parameter and initialize semaphore to one permit for mutual exclusion
            }

            //tests whether either the two adjacent philosophers is currently eating
            void test(int id) {
                int left = (id + states.length - 1) % states.length;
                int right = (id + 1) % states.length;

                if (states[id] == Events.HUNGRY &&
                    states[left] != Events.EAT &&
                    states[right] != Events.EAT) {

                    states[id] = Events.EAT;
                    semaphores[id].release(); //release the semaphore of the philosopher that can now eat
                }
            }
        }

    </code></pre>
    <p>
        <b>Philosopher class:</b>
        Philosophers need to acquire their respective semaphore to start eating.
        The semaphore is released via the test() method.
        If the initial test failed philosophers have to wait until a neighbour calls it again on them.
    </p>
    <pre><code>
        [Pseudocode]

        class tanenbaumPhilosopher extends Philosopher {

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
                monitor.mutex.acquire(); //gain exclusive access to the monitor
                monitor.states[id] = Events.HUNGRY; //update the state to hungry
                monitor.test(id); //test whether eating is possible
                monitor.mutex.release(); //release exclusive access to the monitor

                monitor.semaphores[id].acquire(); // has to be released by the test() method

                pickUpLeftChopstick();
                pickUpRightChopstick();
            }

            void putDown() {
                putDownLeftChopstick();
                putDownRightChopstick();

                monitor.mutex.acquire(); //gain exclusive access to the monitor
                monitor.states[id] = Events.THINK; //update the state to thinking
                int left = (id + monitor.states.length - 1) % monitor.states.length;
                int right = (id + 1) % monitor.states.length;

                //test for each neighbour
                monitor.test(left);
                monitor.test(right);

                monitor.mutex.release(); //release exclusive access to the monitor
            }
        }


    </code></pre>

    <h3>Tanenbaum Solution Evaluation </h3>

    <p>Now let us evaluate the Tanenbaum solution based on the key-challenges:</p>
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
            <td><b>Starvation</b></td>
            <td>Sadly, the Tanenbaum Solution is not starvation-free. Since we only test the left and right philosophers after a put-down, we cannot guarantee that every philosopher will eventually get a chance to eat. Starvation scenarios are not very likely but still possible.</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>Since we do not avoid starvation, there is no fairness in the system.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>This algorithm achieves good concurrency results, but the calling of the <code>test()</code> function on only the two neighbors often leads to situations where a philosopher could eat but cannot because neighboring philosophers are currently blocked.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The implementation is more complex than some of the simpler solutions to the problem. We need to be careful about the correct setting of states and correctly synchronized access to the monitor.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>There is a modest overhead due to the management of the philosophers via the monitor and the maintained arrays. Similar to the discussed waiter solutions, the utilization of a monitor limits the scalability of this approach.</td>
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
        We can try to enhance the performance, including fairness, of the Tanenbaum solution by tracking the eat-chances.
        For this purpose we maintain an additional array of eat times that is updated whenever philosophers are done eating.
        We then check this array whenever a philosopher puts the chopsticks down.
        Instead of calling test() on the two adjacent philosophers we now call the test() function on all philosophers, prioritized by the previously tracked eat-chances.
    </p>

    <p>
        <b>Monitor class:</b>
        We now call the test() method on all philosophers after a pick-up.
        To promote fairness we reorder the philosophers according to their eat-chances,
        and call those who had the least chances to eat first.
    </p>
    <pre><code>
        [Pseudocode]
        class FairMonitor {

            String[] states; // array to track the states
            Semaphore[] semaphores;
            int[] eatTimes; // array to track the number of times each philosopher has eaten
            Semaphore mutex; // Semaphore for mutual exclusion for accessing the monitor

            FairMonitor(int nrPhilosophers) {
                eatTimes = new int[nrPhilosophers];
                states = new String[nrPhilosophers];
                semaphores = new Semaphore[nrPhilosophers];
                for (int i = 0; i < nrPhilosophers; i++) {
                    states[i] = Events.THINK; // All philosophers start in the think state
                    semaphores[i] = new Semaphore(0);
                }
                mutex = new Semaphore(1, true); // mutex starts with one permit for mutual exclusion, enable fairness parameter
            }

            void test(int id) {
                int left = (id + states.length - 1) % states.length;
                int right = (id + 1) % states.length;

                // If the philosopher is hungry and both neighbors are not eating, allow the philosopher to eat
                if (states[id] == Events.HUNGRY &&
                    states[left] != Events.EAT &&
                    states[right] != Events.EAT) {

                    states[id] = Events.EAT; // update the philosophers state to eating
                    semaphores[id].release(); // grant permission for the philosopher to proceed
                }
            }

            void updateEatTime(int id) {
                eatTimes[id]++; // Increment the number of times the philosopher has eaten
            }

            void updateState(int id, String state) {
                states[id] = state; // Update the state of the specified philosopher
            }

            void checkAll() {
                int[] sortedIndices = sortByEatingTimes(); // sort philosophers by how many times they have eaten
                // test each philosopher in the sorted order to ensure fair access
                for (int index : sortedIndices) {
                    test(index);
                }
            }

            int[] sortByEatingTimes() {
                EatTimeWithIndex[] sortArray = new EatTimeWithIndex[eatTimes.length]; // create an array to hold eat times with indices
                for (int i = 0; i < eatTimes.length; i++) {
                    sortArray[i] = new EatTimeWithIndex(eatTimes[i], i); // populate the array with eat times and corresponding philosopher IDs
                }

                Arrays.sort(sortArray, Comparator.comparingInt(e -> e.eatTime)); // sort the array by eat times in ascending order

                int[] sortedIndices = new int[eatTimes.length]; // create an array to hold sorted philosopher IDs
                for (int i = 0; i < sortArray.length; i++) {
                    sortedIndices[i] = sortArray[i].index; // extract the philosopher IDs from the sorted array
                }

                return sortedIndices; // return the sorted philosopher IDs
            }

            static class EatTimeWithIndex {
                int eatTime; // stores the number of times a philosopher has eaten
                int index; // stores the philosopher's ID

                eatTimeWithIndex(int eatTime, int index) {
                    this.eatTime = eatTime; // initialize eat time
                    this.index = index; // initialize philosopher ID
                }
            }
        }

    </code></pre>

    <p>
        <b>Philosopher class:</b>
    </p>

    <pre><code>
        class FairTanenbaumPhilosopher extends Philosopher {

            FairMonitor monitor;

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
                monitor.mutex.acquire(); // gain exclusive access to the monitor
                monitor.updateState(id, Events.HUNGRY); // update the philosopher's state to hungry
                monitor.test(id); // Test if the philosopher can start eating
                monitor.mutex.release(); // release exclusive access to the monitor

                monitor.semaphores[id].acquire(); // wait until permission is granted to proceed

                pickUpLeftChopstick();
                pickUpRightChopstick();
            }

            void eats() {
                eat(); // Simulate eating
                monitor.mutex.acquire(); // gain exclusive access to the monitor
                monitor.updateEatTime(id); // update the number of times this philosopher has eaten
                monitor.mutex.release(); // release exclusive access to the monitor
            }

            void putDown() {
                putDownLeftChopstick();
                putDownRightChopstick();

                monitor.mutex.acquire(); // gain exclusive access to the monitor
                monitor.updateState(id, Events.THINK); // update the philosopher's state to thinking
                monitor.checkAll(); // re-evaluate all philosophers to allow the next one to eat
                monitor.mutex.release(); // release exclusive access to the monitor
            }
        }

    </code></pre>

    <h3>Fair Tanenbaum Solution Evaluation </h3>

    <p>
        Now let us evaluate the Fair Tanenbaum solution based on the key-challenges:
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
            <td><b>Starvation</b></td>
            <td>We now test for each philosopher whenever a put-down is completed. This theoretically lets us avoid starvation.</td>
        </tr>
        <tr>
            <td><b>Fairness</b></td>
            <td>The test order after a put-down occurs is sorted by the philosophers who have eaten the least. This means that the "poorest" philosophers are always tested first, before we proceed to others. This should ensure that, even if they are currently not able to eat, they will eventually get the chance to do so in a later iteration.</td>
        </tr>
        <tr>
            <td><b>Concurrency</b></td>
            <td>In this approach, we still prioritize concurrent performance over fairness. This results in very high concurrency results while still taking fairness into account.</td>
        </tr>
        <tr>
            <td><b>Implementation</b></td>
            <td>The changes required to implement this solution are a little more extensive compared to the "simple" Tanenbaum Solution. We need to take good care that the states and eat-chances are managed correctly.</td>
        </tr>
        <tr>
            <td><b>Performance</b></td>
            <td>As with the Tanenbaum Solution, we produce a modest overhead by using the arrays. We now also have to sort the order of the testing after each put-down. This further limits the scalability of this approach, as philosophers will have to wait while the waiter reorders the eating states. The usage of insertion sort in this approach (which has a complexity of <code>n<sup>2</sup></code>) would indeed scale poorly and force long waiting times in systems with larger numbers of philosophers.</td>
        </tr>
        </tbody>
    </table>


    <p>
        On the Simulation Animation pages you can find both the fair-chance and fair-time algorithms.
        The above implementation can easily be changed to account for eat-time fairness, changing just a few lines of code.#
        If you want more details about how this change could be done, it is shown in the Fair Waiter Solution.

    </p>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=FAIR_CHANCE_TANENBAUM" class="button">Fair Eat Chance Tanenbaum Simulation</a>
    <a href="../animation/?algorithm=FAIR_CHANCE_TANENBAUM" class="button">Fair Eat Chance Tanenbaum Animation</a>
    <a href="../simulation/?algorithm=FAIR_TIME_TANENBAUM" class="button">Fair Eat Time Tanenbaum Simulation</a>
    <a href="../animation/?algorithm=FAIR_TIME_TANENBAUM" class="button">Fair Eat Time Tanenbaum Animation</a>



</div>
</body>
</html>
