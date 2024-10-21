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


    <h2>Atomic Waiter Solution</h2>
    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Waiter Solution introduces a central entity to manage access to chopsticks and prevent deadlocks.
        In the Atomic Waiter solution, philosophers must notify the waiter whenever they want to eat.
        The waiter maintains a queue of requests and grants permission to eat based on the order in which philosophers
        were added to the queue.
        When a philosopher is first in the queue, they are given permission to pick up both chopsticks and start eating.
        Once they finished putting down the chopsticks and returned the permission, the waiter grants it to the next
        philosopher in the queue.
        In this solution we view the whole picking up chopsticks, eating and putting down chopsticks as an atomic
        process, and is thus very similar in performance to the Global-Token Solution.
        Viewing the whole eating process is of course unnecessary, we will therefor improve on this in the following
        solutions on this page.
    </p>

    <p>
        <b>Waiter class:</b>
        We introduce a waiter class that handles the received requests using a queue.
        Whenever a request is received the waiter pushes the philosopher onto the queue and then processes one
        philosopher ata time,
        permitting the next one in the queue to eat at a time.
    </p>
    <pre><code>
        [Pseudocode]

        class Waiter {

            Philosopher permittedPhilosopher;  // The philosopher currently allowed to proceed.
            Queue queuedPhilosophers;          // Queue of philosophers waiting for permission.

            Waiter(int nrPhilosophers) {
                permittedPhilosopher = null;
                queuedPhilosophers = new Queue();
            }

            // Method for philosophers to request permission to proceed.
            synchronized void requestPermission(Philosopher philosopher) {
                queuedPhilosophers.add(philosopher);

                // If no philosopher has permission, assign one from the queue.
                if (permittedPhilosopher == null) {
                    permittedPhilosopher = queuedPhilosophers.poll();
                }

                // Wait until this philosopher is the one permitted to proceed.
                while (!philosopher.equals(permittedPhilosopher)) {
                    wait();
                }
            }

            // Method to return permission, allowing the next philosopher in line to proceed.
            synchronized void returnPermission() {
                // Grant permission to the next philosopher in the queue.
                permittedPhilosopher = queuedPhilosophers.poll();

                // Notify all waiting philosophers that permission has changed.
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
                    //request permission before pickup
                    waiter.requestPermission(this);

                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();

                    //return permission after putdown
                    waiter.returnPermission();
                }
            }
        }

    </code></pre>
    <h3>Atomic Waiter Solution Evaluation</h3>

    <p>Now let us evaluate the Atomic Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: We again prevent Deadlocks via avoiding the circular-wait condition.</li>
        <li>Starvation: The introduction of a queue on the philosophers requests guarantees that each philosopher wil
            eventually get a chance to eat.
        </li>
        <li>Fairness: Fair eat-chance, as philosophers, will eventually get the chance to eat whenever they request it.
            Eat-time fairness is highly dependent on the chosen distribution and is not managed by this algorithm.
        </li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system, permitting only one
            philosopher at a time.
        </li>
        <li>Implementation: The changes required to implement this solution are simple. A new waiter class is introduced
            and philosophers have to await the waiters permission before eating.
        </li>
        <li>Performance: There is a slight performance overhead using this solution, as the waiter has to process one
            philosophers request after another and has to maintain a queue of size r (number of requests). From this we
            can conclude, that scalability (as in most waiter solutions) is poor.
        </li>
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
        This approach helps us attain concurrency again, but still prevents deadlocks by avoiding the circular wait
        condition.
        The main drawback of this solution is that the waiter will always assign the permission to the philosopher that
        requested the chopsticks first.
        Thus, an adjacent philosopher will frequently attain permission, limiting the concurrency.
    </p>

    <p>
        <b>Philosopher class:</b>
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
                    //request permission before pickup
                    waiter.requestPermission(this);

                    pickUpLeftChopstick();
                    pickUpRightChopstick();

                    //return permission after pickup
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
        <li>Deadlocks: As in the Atomic Waiter Solution, we effectively avoid deadlocks by avoiding the circular-wait
            condition.
        </li>
        <lI>Starvation: The queue lets us avoid starvation.</lI>
        <li>Fairness: Every philosopher, when requested will eventually get a chance to eat. For eat-chance fairness we
            can therefor infer that philosophers who request to eat more often will gain permission more often.
        </li>
        <li>Concurrency: We reintroduce concurrency, but permission is frequently given to philosophers, adjacent to
            currently eating neighbours.
            Depending on the order of the requests this limits the degree of concurrency during execution. This results
            in -on average- lower concurrency than the naive implementation.
        </li>
        <li>Implementation: Very simple, we only need to move one line in the Atomic Waiter Solution.
        </li>
        <li>Performance: Slight Performance overhead and poor scalability, same as in the Atomic Waiter Solution</li>
    </ul>


    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=PICKUPWAITER" class="button">Pickup Waiter Simulation</a>
    <a href="../animation/?algorithm=PICKUPWAITER" class="button">Pickup Waiter Animation</a>


    <h2>Intelligent Pickup Waiter Solution</h2>
    <p>
        To improve our Pickup waiter solution, we check if the current philosopher in the queue is next to a philosopher
        that is currently eating.
        If that is the case, we skip this philosopher and allow another philosopher in the queue (that is not adjacent
        to a currently eating philosopher and is not a currently eating philosopher) to eat.
        In the case that no such philosopher is found we just pick the first philosopher in the queue.
        This helps us to attain more concurrency in our system.

    </p>

    <p>
        <b>Waiter class: </b>
        Additional to the queue, we utilize a boolean array to keep track of the philosophers eating states.
    </p>
    <pre><code>
        [Pseudocode]

        class IntelligentWaiter {

            Philosopher permittedPhilosopher;  // The philosopher currently allowed to eat.
            Queue philosophersQueue;           // Queue of philosophers waiting for permission to eat.
            int nrPhilosophers;
            boolean[] eatStates;               // Tracks whether each philosopher is currently eating.

            IntelligentWaiter(int nrPhilosophers) {
                this.nrPhilosophers = nrPhilosophers;
                permittedPhilosopher = null;
                philosophersQueue = new Queue();
                eatStates = new Boolean[nrPhilosophers];
            }

            // Method for philosophers to request permission to eat.
            synchronized void requestPermission(Philosopher philosopher) {
                philosophersQueue.add(philosopher);  // Add the requesting philosopher to the queue.

                // If no philosopher has permission, assign one from the queue.
                if (permittedPhilosopher == null) {
                    permittedPhilosopher = philosophersQueue.poll();
                }

                // Wait until this philosopher is the one permitted to eat.
                while (philosopher != permittedPhilosopher) {
                    wait();  // Wait until it is this philosopher's turn.
                }

                setEatState(philosopher);  // Update the philosopher's state to eating.
            }

            // Method to return permission, allowing the next philosopher to eat based on neighbor states.
            synchronized void returnPermission() {
                // Iterate through the queued philosophers to find a suitable candidate.
                for Each philosopher in philosophersQueue {
                    int leftPhilosopher = (philosopher.getPhId() - 1 + nrPhilosophers) % nrPhilosophers;  // Left philosopher's index.
                    int rightPhilosopher = (philosopher.getPhId() + 1) % nrPhilosophers;                   // Right philosopher's index.

                    // Check if neighboring philosophers are not eating.
                    if (!eatStates[leftPhilosopher] && !eatStates[rightPhilosopher] && philosopher != permittedPhilosopher) {
                        permittedPhilosopher = philosopher;  // Grant permission to this philosopher.
                        philosophersQueue.remove(philosopher);
                        notifyAll();  // Notify waiting philosophers.
                        return;  // Exit after assigning permission.
                    }
                }

                // If no suitable philosopher is found, assign the next one in the queue.
                permittedPhilosopher = philosophersQueue.poll();
                notifyAll();  // Notify that a philosopher was chosen from the queue.
            }

            // Method to set the state of a philosopher as eating.
            void setEatState(Philosopher philosopher) {
                eatStates[philosopher.getPhId()] = true;
            }

            // Method to reset the state of a philosopher after they finish eating.
            synchronized void removeEatState(Philosopher philosopher) {
                eatStates[philosopher.getPhId()] = false;
            }
        }

    </code></pre>
    <p>
        <b>Philosopher class:</b>
        Here we need to additionally notify the waiter when eating is finished.
    </p>
    <pre><code>
        [Pseudocode]

        class IntelligentPickupGuestPhilosopher extends Philosopher {

            IntelligentWaiter waiter;

            IntelligentPickupGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, IntelligentWaiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();

                    //request permission before pickup and set state "eating" to true
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();

                    //return permission after pickup
                    waiter.returnPermission();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();

                    //notify waiter after putdown
                    waiter.removeEatState(this);
                }
            }
        }


    </code></pre>

    <p>Now let us evaluate the Intelligent Pickup Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: As in the previous solutions we avoid the circular-wait condition.</li>
        <li>Starvation: Theoretically, there is a very slim chance of starvation in a limited time environment as ours(If we let the simulation run indefinitely they will for sure be permitted at some point).
            In rare cases, skipping philosophers could lead to some philosophers to be repeatedly permitted, while another never gets a chance to eat.</li>
        <li>Fairness: We sometimes skip philosophers in the queue to enhance the concurrency. We always prefer philosopher that are currently able to eat,
            this lowers the fairness in our system. </li>
        <li>Concurrency: This approach lets us enhance the concurrency in our system, by avoiding handing the permission to a philosopher adjacent to a currently eating neighbour.</li>
        <li>Implementation: We introduce some additional logic to the waiter solution. We have to careful on how to manage and process the queue. This makes the approach a little more elaborate to implement correctly, compared to the previous approaches.
        </li>
        <li>
            Performance: There is now more processing of the queue and an additional array. Additionally, philosophers now have to access the waiter an additional time, when removing their "eating" state.
            This leads to poor scalability, since the waiter potentially has to go through a queue of r (number of requests) to check whether adjacent philosophers eat, each time the request is returned.
            During this time the Waiter cannot accept requests/putdowns/ removal of eat states, forcing the other philosophers to wait.
        </li>
    </ul>
    <p>

        The Solution yields good results concerning concurrency, however
        there is still one drawback to this solution, as a waiter will always assign the permission to the
        philosopher that requested the chopsticks first, or one that is currently able to eat.
        This results in the fact that when philosophers request eating more frequently they will repeatedly be allowed
        to eat.
    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Pickup Waiter Simulation</a>
    <a href="../animation/?algorithm=INTELLIGENTWAITER" class="button">Intelligent Pickup Waiter Animation</a>







    <h2>Fair Waiter Solution</h2>
    <p>
        We can enhance fairness in the Waiter Solution by tracking how many times each philosopher has had the
        chance to eat during the course of the simulation, enabling us to address eat-chance fairness.
        Alternatively we could track how much time philosophers spent
        eating previously, this allows us to address Eat-Time Fairness.
        The waiter will then prioritize the philosopher with the least accumulated eating time, or least chances to eat,
        attempting to ensure that all philosophers get a fair opportunity.
        This, of course can only react to previous eating times/ number of eat-chances.
    </p>

    <p>
        <b>Waiter class:</b>
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
        One of the main drawbacks of the waiter solution would be its scalability.
        Modern systems often maintain hundreds, if not thousands of threads that compete for resources.
        The waiters being accessed mutually exclusive (one after another) by several hundreds, if not thousands of philosophers,
        instead of being accessed by 2-9 would produce a big overhead with long waiting times.
        An idea to address this, would be to introduce more than one waiter into the system.
        Each of the waiters would then be assigned to manage a subset of the philosophers.
        There is of course going to be an overlap in the forks at the "corners" of the setup.
        We focus here on an implementation that utilizes only two waiters to manage the philosophers. (More than two
        waiters would not be efficient for managing less than 10 philosophers)
        However, this concept can easily be extended to a more waiters, if the number of philosophers increases.
    </p>

    <p>
        All we have to do is to reuse one of the previously implemented waiter solutions and assign them to a subset of
        the given philosophers.
        For this implementation we choose the Intelligent Pickup Waiters.
    </p>
    <pre><code>
        for (int i = 0; i < nrPhilosophers; i++) {
           forks.add(new Chopstick(i));
        }

        Waiter splitWaiter = new Waiter(nrPhilosophers);
        Waiter splitWaiter1 = new Waiter(nrPhilosophers);

        Waiter selectedWaiter;
        boolean assignToTwo = nrPhilosophers > 3;
        for (int i = 0; i < nrPhilosophers; i++) {
            selectedWaiter = (assignToTwo && i >= nrPhilosophers / 2) ? splitWaiter1 : splitWaiter;

            PickupGuestPhilosopher philosopher = new PickupGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, selectedWaiter);
            philosophers.add(philosopher);
        }
    </code></pre>

    <p>Now let us evaluate the Two Waiters approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks via avoiding the circular-wait condition</li>
        <li>Starvation: </li>
        <li>Fairness: </li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TWOWAITERS" class="button">Two Waiters Simulation</a>
    <a href="../animation/?algorithm=TWOWAITERS" class="button">Two Waiters Animation</a>


    <h2>Classic Waiter Solution</h2>

    <p>
        There is a classic version of the waiter solution, in which we track the number of forks on the table.
        The waiter always provides the chopsticks when requested by a philosopher,
        unless there are less than two chopsticks remaining on the table.
        In this case we let the philosopher wait until another philosopher is done eating.
        This solution
    </p>


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
        <li>Fairness: We ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic
            needed.
        </li>
        <li>Performance:</li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Classic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Classic Waiter Animation</a>
</div>


</body>
</html>
