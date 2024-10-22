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




    <div class="separator"></div>
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

    <h3>Pickup Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Pickup Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: As in the Atomic Waiter Solution, we effectively avoid deadlocks by avoiding the circular-wait
            condition.
        </li>
        <lI>Starvation: The queue lets us avoid starvation.</lI>
        <li>Fairness: As in the Atomic waiter solution every philosopher, when requested will eventually get a chance to eat. For eat-chance fairness we
            can therefor infer that philosophers who request to eat more often will gain permission more often. As for eat-time fairness, it is again dependent on the chosen distribution and not explicitly managed.
            However, due to the now enabled parallelism philosophers now get more chances to eat.
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







    <div class="separator"></div>

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

    <h3>Intelligent Pickup Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Intelligent Pickup Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: As in the previous solutions we avoid the circular-wait condition.</li>
        <li>Starvation: Theoretically, there is a very slim chance of starvation in a limited time environment as ours(If we let the simulation run indefinitely they will for sure be permitted at some point).
            In rare cases, skipping philosophers could lead to some philosophers to be repeatedly permitted, while another never gets a chance to eat.</li>
        <li>Fairness: We sometimes skip philosophers in the queue to enhance the concurrency. We always prefer philosopher that are currently able to eat,
            this lowers eat-chance and eat-timee fairness in our system. </li>
        <li>Concurrency: This approach lets us enhance the concurrency in our system, by avoiding handing the permission to a philosopher adjacent to a currently eating neighbour, when possible.</li>
        <li>Implementation: We introduce some additional logic to the waiter solution. We have to careful on how to manage and process the queue. This makes the approach a little more elaborate to implement correctly (compared to the previous approaches).
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





    <div class="separator"></div>

    <h2>Fair Waiter Solution</h2>
    <img src="../pictures/fairwaiter.svg" alt="Dining Philosophers Problem" width="520" height="455">
    <p>
        We can enhance fairness in the Waiter Solution by tracking how many times each philosopher has had the
        chance to eat during the course of the simulation, enabling us to address eat-chance fairness.
        Alternatively we could track how much time philosophers spent
        eating previously, this allows us to address Eat-Time Fairness.
        The waiter will then prioritize the philosopher with the least accumulated eating time, or least chances to eat,
        attempting to ensure that all philosophers get a fair opportunity.
        This, of course can only react to previous eating times/ number of eat-chances.
    </p>

    <h4>Eat Time Fairness implementation: </h4>
    <p>
        <b>Waiter class:</b>
        When a philosopher requests permission, they are added to a queue, and if no other philosopher is currently allowed,
        the first in the queue gains permission. Philosophers wait until it is their turn. After a philosopher finishes eating,
        they return the permission, and the waiter selects the next philosopher who has eaten the least, if present in the queue.
    </p>
    <pre><code>
        [Pseudocode]

        class FairEatTimeWaiter {

            Philosopher permittedPhilosopher;
            Queue philosophersQueue;

            fairEatTimeWaiter() {
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

                //find the philosopher with the minimum eatTimes
                for Each philosopher in philosophersQueue {
                    if (philosopher.eatTimes < minEats && philosopher != currentPhilosopher) {
                        minEats = philosopher.eatTimes; //alternatively minimum eatTime
                        permittedPhilosopher = philosopher;
                        foundOtherPhilosopher = true;
                    }
                }

                //if we do not find a philosopher we set null and pick the first in the queue
                if (!foundOtherPhilosopher) {
                    permittedPhilosopher = null;
                } else {
                    philosophersQueue.remove(permittedPhilosopher);
                }

                notifyAll(); // Notify all that permission was returned
            }
        }

    </code></pre>

    <p><b>Philosopher class:</b>
        We track the philosophers total eating time, by adding it to the previous eat-time once they finish eating.
    </p>
    <pre><code>
        [Pseudocode]

        class FairEatTimeGuestPhilosopher extends Philosopher {

            FairEatTimeWaiter waiter;
            long eatTimes;

            FairEatTimeGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, FairEatTimeWaiter waiter) {
                super(id, leftChopstick, rightChopstick);
                this.waiter = waiter;
                eatTimes = 0;
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
                    eatTimes += eatFair();

                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }

            //we return the calculated eat-time.
            long eatFair() {
                Long duration = calculateDuration();
                sleep(duration);
                sbLog("[ E ]", VirtualClock.getTime());
                return duration;
            }
        }

    </code></pre>

    <h4>Eat Chance Fairness implementation: </h4>

    <p><b>Philosopher class:</b>
        Here we simply increment a counter everytime a philosopher finishes eating.
        The waiter implementation does not change we just determine the minimum eat-chance
        , instead of the minimum eat-time to choose the next philosopher.
    </p>
    <pre><code>
        [Pseudocode]
        class FairChanceGuestPhilosopher extends Philosopher {

            int eatChances;          // counter for the number of times the philosopher has eaten.
            FairChanceWaiter waiter;

            FairChanceGuestPhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, FairChanceWaiter waiter) {
                super(id, leftChopstick, rightChopstick);
                eatChances = 0;
                this.waiter = waiter;
            }

            @Override
            void run() {
                // philosopher attempts to think, request permission, and eat in a loop.
                while (!terminated()) {
                    think();

                    // request permission before pickup.
                    waiter.requestPermission(this);
                    pickUpLeftChopstick();
                    pickUpRightChopstick();

                    // return permission after pickup.
                    waiter.returnPermission(this);
                    eat();

                    // Increment the count of eating chances.
                    eatChances++;

                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }
        }


    </code></pre>

    <h3>Fair Waiter Solution Evaluation </h3>

    <p>Now let us evaluate the Fair Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: We effectively prevent deadlocks with this solution, as in the other waiter solutions, by avoiding the circular-wait condition.</li>
        <li>
            Fairness: For the Eat chance fairness implementation we allow the philosopher to eat that has eaten the least times.
            Similarly, the Eat time approach additionally takes the distribution of the eat-times into account and can potentially compensate for large outliers.
            We act on this prioritization whenever possible (if no philosopher is in the queue we pick the first one that requests the chopsticks).
            Note that whenever we deal with a limited simulation time, one philosopher will frequently have had more opportunities to eat than the others.
            Both approaches let us effectively enhance different aspects of fairness.
        </li>
        <li>
            Concurrency: With this solution we clearly prioritize fairness over parallelism.
            We frequently assign philosophers adjacent to eating neighbours permission,
            this can in some cases (simulation runs) lead to no concurrency in the system at all.
        </li>
        <li>Implementation: We modify the waiter class to check for the requesting philosopher that has eaten the least.
            This makes things a little more elaborate to implement than the simple Pickup Waiter Solution.
        </li>
        <li>Performance: We have to both maintain a queue and process it everytime the request is returned.
            As with all the previous waiter solutions philosophers have to access the waiter one after another.
            This produces a slight overhead and limits the scalability of this approach.
            We again</li>
    </ul>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=FAIR_EATTIME_WAITER" class="button">Fair Eat Time Waiter Simulation</a>
    <a href="../animation/?algorithm=FAIR_EATTIME_WAITER" class="button">Fair Eat Time Waiter Animation</a>
    <a href="../simulation/?algorithm=FAIR_CHANCE_WAITER" class="button">Fair Eat Chance Waiter Simulation</a>
    <a href="../animation/?algorithm=FAIR_CHANCE_WAITER" class="button">Fair Eat Chance Waiter Animation</a>




    <div class="separator"></div>

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
        For this implementation we choose the Pickup Waiter.
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

    <h3>Two Waiters Solution Evaluation </h3>

    <p>Now let us evaluate the Two Waiters approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks via avoiding the circular-wait condition</li>
        <li>Starvation: Each waiter manages its own queue, so each philosopher in the subset will eventually get the chance to eat.</li>
        <li>Fairness: Very similar to the Pickup Solution,
            but one big consideration here is that philosophers at the "corners" of the subset might be able to eat less
            often, leading to "poor" philosophers.</li>
        <li>Concurrency: By reducing the overhead of exclusive waiter access, we consistently achieve high concurrency.
            Due to distributed requests we gain the advantage of assigning the permission to philosophers adjacent to eating neighbours less often.
            Therefor this solution will -on average- outperform the Pickup Waiter Solution in simulations.</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, we only need to add additional waiters in the table initialization of the Pickup Waiter Solution.
        </li>
        <li>Performance: Compared to the previous approaches we improve on scalability if we choose appropriate sizes sub-sets for the philosophers.
            Thus, the overhead becomes manageable and long waiting times due to exclusive access to the waiter are prevented.</li>
    </ul>
    <p>
        The advantage of this solution is that we can use the previously presented waiters to manage the respective subsets with a few considerations.
        The Fair Waiter Solution would be capable of ensuring fairness, but only within the managed subset.
        The Intelligent Pickup Waiter performance would be decreased, since it is not possible with the current implementation
        to check whether philosophers adjacent to the managed set are currently eating.
        To manage this, some kind of communication would be required between the waiters (Or global tracking of the states, but this would again limit scalability).
        One main drawback of these kind of solutions, however is that we need good knowledge about the system.
        We need to know the number of philosophers and the appropriate waiter assignment in advance to initialize the system.
        Dynamic environments would be harder to manage, because of considerations like:
        If a philosopher joins the table, which waiter is responsible?
        When many philosophers join or leave the table, do we reduce/increase the number of waiters and redistribute the subsets?
        The correct balance of sub-sets is necessary to improve performance, this is hard to determine during runtime.

    </p>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=TWOWAITERS" class="button">Two Waiters Simulation</a>
    <a href="../animation/?algorithm=TWOWAITERS" class="button">Two Waiters Animation</a>

</div>


</body>
</html>
