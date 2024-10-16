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
<h2>Semaphore Solutions</h2>
<div class="description">
    <p>
        Semaphores are a frequently used synchronization mechanism for concurrent systems to manage access to resources.
        The concept was introduced to the computer science community by none other than Edsger Dijkstra himself.
        They are primarily used to prevent race conditions and deadlocks.
        In the following we will use Binary semaphores, which can only take values 0 and 1, this means they will allow
        access to one thread only (also called mutex).
        The resource is accessible if a semaphore has value 1. The acquiring thread will then decrease the value and the
        semaphore will be locked.
        Threads trying to acquire a locked semaphore will usually be put into an implicit queue, waiting for the time
        the initial thread releases the semaphore,
        after which they will be the permitted thread.
    </p>
    <img src="../pictures/semaphore.svg" alt="Dining Philosophers Problem" width="400" height="350">


    <h2>Table Semaphore Solution</h2>
    <p>
        Locking the whole table with a semaphore is the simplest solution to avoid deadlocks for the dining
        philosophers.
        Philosophers have to acquire the semaphore before picking up their chopsticks,
        if the semaphore is currently not available, they wait until it becomes free again. After they are done picking
        up,
        they release the semaphore, and another philosopher can proceed.
        Functionally, this approach is equivalent to the previously presented Pickup Waiter Solution.
        and is therefore useful for an introductory example on how to avoid deadlocks using semaphores.
    </p>

    <p>
        The implementation is fairly simple: Philosophers need to acquire the table semaphore before eating.
        To ensure fairness of the philosophers we have to enable the fairness parameter of the Semaphore in Java.
        First we introduce a Semaphore for our table:
    </p>
    <pre><code>
        class TableSemaphore {
            Semaphore semaphore;

            TableSemaphore(){
                semaphore = new Semaphore(1, true);
            }
        }
    </code></pre>

    <p>
        Then we let the philosophers acquire this semaphore before eating.
        Volatile in the context of Java means that the value of a variable should not be cached, as it could be changed
        by another thread.
        To achieve this we create a subclass and add the respective changes:
    </p>
    <pre><code>
        class TableSemaphorePhilosopher extends Philosopher {

            volatile Semaphore semaphore;
            TableSemaphorePhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, TableSemaphore tableSemaphore) {
                super(id, leftChopstick, rightChopstick);
                this.semaphore = tableSemaphore.semaphore;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();
                    semaphore.acquire();
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    semaphore.release();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();

                }
            }

        }

    </code></pre>

    <p>Now let us evaluate the Table Semaphore solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Simulation</a>
    <a href="../animation/?algorithm=TABLESEMAPHORE" class="button">Table Semaphore Animation</a>




    <h2>Dijkstra Solution</h2>
    <p>
        After looking at the Table Semaphore Solution let us now take a look at a solution that was proposed by the
        creator of the Dining Philosophers Problem, Edsger Dijkstra.
        In this solution philosophers first think and then try to acquire their first chopstick, if they fail to pick it
        up, they wait for some time and try again.
        After they acquired their first chopstick they will immediately try to pick up the second one, if this is
        unsuccessful they put down the initial chopstick and after some time they will try to acquire their first
        chopstick again.
        This repeats itself until the philosophers are able to eat.
        This solution lets us avoid deadlocks via avoiding the Hold-and-wait condition as defined by Coffman.

    </p>
    <p>

    </p>
    <pre><code>
        public class DijkstraPhilosopher extends Philosopher {
            public DijkstraPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                super(id, leftChopstick, rightChopstick);
            }

            @Override
            public void run() {

                while (!terminated()) {
                    think();
                    boolean bothSuccessful = false;
                    while (!bothSuccessful) {
                        boolean firstSuccessful = pickUpLeftChopstickDijkstra();
                        if (firstSuccessful) {
                            boolean secondSuccessful = pickUpRightChopstickDijkstra();
                            if (secondSuccessful) {
                                bothSuccessful = true;
                                eat();
                            } else {
                                putDownLeftChopstick();
                                int random = (int) (Math.random() * 100) + 1;
                                Thread.sleep(random);
                            }
                        } else {
                            int random = (int) (Math.random() * 100) + 1;
                            Thread.sleep(random);
                        }
                    }

                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }

            protected boolean pickUpLeftChopstickDijkstra(){
                boolean successful = leftFork.pickUp(this);
                if (successful) sbLog("[PUL]", VirtualClock.getTiChopstick);

                return successful;
            }

            protected boolean pickUpRightChopstickDijkstra() {
                boolean successful = rightChopstick.pickUp(this);
                if (successful) sbLog("[PUR]", VirtualClock.getTime());
                return successful;
            }
        }
    </code></pre>
    <p>
        And here the Dijkstra Chopstick class.
    </p>
    <pre><code>
        public class DijkstraChopstick extends Chopstick {
            public DijkstraChopstick(int id) {
                super(id);
                chopstickSemaphore = new Semaphore(1);
            }

            Semaphore chopstickSemaphore;

            @Override
            public synchronized boolean pickUp(Philosopher philosopher) {
                return chopstickSemaphore.tryAcquire();
            }

            public synchronized void putDown(Philosopher philosopher) {
                chopstickSemaphore.release();
            }
        }
    </code></pre>

    <p>Now let us evaluate the Dijkstra Solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=DIJKSTRA" class="button">Dijkstra Simulation</a>
    <a href="../animation/?algorithm=DIJKSTA" class="button">Dijkstra Animation</a>






    <h2>Tanenbaum Solution</h2>
    <p>
        This classic Solution was proposed by Andrew S. Tanenbaum in his famous book "Modern Operating Systems".
        We introduce a Monitor that utilizes a fair Semaphore as a mutex and maintains an array of Semaphores per philosopher that they need to acquire before eating.
        Additionally, we maintain an array that contains the current states of all philosophers.
        The process is as follows:
    </p>
    <ul>
        <li>Philosophers Think (State is initially set to ""Thinking)</li>
        <li>Philosophers acquire the Monitors Semaphore and update their state to "Hungry", and call the test() function to determine whether the two adjacent philosophers are not eating.
            If this test is successful they update their state to "Eating" and the monitors semaphore is released.</li>
        <li>Once their respective semaphore is released the philosophers start eating, if not, they wait until the semaphore is released in a later call to the test() function.</li>
        <li>When philosophers are done eating they will again acquire the monitor semaphore and call the test() function on both their neighbours, enabling them to check whether either the two adjacent philosophers is currently eating, if this is the case they will continue to wait.</li>
        <li>Finally, they set their state to "Thinking" and release the monitors semaphore and the process starts anew</li>
    </ul>

    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class Monitor {

            String[] states;
            Semaphore[] semaphores;
            Semaphore mutex;

            Monitor(int nrPhilosophers) {
                states = new String[nrPhilosophers];
                semaphores = new Semaphore[nrPhilosophers];
                for (int i = 0; i < nrPhilosophers; i++) {
                    states[i] = Events.THINK;
                    semaphores[i] = new Semaphore(0);
                }
                mutex = new Semaphore(1);
            }

            void test(int id) {
                int left = (id + states.length - 1) % states.length;
                int right = (id + 1) % states.length;

                if (states[id] == Events.HUNGRY &&
                    states[left] != Events.EAT &&
                    states[right] != Events.EAT) {

                    states[id] = Events.EAT;
                    semaphores[id].release();
                }
            }
        }

    </code></pre>

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
                monitor.mutex.acquire();
                monitor.states[id] = Events.HUNGRY;
                monitor.test(id);
                monitor.mutex.release();

                monitor.semaphores[id].acquire();

                pickUpLeftChopstick();
                pickUpRightChopstick();
            }

            void putDown() {
                putDownLeftChopstick();
                putDownRightChopstick();

                monitor.mutex.acquire();
                monitor.states[id] = Events.THINK;
                int left = (id + monitor.states.length - 1) % monitor.states.length;
                int right = (id + 1) % monitor.states.length;
                monitor.test(left);
                monitor.test(right);
                monitor.mutex.release();
            }
        }


    </code></pre>
    <p>

    </p>

    <p>Now let us evaluate the Tanenbaum solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TANENBAUM" class="button">Tanenbaum Simulation</a>
    <a href="../animation/?algorithm=TANENBAUM" class="button">Tanenbaum Animation</a>




    <h2>Fair Tanenbaum Solution</h2>
    <p>
        We can try to enhance the fairness of the Tanenbaum solution by tracking the eat-chances.
        For this purpose we maintain an additional array of eat times that is updated whenever philosophers are done eating.
        We then check this array whenever a philosopher puts the chopsticks down.
        Instead of calling test() on the two adjacent philosophers we now call the test() function on all philosophers, prioritized by the previously tracked eat-chances.
    </p>

    <pre><code>
        [Pseudocode]

        class FairMonitor {

            String[] states;
            Semaphore[] semaphores;
            int[] eatTimes;
            Semaphore mutex;

            FairMonitor(int nrPhilosophers) {
                eatTimes = new int[nrPhilosophers];
                states = new String[nrPhilosophers];
                semaphores = new Semaphore[nrPhilosophers];
                for (int i = 0; i < nrPhilosophers; i++) {
                    states[i] = Events.THINK;
                    semaphores[i] = new Semaphore(0);
                }
                mutex = new Semaphore(1);
            }

            void test(int id) {
                int left = (id + states.length - 1) % states.length;
                int right = (id + 1) % states.length;

                if (states[id] == Events.HUNGRY &&
                    states[left] != Events.EAT &&
                    states[right] != Events.EAT) {

                    states[id] = Events.EAT;
                    semaphores[id].release();
                }
            }

            void updateEatTime(int id) {
                eatTimes[id]++;
            }

            void updateState(int id, String state) {
                states[id] = state;
            }

            void checkAll() {
                int[] sortedIndices = sortByEatingTimes();
                for (int index : sortedIndices) {
                    test(index);
                }
            }

            int[] sortByEatingTimes() {
                EatTimeWithIndex[] sortArray = new EatTimeWithIndex[eatTimes.length];
                for (int i = 0; i < eatTimes.length; i++) {
                    sortArray[i] = new EatTimeWithIndex(eatTimes[i], i);
                }

                Arrays.sort(sortArray, Comparator.comparingInt(e -> e.eatTime));

                int[] sortedIndices = new int[eatTimes.length];
                for (int i = 0; i < sortArray.length; i++) {
                    sortedIndices[i] = sortArray[i].index;
                }

                return sortedIndices;
            }

            static class EatTimeWithIndex {
                int eatTime;
                int index;

                eatTimeWithIndex(int eatTime, int index) {
                    this.eatTime = eatTime;
                    this.index = index;
                }
            }
        }

    </code></pre>

    <p>

    </p>

    <pre><code>
        [Pseudocode]

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
                monitor.mutex.acquire();
                monitor.updateState(id, Events.HUNGRY);
                monitor.test(id);
                monitor.mutex.release();

                monitor.semaphores[id].acquire();

                pickUpLeftChopstick();
                pickUpRightChopstick();
            }

            void eats() {
                eat();
                monitor.mutex.acquire();
                monitor.updateEatTime(id);
                monitor.mutex.release();
            }

            void putDown() {
                putDownLeftChopstick();
                putDownRightChopstick();

                monitor.mutex.acquire();
                monitor.updateState(id, Events.THINK);
                monitor.checkAll();
                monitor.mutex.release();
            }
        }

    </code></pre>

    <p>
        Now let us evaluate the Fair Tanenbaum solution based on the key-challenges:
    </p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=FAIR_TANENBAUM" class="button">Fair Tanenbaum Simulation</a>
    <a href="../animation/?algorithm=FAIR_TANENBAUM" class="button">Fair Tanenbaum Animation</a>




</div>
</body>
</html>
