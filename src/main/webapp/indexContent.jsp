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

        .container {
            display: flex;
            justify-content: flex-end; /* Aligns the nav to the right */
        }


        .main-content {
            flex: 1; /* Takes up remaining space */
            padding-right: 20px; /* Adds some space between the main content and the nav */
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
<h2>The Dining Philosophers Problem</h2>


<div class="container">
    <div class="main-content">
        <div class="description">
            <p>
                The Dining Philosophers Problem, introduced by Edsger Dijkstra in 1965, is a thought experiment
                illustrating challenges in designing concurrent systems, such as deadlocks, fairness, and concurrency.
                It is a metaphor for distributed systems needing shared resources to complete tasks.
                Often, processes require exclusive access to shared resources for consistency.
                We will explore the problem in detail, its challenges, limitations, and solutions.
                If you know the basics, skip to the solutions using the navigation menu.
            </p>
        </div>
    </div>
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
</div>

<div class="description">

    <img src="pictures/dining.png" alt="Dining Philosophers Problem" width="400" height="350">

    <section id="general">
        <h3>The Philosophers</h3>
        <p>
            Philosophers sit around a table, with a chopstick between each pair.
            They start out thinking, then attempt to pick up the chopsticks on their left and right.
            Only one philosopher can hold a chopstick at a time, so they may need to wait.
            If two philosophers try to pick up the same chopstick simultaneously, only one will succeed.
            Once a philosopher has both chopsticks, they eat. After eating, they return the chopsticks, and the cycle
            repeats.
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
            To determine the think and eat times we could use only fixed time delays, but to ensure
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

        <img src="pictures/distribution.svg" alt="Dining Philosophers Problem" width="847" height="225">
        <p>
            To keep track of the philosophers actions we keep a Log for each Philosopher, tracking the following Events:
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
        <h3>Deadlocks</h3>
        <img src="pictures/deadlock.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Deadlocks can occur if all the philosophers pick up the chopstick to their left simultaneously and then wait
            for the chopstick to their right.
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

        <p>
            For convenience, we assume that philosophers usually pick up their left chopsticks first, thus we can track
            whether a deadlock has occurred by checking
            if the last action of all philosophers was a [PUL] = Pick Up Left.
        </p>

        <p>
            At this point it is useful to introduce the concept of "precedence graphs", which are directed graphs,
            usually utilized to visualize dependencies between different tasks.
            In the case of dining philosophers we view the philosophers themselves as nodes, whereas the arrows
            visualize the dependency
            of having to potentially wait for their right-neighbor philosopher to finish their eating task.
            This means that there is a circular dependency of the philosophers.
        </p>
        <img src="pictures/precedence.svg" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Cyclic dependencies like these indicate potential deadlocks in a system (essentially a visualization of the
            circular-wait
            condition). Avoiding this circular pattern is one of the main ways we are going to prevent deadlocks in a
            dining philosophers solution.
            Another crucial detail is the length of the precedence path, as it is at the maximum length in the naive
            approach.
            Long paths in a precedence graph mean that there are potentially long waiting chains that harm parallelism.
        </p>
        <h3>Starvation and Fairness</h3>
        <img src="pictures/starvation.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Starvation happens when one or more philosophers rarely, or never, get a chance to eat. The prime example
            for starvation are deadlocks,
            where all philosophers starve.
            When we try to design solutions we might come across an option that prevents deadlocks but is also blocking
            certain philosophers from eating, causing starvation.
            Examples for situations in which starvation could occur are, if one philosopher repeatedly grabs the
            chopstick first, stopping the neighbor from eating,
            or if one philosopher takes a very long time to eat, making neighbors wait for access to the
            chopstick.
            The goal is to make sure that every philosopher has a fair chance to eat (and not starve), we call this
            fairness.

            In the following we want to consider Starvation as philosophers not being able to eat at all.

            With our solution, we aim to prevent deadlocks while also ensuring fairness as much as possible.
        </p>
        <p>
            To measure fairness in our system we introduce two measures:
        </p>
        <ul>
            <li><b>Eat Chance Fairness:</b> We count how often each philosopher eats and calculate the standard
                deviation (variation from the average).
                Large values mean bad fairness, while values near zero indicate good fairness.
            </li>

            <li><b>Eat Time Fairness:</b> We also track the accumulated simulation time, that philosophers spent eating and
                calculate the standard deviation.
                Large values again mean bad fairness, while small values mean good fairness.
                This measure depends heavily on the chosen distribution, for example, the exponential distribution might
                return large outliers.
            </li>
        </ul>

        <h3>Concurrency</h3>
        <img src="pictures/concurrency.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            One simple way to prevent deadlocks is to allow only one philosopher to eat at a time.
            However, this would remove the ability for multiple philosophers to eat at the same time.
            In our case, concurrency means that multiple philosophers can progress simultaneously without waiting for
            each other, unless absolutely necessary. Our solution should ideally maintain concurrency while also
            preventing deadlocks and
            providing fairness.
        </p>
        <p>
            To measure concurrency in our system we introduce the concurrency measure:
        </p>
        <ul>
            <li>
                <b>Concurrency:</b> When a simulation is finished we get a timeline of length <b>l</b> (Total tracked
                Simulation Time excluding Pick-ups/ Put-downs).
                During the course of the simulation we also track the total Eating Time <b>e</b> (The total combined
                simulation time philosophers spent eating).
                We then calculate <b>e/l</b> to determine the concurrency within the system during the course of the
                simulation. With this measure, the bigger the value, the better. For the classic 5-Philosopher setup,
                values close to two are a very good result, as this means that, most of the simulation time two
                philosophers were eating in parallel.
                (Which is the maximum attainable)
            </li>
        </ul>

        <h3>Implementation</h3>
        <p>
            We should also consider how difficult the implementation of a solution is, compared to other solutions.
            Most of the solutions we will explore, are rather simple to implement, while some others will utilize more
            complex concepts.
        </p>
        <h3>Performance</h3>
        <p>
            Finally, we want to evaluate algorithms based on the overhead they produce and how scalable they are.
            Some Solutions use several data structures and synchronization mechanisms, that produce additional
            computational effort.
        </p>


    </section>
    <section id="simulation">
        <h2>Simulation</h2>

        <p>
            This website offers both a Simulation Page and an Animation Page, both powered by a Java Threads-based
            backend that is in principle very similar to the pseudocode provided later.
            The Simulation Page allows you to run a simulation and view the resulting simulation output as a string,
            with detailed notes available on that page.
            The Animation Page lets you run a simulation that is then visually animated, with further details also
            provided on that page.
            To see the Naive Dining Philosophers in action, you can try either the Simulation Page or the Animation
            Page.
            Please note that the Animation is currently limited to the classic 5-philosopher setup, while the Simulation
            Page allows you to experiment with 2 to 9 philosophers.
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
                the Dining Philosophers problem.
                The philosophers actions are logged over time, based on a virtual clock running during the simulation.
                For simplicity, most of the Java boilerplate (Necessary for Java programs but not useful for
                understanding of the discussed concepts) and some simulation logic for consistency have been omitted .
                If you are interested in the full implementation of this project, it is available
                on GitHub here. //link to GitHub
            </p>
            <p>
                <b>Pseudocode Naive Philosopher class:</b>
            </p>

            <pre style="font-size: 14px;"><code class="language-java">

        class Philosopher extends Thread {
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
                log.add(event + ":" + timeInstance) //This log is parsed in the backend to then
                                                    // display the timeline/ statistics of the simulation
            }

        }
    </code></pre>
            <p>
                <b>Pseudocode Naive Chopstick class:</b>
                The synchronized keyword ensures exclusive access to the pickUp() and putDown() methods.
                Philosophers have to enter a waiting state using the wait() method if the chopstick is currently
                taken, when another philosopher puts down chopstick the waiting philosopher is notified using the
                notify()
                method.
            </p>

            <pre style="font-size: 14px;"><code class="language-java">

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
                <b>Pseudocode for Dining Table class</b>
                The backbone of the simulation is a virtual clock running during the execution.
                The Philosophers log their Actions according to the current time of the clock.
            </p>
            <pre style="font-size: 14px;"><code class="language-java">

    public class Table {
    // lists to store chopsticks and philosophers
    List chopsticks;
    List philosophers;

    // constructor to initialize the table with the given number of philosophers
    Table(int numPhilosophers) {
        chopsticks = new List(numPhilosophers);
        philosophers = new List(numPhilosophers);

        // Initialize chopsticks
        for (int i = 0; i < numPhilosophers; i++) {
            chopsticks.add(new Chopstick());
        }

        // Initialize philosophers, each with a left and right chopstick
        for (int i = 0; i < numPhilosophers; i++) {
            Chopstick leftChopstick = chopsticks.get(i);
            Chopstick rightChopstick = chopsticks.get((i + 1) % numPhilosophers);
            philosophers.add(new Philosopher(leftChopstick, rightChopstick));
        }
    }

    // method to start the dinner: start a thread for each philosopher
    void startDinner() {
        for (Philosopher philosopher : philosophers) {
            new Thread(philosopher).start();
        }
    }

    // terminate all philosophers
    void stopDinner() {
        for (Philosopher philosopher : philosophers) {
            philosopher.terminate();
        }
    }

    // method to run the entire simulation
    void execute() {
        int simulationTime = 100; // total time for the simulation
        int numPhilosophers = 5; // number of philosophers at the table
        Table diningTable = new Table(numPhilosophers);

        // start all the philosopher threads
        diningTable.startDinner();

        // run the simulation using a virtual clock
        while (simulationTime > 0) {
            VirtualClock.advanceTime(); //advance clock time
            timeStep(); // pause for the duration of a timestep
            simulationTime--; // decrement the remaining simulation time
        }

        // stop all the philosopher threads after the simulation time ends
        diningTable.stopDinner();
    }
}
    </code></pre>
        </div>
        <h3>Naive Dining Philosophers Evaluation</h3>
        <p>
            Let us now evaluate the Naive Dining Philosophers, based on the introduced challenges.
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
                <td>The naive implementation frequently leads to deadlocks, especially when the number of philosophers
                    is 5 or lower. Usually, it is harder to come across deadlocks when dealing with larger numbers of
                    philosophers. However, due to factors like changes in the execution environment (Java VM or OS
                    rescheduling tasks), deadlocks could still occur, especially with longer runtimes.
                </td>
            </tr>
            <tr>
                <td><b>Starvation</b></td>
                <td>Letting the philosophers wait for a notification to acquire the chopstick lowers the risk of
                    starvation but does not prevent it. Rescheduling or suspension of threads (by Operating System or
                    Java VM) could allow philosophers to acquire chopsticks repeatedly before their neighbor.
                    Why this is the case, and the way we can solve it follows below.
                </td>
            </tr>
            <tr>
                <td><b>Fairness</b></td>
                <td>There is no guaranteed fairness in our naive dining philosophers implementation.</td>
            </tr>
            <tr>
                <td><b>Concurrency</b></td>
                <td>The naive dining philosophers solution has a limited potential of concurrency (as long as deadlocks
                    do not occur). This is due to the long path in the precedence graph, leading to long waiting chains.
                </td>
            </tr>
            <tr>
                <td><b>Implementation</b></td>
                <td>Implementation of the naive dining philosophers is relatively simple with knowledge of concurrent
                    programming.
                </td>
            </tr>
            <tr>
                <td><b>Performance</b></td>
                <td>We will base the performance of solutions on this implementation.</td>
            </tr>
            </tbody>
        </table>

        <h3>Improving the naive implementation</h3>
        <p>
            In the context of Java, it is important to highlight, that most
            synchronization methods do not provide fairness by default.
            Many synchronization mechanisms, like the "synchronized" keyword (used to attain an object lock when the
            function or object is called),
            do not maintain a queue of waiting threads. This means that the thread that has waited the longest
            is not guaranteed to be allowed first.
            This concept is called Barging and has to be prevented to ensure fairness in our solutions.
            Luckily, many of the synchronization methods in Java (for example Semaphores) allow so-called fairness
            parameters, that will enable a FIFO (First In First Out) queue on the waiting threads.
        </p>
        <p>
            For exactly this reason, we utilize fair semaphores, to improve our naive implementation.
            This will prevent barging and thus the re-acquiring of chopsticks. (contrary to the previous chopstick
            class)
            Note that we introduce an overhead, due to the managed FIFO queue.
        </p>
        <pre style="font-size: 14px;"><code class="language-java">
            class Chopstick {

                Semaphore chopstickSemaphore;  // semaphore controlling access to the chopstick.

                SimpleChopstick(int id) {
                    super(id);
                    chopstickSemaphore = new Semaphore(1, true);  // semaphore with one permit and enabled fairness parameter
                }

                boolean pickUp(Philosopher philosopher) {
                    chopstickSemaphore.acquire();  // acquire the semaphore, wait in FIFO queue if not available.
                    return true;
                }

                void putDown(Philosopher philosopher) {
                    chopstickSemaphore.release();  // release the semaphore, the longest waiting thread will acquire it.
                }
            }

        </code></pre>
        <p>
            Let us re-evaluate the Naive implementation based on this improvement:
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
                <td><b>Starvation</b></td>
                <td>
                </td>
            </tr>
            <tr>
                <td><b>Fairness</b></td>
                <td></td>
            </tr>

            </tbody>
        </table>

    </section>
    <section id="limitations">
        <h2>Limitations</h2>
        <p>
            Before exploring solutions, let us first discuss the main limitations of the problem.
            One key limitation is that the maximum concurrency is restricted by the rules.
            Under ideal conditions, the maximum number of philosophers who can eat simultaneously is limited to
            <b>[n/2]</b> for even numbers of philosophers <b>(n)</b> and <b>⌊n/2⌋</b> for odd n.
            For example, with 5 philosophers, <b>⌊5/2⌋</b> equals <b>2</b>, meaning that at most two philosophers can
            eat at the same time.
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
        </p>

        <h4>Correct Solutions:</h4>
        <p>
            Finding a correct solution to the dining philosophers proved to be no simple task.
            Many approaches have been proven to be technically incorrect in a later re-evaluation.
            <br>
            Correct solutions must be:
        <ul>
            <li><b>Deadlock-free</b></li>
            <li><b>Starvation-free</b></li>
            <li><b>Concurrent</b></li>
            <li><b>Correctly Implemented</b> (correct usage of synchronization mechanisms)</li>
        </ul>
        <br>


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
                To learn about Distributed Solutions:
            </p>
            <a href="distributed" class="button">Distributed Solutions</a>
        </div>

        <div class="description-box">
            <p>
                To learn about some advanced solutions based on more recent literature:
            </p>
            <a href="advanced" class="button">Advanced Solutions</a>
        </div>


    </section>
</div>


</body>
</html>

