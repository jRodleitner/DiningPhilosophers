<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Waiter Solution</title>
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
<div class="description">

    <h2>Classic Waiter Solution</h2>
    <img src="../pictures/waiter.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Waiter Solution introduces a central entity to manage chopstick access and prevent deadlocks.
        There is a classic version of the waiter solution, in which

    </p>

    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">

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
        <li>Fairness: We  ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>





    <h2>Atomic Waiter Solution</h2>
    <img src="../pictures/waiter.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        With this approach, philosophers must notify the waiter whenever they want to eat.
        The waiter maintains a queue of requests and grants permission to eat based on the order in which philosophers
        were added the queue.
        When a philosopher is first in the queue, they are given permission to pick up both chopsticks and start eating.
        Once they finish, the waiter grants permission to the next philosopher in line, ensuring that only one
        philosopher eats at a time.
        By controlling access through the waiter, we eliminate the circular wait condition defined by Coffman.
        However, this approach also removes concurrency, meaning only one philosopher can eat at any given moment.
    </p>

    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <p>

    </p>
    <pre><code>
        [Pseudocode]

        public class Waiter {

            Philosopher permittedPhilosopher;
            Queue queuedPhilosophers;

            Waiter(int nrPhilosophers) {
                permittedPhilosopher = null;
                queuedPhilosophers = new Queue();
            }

            synchronized void requestPermission(Philosopher philosopher) {
                queuedPhilosophers.add(philosopher);
                if (permittedPhilosopher == null) permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
                while (!philosopher.equals(permittedPhilosopher)) {
                    wait();
                }
            }

            synchronized void returnPermission(){
                permittedPhilosopher = queuedPhilosophers.poll();
                notifyAll();
            }
        }
    </code></pre>
    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class AtomicGuestPhilosopher extends Philosopher {

            Waiter waiter;
            AtomicGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
            }

            @Override
            public void run() {

                while (!terminated()) {
                    think();
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                    waiter.returnPermission();
                }
            }
        }

    </code></pre>
    <p>Now let us evaluate the Atomic Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We introduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>









    <h2>Pickup Waiter Solution</h2>
    <p>
        We can reintroduce some concurrency into the system by limiting the waiter's permission to just the chopstick
        pickup phase. This way, multiple philosophers can receive permission from the waiter and eat at the same time.
        This approach helps attain concurrency again, but still prevents deadlocks by avoiding the circular wait
        condition.
        The main drawback of this solution is that the waiter will always assign the permission to the philosopher that
        requested the chopsticks first.
        Thus, we do not provide any fairness to the system and an adjacent philosopher will frequently attain
        permission, limiting the concurrency.
    </p>

    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class PickupGuestPhilosopher extends Philosopher {

            Waiter waiter;
            AtomicGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
            }

            @Override
            public void run() {

                while (!terminated()) {
                    think();
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    waiter.returnPermission();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }
        }
    </code></pre>

    <p>Now let us evaluate the Pickup Waiter approach based on the key-challenges:</p>
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
    <a href="../simulation/?algorithm=PICKUPWAITER" class="button">Pickup Waiter Simulation</a>
    <a href="../animation/?algorithm=PICKUPWAITER" class="button">Pickup Waiter Animation</a>








    <h2>Intelligent Pickup Waiter Solution</h2>
    <p>
        To improve our Pickup waiter solution, we check if the current philosopher in the queue is next to a philosopher
        who is currently eating.
        If that is the case, we skip this philosopher and allow another philosopher in the queue (that is not adjacent
        to a currently eating philosopher) to eat.
        In the case that no such philosopher is found we just pick the first philosopher in the queue.
        This should theoretically help us to attain more concurrency in our system.
        However, there is still one drawback to this solution, as a waiter will always assign the permission to the
        philosopher that requested the chopsticks first, or one that is currently able to eat.
        Thus, we still do not provide fairness to the system in this way, we just handle requests one after another.
    </p>

    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class IntelligentWaiter {

            Philosopher permittedPhilosopher;
            Queue philosophersQueue;
            int nrPhilosophers;
            boolean[] eatStates;

            IntelligentWaiter(int nrPhilosophers) {
                this.nrPhilosophers = nrPhilosophers;
                permittedPhilosopher = null;
                philosophersQueue = new Queue();
                eatStates = new Boolean[nrPhilosophers];
            }

            synchronized requestPermission(Philosopher philosopher) {
                philosophersQueue.add(philosopher);
                if (permittedPhilosopher == null) {
                    permittedPhilosopher = philosophersQueue.poll(); // No philosopher is currently permitted, one needs to be assigned
                }

                while (philosopher != permittedPhilosopher) {
                    wait();  // Wait until this philosopher is permitted
                }
                setEatState(philosopher);  // Philosopher is now eating
            }

            synchronized void returnPermission() {
                // Iterate through the queued philosophers
                For Each philosopher in philosophersQueue {
                    LeftPhilosopher = (philosopher.getPhId() - 1 + nrPhilosophers) % nrPhilosophers;  // Left philosopher's index
                    RightPhilosopher = (philosopher.getPhId() + 1) % nrPhilosophers;                   // Right philosopher's index

                    if (!eatStates[LeftPhilosopher] && !eatStates[RightPhilosopher] && philosopher != permittedPhilosopher) {
                        permittedPhilosopher = philosopher;
                        philosophersQueue.remove(philosopher);
                        NotifyAll();  // Philosopher is permitted
                        return;  // Exit after finding the next philosopher
                    }
                }

                // No suitable philosopher found, assign next in queue
                permittedPhilosopher = philosophersQueue.poll();
                NotifyAll();  // Notify that a philosopher was chosen from the queue
            }

            void setEatState(Philosopher philosopher) {
                eatStates[philosopher.getPhId()] = true;
            }

            void synchronized removeEatState(Philosopher philosopher) {
                eatStates[philosopher.getPhId()] = false;
            }

        }

    </code></pre>
    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class IntelligentPickupGuestPhilosopher extends Philosopher {

            Waiter waiter;

            IntelligentPickupGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    waiter.returnPermission();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                    waiter.removeEatState(this);
                }
            }
        }


    </code></pre>

    <p>Now let us evaluate the Intelligent Pickup Waiter approach based on the key-challenges:</p>
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
    <a href="../simulation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Pickup Waiter Simulation</a>
    <a href="../animation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Pickup Waiter Animation</a>









    <h2>Fair Waiter Solution</h2>
    <p>
        We can enhance fairness in the Waiter Solution by tracking how much time each philosopher has had the
        chance to eat during the course of the simulation.
        The waiter will then prioritize the philosopher with the least accumulated eating time,
        attempting to ensure that all philosophers get a fair opportunity to eat.
        This, of course can only react to previous eating times.
    </p>

    <p>
        To implement these changes we modify our Waiter:
    </p>
    <pre><code>
        [Pseudocode]

        class FairWaiter {

            Philosopher permittedPhilosopher;
            Queue philosophersQueue;

            fairWaiter() {
                permittedPhilosopher = null;
                philosophersQueue = new Queue();
            }

            synchronized void requestPermission(Philosopher philosopher) {
                philosophersQueue.add(philosopher);

                if (permittedPhilosopher == null) {
                    permittedPhilosopher = philosophersQueue.poll(); // Assign the first philosopher if none is permitted
                }

                while philosopher != permittedPhilosopher {
                    wait(); // Wait until it's this philosopher's turn
                }
            }

            synchronized void returnPermission(Philosopher philosopher) {
                boolean foundOtherPhilosopher = false;
                Long minEats = MAX_VALUE;

                for Each philosopher in philosophersQueue {
                    if (philosopher.eatTimes < minEats && philosopher != currentPhilosopher) {
                        minEats = philosopher.eatTimes;
                        permittedPhilosopher = philosopher;
                        foundOtherPhilosopher = true;
                    }
                }

                if (!foundOtherPhilosopher) {
                    permittedPhilosopher = null;
                } else {
                    philosophersQueue.remove(permittedPhilosopher);
                }

                notifyAll(); // Notify that a philosopher was chosen
            }
        }

    </code></pre>

    <p>

    </p>
    <pre><code>
        [Pseudocode]

        class FairGuestPhilosopher extends Philosopher {

            Waiter waiter;
            long eatTimes;

            fairGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, Waiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
                eatTimes = 0;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    waiter.returnPermission(this);
                    eatTimes += eatFair();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }

            long eatFair() {
                Long duration = calculateDuration();
                sleep(duration);
                sbLog("[ E ]", VirtualClock.getTime());  // Log the eating event
                return duration;
            }
        }

    </code></pre>

    <p>Now let us evaluate the Fair Waiter approach based on the key-challenges:</p>
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
    <a href="../simulation/?algorithm=FAIRWAITER" class="button">Fair Waiter Simulation</a>
    <a href="../animation/?algorithm=FAIRWAITER" class="button">Fair Waiter Animation</a>










    <h2>Two Waiters Solution</h2>
    <img src="../pictures/multiplewaiters.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Another idea would be to introduce more than one waiter into the system.
        Each of the waiters will then be assigned to manage a subset of the philosophers.
        This approach is inherently limited, as

    </p>

    <pre><code>
        codeee
        codeee
    </code></pre>

    <pre><code>
        codeee
        codeee
    </code></pre>


    <p>Now let us evaluate the Two Waiters approach based on the key-challenges:</p>
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
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>
</div>


</body>
</html>
