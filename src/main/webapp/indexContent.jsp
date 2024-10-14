<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Dining Philosophers Page</title>
    <style>

        .button {
            display: inline-block; /* Allows padding to be applied properly */
            color: white; /* White font color */
            background-color: #216477; /* Teal background color */
            text-decoration: none; /* Removes the underline from links */
            padding: 10px 20px; /* Adds padding to make the link look like a button */
            border-radius: 10px; /* Rounds the corners of the button */
            font-weight: bold; /* Makes the text bold */
            font-size: 14px; /* Sets the font size for the button text */
            transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition on hover */
            margin: 5px 0; /* Adds space between buttons */
        }

        html {
            scroll-behavior: smooth;
        }

        .nav {
            max-width: 300px;
            max-height: 300px;
            border-radius: 10px;
            background-color: #f5f5f5; /* Light grey background */
            padding: 10px;
            border: 1px solid #ccc;
        }

        /* Hover Effect */
        .button:hover {
            background-color: #438699; /* Darker teal on hover */
            color: #e0e0e0; /* Optional: Change text color slightly on hover */
        }

        .description {
            line-height: 1.6; /* Increases spacing between lines for readability */
            color: #333;
            padding: 3px;
            margin-bottom: 3px;
            max-width: 900px;
        }

        .description-box {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* General styling for the code block container */
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
<h2>The Dining Philosophers Problem</h2>
<!-- General Description -->
<div class="nav">
    <h4>Page Contents</h4>
    <ul>
        <li><a href="#general">General Explanation</a></li>
        <li><a href="#challenges">Challenges</a></li>
        <li><a href="#simulation">Simulation</a></li>
        <li><a href="#implementation">Implementation</a></li>
        <li><a href="#limitations">Limitations</a></li>
        <li><a href="#solutions">Solutions</a></li>
    </ul>
</div>
<div class="description">
    <p>
        The Dining Philosophers Problem is a classic thought experiment that is useful to illustrate some of the
        challenges
        of designing concurrent systems.
        These include deadlocks, fairness and ensuring actual concurrency within the system.
        Essentially the problem can be seen as a simplified metaphor for distributed systems that share needed resources
        between the processes to achieve a goal. In reality processes often need those shared resources to complete
        their tasks,
        for example accessing a variable that is read and updated by two or more processes. To ensure consistency
        usually only one process at a time is permitted to access the resource.
        The Dining Philosophers problem was famously introduced by Edsger Dijkstra in 1965 and is frequently referenced
        in the literature concerning the fields of concurrent programming, operating systems, and synchronization
        mechanisms.
        In the following we will explore the Dining Philosophers problem in detail, highlighting the key challenges and
        possible solutions to them.
    </p>
    <img src="pictures/dining.png" alt="Dining Philosophers Problem" width="400" height="350">

    <section id="general">
        <h3>The Philosophers</h3>
        <p>
            A group of philosophers is seated around a table, with a chopstick placed between each pair of adjacent
            philosophers.
            Each philosopher begins by thinking and then tries to pick up the chopsticks on their left and right.
            Since only one philosopher can hold a chopstick at a time, they may need to wait for it to become available.
            If two philosophers attempt to pick up the same chopstick simultaneously, only one will succeed.
            Once a philosopher has both chopsticks, they can start eating.
            After eating, they return the chopsticks to the table, and the cycle repeats.
        </p>
        <p>The naive process of a Philosopher consists of:</p>
        <ul>
            <li>Think for some time</li>
            <li>Pick up left Chopstick (or wait until available)</li>
            <li>Pick up right Chopstick (or wait until available)</li>
            <li>Eat for some time</li>
            <li>Put down left chopstick and notify availability</li>
            <li>Put down right chopstick and notify availability</li>
        </ul>
        <p>This cycle runs for all philosophers simultaneously.
            In our case we want to run the process until a timeout is reached, at which point all philosophers are
            terminated.
        </p>
        <img src="pictures/eatsleep.png" alt="Dining Philosophers Problem" width="400" height="60">
        <br>
        <p>
            To determine the think and eat times we could use fixed time delays, but to ensure
            closeness to real life scenarios we should also consider random number generated wait times.
            The four time distributions we will consider are:
        </p>
        <ul>
            <li>Deterministic: The execution time for eating or thinking is the same for all philosophers.</li>
            <li>Interval: The execution time is randomly selected within a specific range, for example, between 50 and
                100 milliseconds.
            </li>
            <li>Normal: The execution time varies symmetrically around a central value, with deviations following a
                normal distribution.
            </li>
            <li>Exponential: The execution time is usually small, but occasionally, much larger values can occur,
                following an exponential distribution.
            </li>
        </ul>
        <p>
            To keep track of the philosophers actions we keep a Log for each Philosopher, with the following Events
            being
            logged:
        </p>
        <ul>
            <li>[ T ] = Think</li>
            <li>[PUL] = Pick Up Left</li>
            <li>[PUR] = Pick Up Right</li>
            <li>[ E ] = Eat</li>
            <li>[PDL] = Put Down Left</li>
            <li>[PDR] = Put Down Right</li>
            <li>[ B ] = Blocked (Whenever waiting for a Chopstick occurs)</li>
        </ul>

        <p>
            Whenever philosophers complete an action they will add it to their log.
            The combination of each of the philosophers logs will result in a timeline, in which we are able to track
            the actions of the philosophers over the course of the simulation.
            To keep the timeline consistent we use a virtual clock, which is used by the philosophers to log their
            actions according to simulation time.
            This enables us to combine the timelines and to track the times that philosophers spend eating and thinking
            to evaluate the performance of the solutions discussed later.
        </p>
        <p>
            Here is an example for a timeline that we get as a result of a simulation:
        </p>

        <pre><code>
        PH_0 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][PUL][PUR][ E ][   ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][PUL][   ][   ][   ][PUR][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][ E ][ E ][PDL][PDR][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][   ][   ][ T ][ T ][PUL][ B ][ B ][ B ][   ][   ][PUR][   ]
        PH_1 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][ B ][ B ][ B ][ B ][ B ][   ][   ][PUL][   ][   ][PUR][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][PDL][PDR][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][ T ][ T ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][ E ][   ][   ][   ][ E ][ E ][   ][ E ][ E ][ E ][PDL][PDR][   ][   ]
        PH_2 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][PUR][   ][   ][ E ][   ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][PDL][   ][PDR][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][   ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][PUR][ E ][ E ][   ][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][ T ][   ][   ][   ][ T ][ T ][   ][ T ][ T ][ T ][   ][   ][   ][PUL]
        PH_3 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][ T ][ T ][ B ][ B ][ B ][   ][   ][   ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][ T ][ T ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][PUL][   ][ B ][   ][   ][PUR][ E ][ E ][   ][ E ][ E ][ E ][   ][   ][   ][   ]
        PH_4 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][PUL][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][ T ][ T ][   ][   ][PUL][PUR][   ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][ E ][PDL][PDR][   ][ T ][ T ][   ][ T ][ T ][ T ][   ][   ][   ][   ]
        TIME:  1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59   60   61   62   63   64   65   66   67   68   69   70   71   72   73   74   75   76   77   78   79   80   81   82   83   84
    </code></pre>

        <p>
            Note that whenever a philosopher attempts to pick up or put down a chopstick we assume a synchronization
            point to determine the correct order of the actions after the simulation.
            In those cases the other philosophers timelines will display empty brackets to signify that they took no
            action at that time.
        </p>
    </section>

    <section id="challenges">
        <h2>Challenges</h2>
        <p>
            There are three main challenges we encounter when executing the philosophers in the naive manner described
            above.
            The effectiveness of our solution in addressing one or more of these challenges will help us evaluate the
            quality of the different approaches later on.
        </p>
        <h4>Deadlocks</h4>
        <img src="pictures/deadlock.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Deadlocks can occur if all the philosophers pick up the chopstick to their left simultaneously and then wait
            for
            the chopstick to their right.
            In this situation, none of the philosophers can proceed, leading to indefinite waiting.
            This occurs because the system satisfies the Coffman conditions for a deadlock:
            mutual exclusion (each chopstick can only be held by one philosopher),
            hold and wait (philosophers hold one chopstick while waiting for another),
            no preemption (chopsticks are not taken away from philosophers, when a stalemate happens),
            and circular wait (each philosopher is waiting for a chopstick held by the philosopher next to them).
            Preventing deadlocks by addressing these conditions is the primary goal of the solutions we aim to explore.
        </p>
        <p>Here is an example for a Simulation that resulted in a deadlock: </p>
        <pre><code>
        PH_0 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][PUL]
        PH_1 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][   ][PUL][   ][   ][   ]
        PH_2 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][   ][   ][PUL][   ][   ]
        PH_3 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][PUL][   ][   ][   ][   ]
        PH_4 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][   ][   ][   ][PUL][   ]
        TIME:  1    2    3    4    5    6    7    8    9   10   11   12   13   14
    </code></pre>
        <h4>Starvation</h4>
        <img src="pictures/starvation.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Starvation happens when one or more philosophers rarely, or never, get a chance to eat. The prime example for starvation are deadlocks,
            where all philosophers starve.
            When we try to design solutions we might come across an option that prevents deadlocks but is also blocking certain philosophers from eating, causing starvation.
            Examples for situations of starvation could occur are, for example if one philosopher repeatedly grabs the chopsticks first, stopping others from eating,
            or if one philosopher takes a very long time to eat, making it harder for their neighbors to access the chopsticks.
            The goal is to make sure every philosopher has a fair chance to eat, we call this fairness.
            With our solution, we aim to prevent deadlocks while also ensuring fairness as much as possible.
        </p>
        <h4>Concurrency</h4>
        <img src="pictures/concurrency.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            One simple way to prevent deadlocks is to allow only one philosopher to eat at a time.
            However, this would remove the ability for multiple philosophers to eat at the same time.
            Concurrency means that multiple philosophers can progress simultaneously without waiting for each other
            unless
            necessary.
            Our solution should ideally maintain concurrency while also preventing deadlocks and ensuring fairness, such
            that all philosophers get an equal chance to eat.
        </p>
    </section>
    <section id="simulation">
        <h2>Simulation</h2>

        <p>
            This website offers both a Simulation Page and an Animation Page, both powered by a Java Threads-based
            backend.
            The Simulation Page allows you to run a simulation and view the resulting simulation output as a string,
            with
            detailed notes available on that page.
            The Animation Page lets you run a simulation that is then visually animated, with further details also
            provided
            on that page.
            To see the Naive Dining Philosophers in action, you can try either the Simulation Page or the Animation
            Page.
            Please note that the Animation is currently limited to the classic 5-philosopher setup, while the Simulation
            Page allows you to experiment with 2 to 9 philosophers
        </p>
        <a href="../simulation/?algorithm=NAIVE" class="button">Naive Simulation</a>
        <a href="../animation/?algorithm=NAIVE" class="button">Naive Animation</a>
        <br>
        <br>
    </section>
    <section id="implementation">
        <div class="description">
            <h2>Naive Dining Philosophers Implementation</h2>
            <p>
                The following Java-inspired pseudocode demonstrates the basic principles of a naive implementation of
                the
                Dining Philosophers problem.
                In Java, synchronized methods can only be accessed by one thread (in this case, a philosopher) at a
                time,
                ensuring exclusive access to the chopsticks.
                The philosophers' actions are logged over time, based on a virtual clock running during the simulation.
                The notify() function notifies the other philosopher that is kept in the waiting() state when the
                chopstick
                that is put down.
                For simplicity, most of the Java boilerplate and some simulation logic for consistency have been omitted
                from this pseudocode. If you're interested in the full implementation of this project, it is available
                on
                GitHub here. //link to GitHub
            </p>
            <p>
                Pseudocode for the Naive Philosopher class:
            </p>

            <pre><code>
        class Philosopher extends Thread{
            int id;
            Chopstick leftChopstick;
            Chopstick rightChopstick;
            List log;

            NaivePhilosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick) {
                this.id = id;
                this.leftChopstick = leftChopstick;
                this.rightChopstick = rightChopstick;
            }

            @Override
            void run() {
                while (!terminated()) {
                    think();
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                }
            }

            void think() {
                long duration = calculateDuration();
                sleep(duration);
                Log("[ T ]", VirtualClock.getTime());
            }

            void pickUpLeftChopstick() {
                leftChopstick.pickUp(this);
                Log("[PUL]", VirtualClock.getTime());
            }

            void pickUpRightChopstick() {
                rightChopstick.pickUp(this);
                Log("[PUR]", VirtualClock.getTime());
            }

            void eat() {
                long duration = calculateDuration();
                sleep(duration);
                Log("[ E ]", VirtualClock.getTime());
            }

            void putDownLeftChopstick() {
                leftChopstick.putDown(this);
                Log("[PDL]", VirtualClock.getTime());
            }

            void putDownRightChopstick() {
                rightChopstick.putDown(this);
                Log("[PDR]", VirtualClock.getTime());
            }

            void Log(String event, long timeInstance){
                log.add(event + ":" + timeInstance)
            }

        }
    </code></pre>
            <p>Pseudocode for the Chopstick class:</p>

            <pre><code>
    class Chopstick {
        boolean isAvailable = true;

        synchronized boolean pickUp(Philosopher philosopher) {
            while (!isAvailable) {
                wait();
            }
            isAvailable = false;
            return true;
        }

        synchronized void putDown(Philosopher philosopher) {
            isAvailable = true;
            notify();
        }
    }
    </code></pre>
            <p>
                The backbone of the simulation is a virtual clock running during the execution.
                The Philosophers log their Actions according to the current time of the clock.
            </p>
            <p>
                Pseudocode for Dining Table class and exemplary execute() function:
            </p>
    <pre><code>
    public class Table {
        Chopstick[] chopsticks;
        Philosopher[] philosophers;

        Table(int numPhilosophers) {
            chopsticks = new Chopstick[numPhilosophers];
            philosophers = new Philosopher[numPhilosophers];

            // Initialize chopsticks
            for (int i = 0; i < numPhilosophers; i++) {
                chopsticks[i] = new Chopstick();
            }

            // Initialize philosophers
            for (int i = 0; i < numPhilosophers; i++) {
                Chopstick leftChopstick = chopsticks[i];
                Chopstick rightChopstick = chopsticks[(i + 1) % numPhilosophers];
                philosophers[i] = new Philosopher(leftChopstick, rightChopstick);
                }
            }

            void startDinner() {
                for (Philosopher philosopher : philosophers) {
                    new Thread(philosopher).start();
                }
            }

            void stopDinner() {
            for (Philosopher philosopher : philosophers) {
                philosopher.terminate();
            }
        }

        void execute() {
            int simulationTime = 100
            int numPhilosophers = 5;
            Table diningTable = new Table(numPhilosophers);


            diningTable.startDinner(); //start all the philosopher threads

            //Virtual Clock usage
            while(simulationTime > 0){
                VirtualClock.advanceTime(); //advance clock time
                timeStep() //sleep for the duration of  a timestep
                simulationTime--;
            }

            diningTable.stopDinner();
        }
    }
    </code></pre>
        </div>
    </section>
    <section id="limitations">
        <h2>Limitations</h2>
        <p>
            Before exploring solutions, let's first discuss the main limitations of the problem.
            One key limitation is that the maximum concurrency is restricted by the rules.
            Under ideal conditions, the maximum number of philosophers who can eat simultaneously is limited to [n/2]
            for
            even numbers of philosophers (n) and ⌊n/2⌋ for odd n.
            For example, with 5 philosophers, ⌊5/2⌋ equals 2, meaning that at most two philosophers can eat at the same
            time.
            In real-world systems, access to shared resources often involves more complex dependencies, where multiple
            processes may share more than two resources, which cannot be replicated using the dining philosophers
            problem
            without significantly changing its rules.
            Another limitation is the assumption of preemption, where eating or thinking can be interrupted.
            In real-world systems, tasks are often non-preemptive, meaning they must run to completion without being
            suspended or terminated.
            Other constraints, such as the assumed homogeneity of resources (in reality, resources may have different
            constraints), time constraints (some processes must 'eat' within a specific timeframe), or unexpected
            unavailability (processes may crash or terminate), are also typically not accounted for.
            As a result, many solutions we will explore may not directly apply to such real-world systems.
            Lastly, we will ignore the traditional constraint that philosophers are 'silent' and unable to communicate,
            as
            this restriction may not be relevant to our solutions.
        </p>
    </section>
    <section id="solutions">
        <h2>Solutions</h2>
        <p>The buttons below link to different solutions that aim to address one or more of the challenges discussed
            earlier.</p>

        <div class="description-box">
            <p>To learn about solutions that focus on organizing the order of the pickups of chopsticks:</p>
            <a href="hierarchy_asymmetric" class="button">Asymmetric/ Resource Hierarchy Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about the timeout solution that prevents deadlocks via returning the initially acquired
                chopstick
                when the second chopstick is not available within a fixed timeframe:
            </p>
            <a href="timeout" class="button">Timeout Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about the solution that limits the number of philosopher being able to pick up chopsticks:
            </p>
            <a href="restrict" class="button">Restrict Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about solutions that focus on tokens being passed around by the philosophers:
            </p>
            <a href="token" class="button">Token Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about solutions that utilize a central entity to organize the permission to eat or pick up
                chopsticks:
            </p>
            <a href="waiter" class="button">Waiter Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about solutions that utilize semaphores:
            </p>
            <a href="semaphore" class="button">Semaphore Solution</a>
        </div>

        <div class="description-box">
            <p>
                To learn about the Chandy Misra solution:
            </p>
            <a href="chandymisra" class="button">Chandy-Misra Solution</a>
        </div>


    </section>
</div>


</body>
</html>

