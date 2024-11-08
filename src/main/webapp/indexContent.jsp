<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Dining Philosophers Page</title>
    <style>

        .button {
            display: inline-block;
            color: white;
            background-color: #216477;
            text-decoration: none;
            padding: 10px 20px;
            border: 4px solid #ccc;
            border-radius: 10px;
            font-weight: bold;
            font-size: 14px;
            transition: background-color 0.3s ease, color 0.3s ease;
            margin: 5px 0;
        }

        html {
            scroll-behavior: smooth;
        }

        .nav {
            max-width: 300px;
            max-height: 300px;
            border-radius: 10px;
            background-color: #f5f5f5;
            padding: 10px;
            border: 1px solid #ccc;
        }

        /* Hover Effect */
        .button:hover {
            background-color: #438699;
            color: #e0e0e0;
        }

        .description {
            line-height: 1.6;
            color: #333;
            padding: 3px;
            margin-bottom: 3px;
            max-width: 800px;
        }

        .description-box {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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

        .container {
            display: flex;
            justify-content: flex-end;
        }


        .main-content {
            flex: 1;
            padding-right: 20px;
        }

        .styled-table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
            margin: 20px 0;
            font-size: 16px;
            border: 2px;
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

        .post-it {
            background-color: #fffacd;
            border: 1px solid #ffd700;
            max-height: 400px;
            padding: 15px;
            width: 250px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);
            border-radius: 5px;
            margin: 10px;
        }

        .post-it h4 {
            margin-top: 0;
            color: #d2691e;
        }

        .post-it ul {
            padding-left: 20px;
        }

        .post-it ul li {
            margin-bottom: 5px;
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
                The Dining Philosophers Problem, first introduced by Edsger Dijkstra in 1965, is a way to understand the
                challenges of sharing resources in a system where multiple processes run at the same time.
                The problem helps us explore important concepts like avoiding deadlocks (where no one can continue) and
                fairness (everyone gets to eat).
                We will take a look at the problem in detail, discuss its challenges, and explore several solutions.
                This website features both a Java-based Simulation and Animation page that will let you
                experiment with the discussed concepts.
            </p>
        </div>
    </div>
    <div class="nav">
        <h4>Page Contents</h4>
        <ul>
            <li><a href="#general">General Explanation</a></li>
            <li><a href="#challenges">Challenges</a></li>
            <li><a href="#limitations">Limitations</a></li>
            <li><a href="#implementation">Implementation</a></li>
            <li><a href="#simulation">Simulation</a></li>
            <li><a href="#solutions">Solutions</a></li>
        </ul>
    </div>
</div>

<div class="description">

    <img src="pictures/dining.png" alt="Dining Philosophers Problem" width="400" height="350">

    <section id="general">
        <h3>The Philosophers</h3>
        <p>
            The Dining Philosophers Problem can be formulated in various ways, we will use the following definition:
            Philosophers sit around a table, with a chopstick between each pair.
            They start out thinking, then attempt to pick up the chopsticks on their left and right.
            Only one philosopher can hold a chopstick at a time, so they may need to wait until their neighbor returns
            it to the table.
            If two philosophers try to pick up the same chopstick simultaneously, only one will succeed.
            Once a philosopher has acquired both chopsticks, they may eat. After eating, they return the chopsticks, and
            the cycle
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
        <p>
            This cycle runs for all philosophers simultaneously.
            In our case, we want the process to run until a specified timeout is reached.
            When this time limit is reached, all philosophers are terminated.
        </p>
        <img src="pictures/eatsleep.png" alt="Dining Philosophers Problem" width="400" height="60">
        <br>
        <p>
            We determine the times spent eating and thinking using the following distributions:
        </p>
        <ul>
            <li><b>Deterministic:</b> The time-delay for eating or thinking is the same for all philosophers.</li>

            <li><b>Interval:</b> The time-delay is randomly selected within a specific range, for example, between 50
                and
                100 milliseconds.
            </li>
            <li><b>Normal:</b> The time-delay varies symmetrically around a mean, with deviations following a
                normal distribution.
            </li>
            <li><b>Exponential:</b> The time-delay is usually small, but occasionally, much larger values can occur,
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
            Scroll -------->

            PH_0 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][PUL][PUR][ E ][   ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][PUL][   ][   ][   ][PUR][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][ E ][ E ][PDL][PDR][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][   ][   ][ T ][ T ][PUL][ B ][ B ][ B ][   ][   ][PUR][   ]
            PH_1 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][ B ][ B ][ B ][ B ][ B ][   ][   ][PUL][   ][   ][PUR][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][PDL][PDR][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][ T ][ T ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][ E ][   ][   ][   ][ E ][ E ][   ][ E ][ E ][ E ][PDL][PDR][   ][   ]
            PH_2 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][PUR][   ][   ][ E ][   ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][PDL][   ][PDR][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][   ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][PUR][ E ][ E ][   ][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][ T ][   ][   ][   ][ T ][ T ][   ][ T ][ T ][ T ][   ][   ][   ][PUL]
            PH_3 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][   ][ T ][ T ][ B ][ B ][ B ][   ][   ][   ][   ][   ][   ][   ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][ T ][ T ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ B ][   ][   ][PUL][   ][ B ][   ][   ][PUR][ E ][ E ][   ][ E ][ E ][ E ][   ][   ][   ][   ]
            PH_4 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][   ][ T ][PUL][ B ][ B ][ B ][ B ][ B ][   ][   ][   ][PUR][   ][   ][   ][   ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][   ][   ][   ][   ][   ][   ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][   ][   ][   ][ T ][ T ][   ][   ][PUL][PUR][   ][ E ][ E ][ E ][ E ][ E ][ E ][   ][   ][   ][   ][ E ][PDL][PDR][   ][ T ][ T ][   ][ T ][ T ][ T ][   ][   ][   ][   ]
            TIME:  1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59   60   61   62   63   64   65   66   67   68   69   70   71   72   73   74   75   76   77   78   79   80   81   82   83   84

            Scroll -------->
        </code></pre>

        <p>
            Note that whenever a philosopher attempts to pick up or put down a chopstick we assume a synchronization
            point to determine the correct order of these actions after the simulation.
            Empty brackets are displayed to signify that philosophers took no action at that time.
        </p>
    </section>
    <section id="challenges">
        <h2>Challenges</h2>
        <p>
            There are three main challenges we encounter in the Dining Philosophers Problem:
            Deadlocks, Starvation/Fairness and Concurrency.
            We also introduce two "side-challenges": Implementation and Performance.
            The effectiveness of our solution in addressing one or more of these challenges will help us evaluate the
            quality of the different approaches later on.
        </p>
        <h3>Deadlocks</h3>
        <img src="pictures/deadlock.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Deadlocks can occur if all the philosophers pick up the chopstick to their left simultaneously and then wait
            for the chopstick to their right.
            In this situation, none of the philosophers can proceed, leading to indefinite waiting.
            This occurs because the system satisfies the Deadlock conditions, as defined by Coffman:
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
            For convenience, we assume that philosophers usually pick up their left chopsticks first, thus we can
            conveniently track
            whether a deadlock has occurred by checking
            if the last action of all philosophers was a [PUL] = Pick Up Left.
        </p>

        <p>
            At this stage, it is useful to introduce the concept of "precedence graphs", which are often used to
            represent dependencies between tasks.

            In the context of the Dining Philosophers Problem, each philosopher is represented as a node, and the
            directed arrows indicate dependencies.
            Since all philosophers have to wait for their right neighbor, this means that there is a circular dependency
            of the philosophers.
        </p>
        <img src="pictures/precedence.svg" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Cyclic dependencies like these indicate potential deadlocks in a system (essentially a visualization of the
            circular-wait condition).
            Avoiding this circular pattern is one of the main ways we are going to prevent deadlocks in a
            dining philosophers solution.
            Another crucial detail is the length of the precedence path, as it is at the maximum length in the naive
            approach.
            Long paths in a precedence graph mean that there are potentially long waiting chains that harm parallelism.
        </p>
        <h3>Starvation and Fairness</h3>
        <img src="pictures/starvation.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            Starvation happens when one or more philosophers rarely, or never, get a chance to eat. The prime example
            for starvation are deadlocks, which starve all philosophers.
            Other examples for starvation are: One philosopher repeatedly grabs the
            chopstick first, stopping the neighbor from eating.
            One philosopher takes a very long time to eat, making neighbors wait for access to the
            chopstick.
            The goal is to make sure that every philosopher has a fair chance to eat (and not starve), we call this
            fairness.

            There are several ways, in which starvation and fairness can be defined for the dining philosophers problem.
            In the following we want to consider starvation as the theoretical possibility of philosophers not being
            able to eat at all after a certain point in time.

            Thus, if there is no starvation in our system, philosophers who want to pick up chopsticks will eventually
            succeed.
            With this definition we guarantee fairness whenever a system is starvation-free.

            With our solution, we aim to prevent deadlocks while also maintaining fairness as much as possible.

        </p>
        <p>
            Additional to the basic notion of fairness of eventually succeeding to pick up, we introduce the two
            measures:
        </p>
        <ul>
            <li><b>Eat Chance Fairness:</b>
                We count how often each philosopher eats and calculate the standard
                deviation (variation from the average).
                Large values mean bad fairness, while values near zero indicate good fairness.
            </li>

            <li><b>Eat Time Fairness:</b> We also track the total simulation time each philosopher spent eating
                and calculate the standard deviation.
                Large values again mean bad fairness, while small values mean good fairness.
                This measure depends heavily on the chosen distribution, for example, the exponential distribution might
                return large outliers.
            </li>
        </ul>
        <p>
            In the context of implementations we sadly have to accept that scheduling of threads (and consequently
            philosophers) is never fair.
            The Operating system and in the case of Java, the Java Virtual Machine, work in "mysterious ways" and
            depending on system configuration (for example, number of processor cores) algorithms will behave vastly
            different.
            These scheduling and re-scheduling effects can lead to unexpected starvation.

        </p>

        <p>
            Here an example for the naive expectation how the philosophers would behave:
        </p>
        <table class="styled-table">
            <tr>
                <th>Philosopher 1</th>
                <th>Philosopher 2</th>
                <th>Philosopher 3</th>
            </tr>
            <tr>
                <td>Attempt to pick up left chopstick</td>
                <td>Think</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Acquire left chopstick</td>
                <td>Attempt to pick up left chopstick</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Attempt to pick up right chopstick</td>
                <td>Acquire left chopstick</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Wait for right chopstick</td>
                <td>Attempt to pick up right chopstick</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Wait for right chopstick</td>
                <td>Acquire right chopstick</td>
                <td>Attempt to pick up left chopstick</td>
            </tr>
            <tr>
                <td>Wait for right chopstick</td>
                <td>Eat</td>
                <td>Wait for left chopstick</td>
            </tr>
            <tr>
                <td>Wait for right chopstick</td>
                <td>Eat</td>
                <td>Wait for left chopstick</td>
            </tr>
            <tr>
                <td>Wait for right chopstick</td>
                <td>Put down left chopstick</td>
                <td>Wait for left chopstick</td>
            </tr>
        </table>

        <p>
            Here a more realistic schedule where philosophers 2 and 3 are suspended by the scheduler to run other
            processes:
        </p>
        <table class="styled-table">
            <tr>
                <th>Philosopher 1</th>
                <th>Philosopher 2</th>
                <th>Philosopher 3</th>
            </tr>
            <tr>
                <td> Attempt to pick up left chopstick.</td>
                <td> Think</td>
                <td> Think</td>
            </tr>
            <tr>
                <td> Acquire left chopstick.</td>
                <td></td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Attempt to pick up right chopstick</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>Acquire right chopstick</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td> Eat</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>Eat</td>
                <td>Attempt to pick up left chopstick</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Put down left chopstick</td>
                <td>Wait for left chopstick</td>
                <td>Think</td>
            </tr>
            <tr>
                <td>Put down right chopstick</td>
                <td>Wait for left chopstick</td>
                <td>Attempt to pick up left chopstick</td>
            </tr>
        </table>

        <p>
            It is obvious that scheduling can change the behavior significantly,
            so this is something to bear in mind when implementing solutions.
            In our case this effect could lead to repeated re-acquiring of a chopstick by one philosopher,
            which could cause starvation of the neighbor.
            (Based on the computer Science Best-Practice: Anything that can go wrong will go wrong.)
        </p>


        <h3>Concurrency</h3>
        <img src="pictures/concurrency.png" alt="Dining Philosophers Problem" width="400" height="350">
        <p>
            One simple way to prevent deadlocks is to allow only one philosopher to eat at a time.
            However, this would remove the ability for multiple philosophers to eat at the same time.
            In our case, concurrency means that multiple philosophers can progress simultaneously without waiting for
            each other, unless absolutely necessary. Our solution should ideally maintain concurrency while also
            preventing deadlocks and providing fairness.
        </p>
        <p>
            To measure concurrency in our system we introduce the concurrency measure:
        </p>
        <ul>
            <li>
                <b>Concurrency:</b> When a simulation is finished we get a timeline of length <b>l</b> (Total tracked
                Simulation Time excluding pick-ups/ put-downs).
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
            We should also consider how difficult the implementation of a solution is when compared to other solutions.
            Many will be rather simple to implement, while some others will utilize more complex concepts.
        </p>
        <h3>Performance</h3>
        <p>
            Finally, we want to evaluate algorithms based on the overhead they produce and how scalable they are.
            Some Solutions use several data structures and synchronization mechanisms, that produce additional
            computational effort.
            In our case, scalability refers to increasing the number of philosophers at the table.
        </p>


    </section>

    <section id="limitations">
        <h2>Limitations</h2>
        <p>
            Before exploring solutions, let us discuss the main limitations of the problem.
            One key limitation is that the maximum concurrency is restricted by the rules.
            Under ideal conditions, the maximum number of philosophers who can eat simultaneously is limited to
            <b>[n/2]</b> (integer division) for even numbers of n philosophers and <b>⌊n/2⌋</b> for odd n.
            For example, with 5 philosophers, <b>⌊5/2⌋</b> equals <b>2</b>, meaning that at most two philosophers can
            eat at the same time.
            In real-world systems, access to shared resources often involves more complex dependencies, where multiple
            processes may share more than two resources, which cannot be replicated using the dining philosophers
            problem
            without significantly changing its rules.

            <!-- Another limitation is the assumption of preemption, where eating or thinking can be interrupted.
            In real-world systems, tasks are often non-preemptive, meaning they must run to completion without being
            suspended or terminated. -->

            Other constraints, such as the assumed homogeneity of resources (in reality, resources may have different
            constraints), time constraints (some processes must 'eat' within a specific timeframe), or unexpected
            unavailability (processes may crash or terminate), are also typically not accounted for.

            As a result, many solutions we will explore may not directly apply to such real-world systems.
        </p>

    </section>

    <section id="implementation">
        <div class="description">
            <h2>Naive Dining Philosophers Implementation</h2>
            <p>
                The following Java-inspired pseudocode demonstrates the principles of a naive solution to
                the Dining Philosophers problem, leading to deadlocks.
                The philosophers actions are logged over time, based on a virtual clock running during the simulation.
                For simplicity, most of the Java boilerplate (Necessary for Java programs but not useful for
                understanding of the concept) and some simulation logic for consistency of logs have been
                omitted.
                If you are interested in the full implementation of this project, it is available
                on GitHub here. //link to GitHub
            </p>
            <p>
                <b>Pseudocode Philosopher class:</b>
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
                log.add(event + ":" + timeInstance) //a log of this style is parsed in the backend to then display the timeline/ statistics of the simulation
            }

        }
    </code></pre>
            <p>
                <b>Pseudocode Chopstick class: </b>
                The synchronized keyword ensures exclusive access to the pickUp() and putDown() methods.
                Philosophers have to enter a waiting state using the wait() method if the chopstick is currently
                taken.
                When another philosopher puts down a chopstick the waiting philosopher is notified using the
                notify() method.
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
                <b>Dining Table class: </b>
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

        // initialize philosophers, each with a left and right chopstick
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

    // method to terminate all philosophers
    void stopDinner() {
        for (Philosopher philosopher : philosophers) {
            philosopher.terminate();
        }
    }

    // method to run the simulation
    void execute() {
        int simulationTime = 100; // total time for the simulation
        int numPhilosophers = 5; // number of philosophers at the table
        Table diningTable = new Table(numPhilosophers);

        // start all the philosopher threads
        diningTable.startDinner();

        // run the simulation using a virtual clock
        while (simulationTime > 0) {
            VirtualClock.advanceTime(); //advance clock time
            timeStep(); // pause for the duration of a timestep (the server-sided simulation uses 5 ms)
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
                    philosophers. However, due to factors like changes in the execution environment (Java Virtual Machine or Operating System
                    rescheduling tasks), deadlocks could still occur, especially with longer runtimes.
                </td>
            </tr>
            <tr>
                <td><b>Starvation and Fairness</b></td>
                <td>Due to the possibility of deadlocks, starvation is a fundamental problem in our naive approach.
                    However, letting the philosophers wait for a notification to acquire the chopstick lowers the risk
                    of starvation (when we are lucky and no deadlocks occur), but does not prevent it. (wait(), notify()
                    pattern in Chopstick class)
                    Rescheduling or suspension of threads by Operating System or
                    Java VM could allow philosophers to acquire chopsticks repeatedly before their neighbor.
                    The solution to this follows below.
                </td>
            </tr>
            <tr>
                <td><b>Concurrency</b></td>
                <td>The naive dining philosophers solution has a limited potential of concurrency (as long as deadlocks
                    do not occur). This is due to the long path in the precedence graph, leading to long waiting chains.
                    Simulations frequently have low/no concurrency because of this.
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
                <td>We will base the performance of solutions on this implementation. Large numbers of philosophers will lead to long wait chains. </td>
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
            For exactly this reason, we utilize fair semaphores to control access to chopsticks in the solutions we
            explore.
            This will prevent barging and thus the re-acquiring of chopsticks. (contrary to the "naive" chopstick
            class)
            Now, even if the Operating System or Java VM re-schedule or suspend threads, we can guarantee that the
            longest waiting philosopher will acquire the chopstick first. (if no deadlock occurs -of course)
            Note that we introduce an overhead, due to the managed FIFO queues.
        </p>
        <pre style="font-size: 14px;"><code class="language-java">
            class Chopstick {

                Semaphore chopstickSemaphore;  // semaphore controlling access to the chopstick.

                Chopstick(int id) {
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
                <td><b>Starvation and Fairness</b></td>
                <td>
                    Starvation is still possible due to the possibility of deadlocks, but at least we prevent barging,
                    and therefor the re-acquiring of chopsticks.
                </td>
            </tr>


            </tbody>
        </table>

    </section>

    <section id="simulation">
        <h2>Simulation</h2>

        <p>
            This website offers a Simulation Page and an Animation Page, both powered by a Java Threads-based
            backend that is in principle very similar to the pseudocode provided later.
            The Simulation Page allows you to run a simulation and view the resulting simulation output as timelines,
            with detailed notes on the simulation settings available on that page.
            The Animation Page lets you run a simulation that is then visually animated, with further details also
            provided on that page.
            To see the Naive Dining Philosophers in action, you can try either the Simulation Page or the Animation
            Page.
            Please note that the Animation is limited to the classic 5-philosopher setup, while the Simulation
            Page allows you to experiment with 2 to 9 philosophers.
        </p>
        <a href="../simulation/?algorithm=NAIVE" class="button">Simulation Page</a>
        <a href="../animation/?algorithm=NAIVE" class="button">Animation Page</a>
        <br>
        <br>
    </section>

</div>

    <section id="solutions">
        <h2>Solutions</h2>

        <div class="container">
            <div class="main-content">
                <div class="description">
                <p>The buttons below link to different solutions that aim to address one or more of the challenges discussed
                    earlier.
                </p>

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

                <!--<div class="description-box">
                    <p>
                        To learn about some advanced solutions based on more recent literature:
                    </p>
                    <a href="advanced" class="button">Advanced Solutions</a>
                </div> -->

                </div>
            </div>
            <div class="post-it">
                <h4>Note on Correct Solutions:</h4>
                <p>
                    Finding a correct solution to the dining philosophers problem has been shown to be no trivial task.
                    Many approaches have been proven to be incorrect in a later re-evaluation.
                </p>
                <p>Correct solutions must be:</p>
                <ul>
                    <li><b>Deadlock-free</b></li>
                    <li><b>Starvation-free</b></li>
                    <li><b>Concurrent</b></li>
                    <li><b>Correctly Implemented</b> (correct usage of synchronization mechanisms)</li>
                </ul>
            </div>
        </div>






    </section>



</body>
</html>

