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

        /* General styling for the code block container */
        pre {
            background-color: #f5f5f5;
            border: 1px solid #ccc;
            padding: 15px;
            overflow: auto;
            white-space: pre-wrap; /* Wrap lines */
            word-wrap: break-word; /* Break long lines */
            border-radius: 5px; /* Rounded corners */
            font-family: "Courier New", Courier, monospace;
        }

        /* Styling for the actual code */
        code {
            background-color: #f5f5f5; /* Match pre background */
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 14px;
        }

        /* Optional: Additional styling for line numbers (if needed) */
        pre.line-numbers {
            counter-reset: line; /* Reset line counter */
        }

        pre.line-numbers code::before {
            counter-increment: line; /* Increment line counter */
            content: counter(line); /* Display line number */
            display: inline-block;
            width: 2em;
            margin-right: 10px;
            text-align: right;
            color: #999;
        }
    </style>
</head>
<body>
<h2>Naive Dining Philosophers Implementation</h2>
<div class="description">
    <p>The following Java-Inspired pseudocode illustrates the principles of a Naive Implementation of the Dining
        Philosophers problem.
        <br>
        In Java synchronized methods may only be entered by one thread (In our case philosopher) at a time.
        This helps us ensure the exclusivity in accessing the Chopsticks.
        <br>
        The logs of the philosophers are mapped in time according to a time point that is determined by a virtual clock running during the simulation.
        <br>
        For simplicity the majority of the Java boilerplate and some of the simulation logic to ensure consistency was left out in this pseudocode.
        If you are interested in the actual implementation of this Project, it is available on Github here. //link github
    </p>
    <p> Pseudocode Philosopher class: </p>
    <pre><code>
        public class NaivePhilosopher extends AbstractPhilosopher {
            Fork leftFork;
            Fork rightFork;
            List log;

            NaivePhilosopher(Fork leftFork, Fork rightFork) {
                this.leftFork = leftFork;
                this.rightFork = rightFork;
            }

            run() {
                while (!terminated()) {
                    think();
                    pickUpLeftFork();
                    pickUpRightFork();
                    eat();
                    putDownLeftFork();
                    putDownRightFork();
                }
            }

            think() {
                long duration = calculateDuration();
                sleep(duration);
                Log("[ T ]", VirtualClock.getTime());
            }

            pickUpLeftFork() {
                leftFork.pickUp(this);
                Log("[PUL]", VirtualClock.getTime());
            }

            pickUpRightFork() {
                rightFork.pickUp(this);
                Log("[PUR]", VirtualClock.getTime());
            }

            eat() {
                long duration = calculateDuration();
                sleep(duration);
                Log("[ E ]", VirtualClock.getTime());
            }

            putDownLeftFork() {
                leftFork.putDown(this);
                Log("[PDL]", VirtualClock.getTime());
            }

            putDownRightFork() {
                rightFork.putDown(this);
                Log("[PDR]", VirtualClock.getTime());
            }

            Log(String event, long timeInstance){
                log.add(event + timeInstance)
            }

        }
    </code></pre>
    <p>Pseudocode for Fork class:</p>

    <pre><code>
    public abstract class AbstractFork {
        protected boolean isAvailable = true;

        synchronized boolean pickUp(AbstractPhilosopher philosopher) {
            while (!isAvailable) {
                wait();
            }
            isAvailable = false;
            return true;
        }

        synchronized void putDown(AbstractPhilosopher philosopher) {
            isAvailable = true;
            notify();
        }
    }
    </code></pre>
    <p>The backbone of the simulation is a virtual clock running during the execution.
        The Philosophers log their Actions according to the current time of the clock.
        <br>
        Pseudocode for Dining Table class and exemplary main function:</p>
    <pre><code>
    public class Table {
        Fork[] forks;
        NaivePhilosopher[] philosophers;

        Table(int numPhilosophers) {
            forks = new Fork[numPhilosophers];
            philosophers = new NaivePhilosopher[numPhilosophers];

            // Initialize forks
            for (int i = 0; i < numPhilosophers; i++) {
                forks[i] = new Fork();
            }

            // Initialize philosophers
            for (int i = 0; i < numPhilosophers; i++) {
                Fork leftFork = forks[i];
                Fork rightFork = forks[(i + 1) % numPhilosophers];
                philosophers[i] = new NaivePhilosopher(leftFork, rightFork);
                }
            }

            startDinner() {
                for (NaivePhilosopher philosopher : philosophers) {
                    new Thread(philosopher).start();
                }
            }

            stopDinner() {
            for (NaivePhilosopher philosopher : philosophers) {
                philosopher.terminate();
            }
        }

        main(String[] args) {
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

</body>
</html>
