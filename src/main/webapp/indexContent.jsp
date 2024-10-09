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
            line-height: 1.6; /* Increases spacing between lines for readability */
            color: #333;
            padding: 3px;
            margin-bottom: 3px;
            max-width: 900px;
        }


    </style>
</head>
<body>
<h2>The Dining Philosophers Problem</h2>
<!-- General Description -->
<div class="description">
    <p>The Dining Philosophers Problem is a classic thought experiment that is useful to illustrate some the challenges
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

    <h3>The Philosophers</h3>
    <p>N Philosophers are seated at a round table, with chopsticks placed between each pair of adjacent philosophers.
        The philosophers always start out thinking, after which they try to pick up the chopsticks to their left and
        right.
        Since only one of the philosophers can hold the chopstick at a time, waiting for the chopstick to become
        available may be necessary.
        If two philosophers try to acquire a chopstick at the same time, only one of them succeeds.
        After acquiring both chopsticks they can start eating, after which both chopsticks are returned to their
        positions on the table and the process starts anew.
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
    <p>This cycle is executed for all philosophers concurrently. In our case we repeat this until a timeout is reached,
        after which all philosophers are terminated.
        <br>
        <br>
        <img src="pictures/eatsleep.png" alt="Dining Philosophers Problem" width="400" height="60">
        <br>
        <br>

        We want to determine the think and eat times via fixed or random number generated wait times, to ensure
        closeness to real life scenarios, where execution times vary due to many different influences.
        The four time distributions we want to account for are:
    <ul>
        <li>deterministic (Execution time for eating/ thinking is the same for all philosophers)</li>
        <li>Interval (The calculated value is within an integer range, for example between 50 and 100 milliseconds)</li>
        <li>Normal (The calculated value is centered symmetrically around a number and varies according to a standard
            deviation)
        </li>
        <li>Exponential (the calculated value is more likely small but some very large outliers are possible)</li>
    </ul>
    </p>
    <p>To keep track of the philosophers actions we keep a Log for each Philosopher at each point in time, with the following Events being logged:
    <ul>
        <li>[ T ] = Thinking</li>
        <li>[PUL] = Left Chopstick picked up</li>
        <li>[PUR] = Right Chopstick picked up</li>
        <li>[ E ] = Eating ended</li>
        <li>[PDL] = Left Chopstick put down</li>
        <li>[PDR] = Right Chopstick put down</li>
        <li>[ B ] = Blocked state (Whenever waiting for a Chopstick occurs)</li>
    </ul>
    </p>

    <h3>Challenges</h3>
    <p>There are three main challenges that we face when we execute the philosophers in the naive way discussed above.
        The capability of our solution at solving one or more of these difficulties will help us determine the quality
        of the approaches later.
    </p>
    <h4>Deadlocks</h4>
    <img src="pictures/deadlock.png" alt="Dining Philosophers Problem" width="400" height="350">
    <p>Deadlocks can occur when all the philosophers grab the fork to their left at the same time and then wait for the
        fork to their right.
        If this happens the philosophers will be stuck in this state indefinitely and starve.
        Preventing this from happening is the main goal of the Solutions we want to explore.
    </p>
    <h4>Starvation</h4>
    <img src="pictures/starvation.png" alt="Dining Philosophers Problem" width="400" height="350">
    <p>Starvation occurs when one or more philosophers never/ rarely get the chance to eat.
        One of the ways this could happen is if one of the philosophers repeatedly succeeds in taking the chopstick
        first, preventing the other from eating.
        Another reason for starvation would result from very long eat times that occur in one philosopher, while the
        other one has very short eat times.
        Ensuring that all philosophers get equal chances to eat is a key goal to solve the problem.
        With our solution we want to ensure fairness as best as possible, while still preventing deadlocks.</p>
    <h4>Concurrency</h4>
    <img src="pictures/concurrency.png" alt="Dining Philosophers Problem" width="400" height="350">
    <p>One of the most simple ideas to prevent deadlocks is to allow only one philosopher at the table to eat.
        However this approach would eliminate the concurrency of the philosophers.
        Our solution should ensure concurrency, additionally to the prevention of deadlocks and ensuring fairness
        between them.
    </p>

</div>
<h2>Implementation</h2>

<div class="description">
    If you are interested, a pseudocode to illustrate the inner workings
    <br>
    of the Simulation can be found here: <a href="pseudocode/naive" >Naive Dining Philosophers Pseudocode</a>
</div>

<div class="description">
<h2>Limitations</h2>
<p>Before we explore solutions let us first discuss the main limitations of the given problem. Note that the maximum concurrency is limited under the given rules,
    bounding the maximum concurrency in our system under ideal conditions to [n/2] for even n and  &lfloor;n/2&rfloor; for uneven n.
    For example with n = 5 &lfloor;5/2&rfloor; = 2, 2 is the maximum concurrency we can reach. This means that if we seat 5 philosophers at our table a maximum of two philosophers are able to eat concurrently.
    <br>
    In real world systems access to multiple shared resources across processes is frequent (Not only two processes share a resource, but multiple/ Processes share more than two resources), these kinds of cross dependencies cannot be replicated
    using the dining philosopher problem without significantly altering the problem rules.
    Another limitation is the assumption of preemption (Eating/ Thinking may be terminated).
    <br>
    Real life systems are frequently non-preemptive, meaning their tasks need to run to completion and cannot be terminated/ suspended.
    <br>
    Many more like assumed homogenity (Chopsticks are the same for all philosophers, but actual resources might have varying constraints), time constraints (real life processes sometimes have to "eat" at an exact timeframe) or sudden unavailabilty (processes might crash/ terminate unexpectedly) are usually not considered.
    This means that many solutions are not applicable to such real life systems.
    <br>
    One constraint that we will ignore in our solutions is that traditionally philosophers are considered "silent", and thus are not permitted to communicate with each other.
</p>
</div>

<div class="description">
    <h2>Solutions</h2>
    <p>The following buttons lead to various solutions that try to address one or more of the previously discussed constraints</p>

    <p>To learn about solutions that focus on organizing the order of the pickups of chopsticks:</p>
    <a href="hierarchy_asymmetric" class="button">Asymmetric/ Resource Hierarchy Solution</a>
    <br/>
    <p>To learn about the timeout solution that prevents deadlocks via returning the initially acquired chopstick when the second chopstick is not available within a fixed timeframe:</p>
    <a href="timeout" class="button">Timeout Solution</a>
    <br/>
    <p>To learn about solutions that focus on tokens being passed around by the philosophers:</p>
    <a href="token" class="button">Token Solution</a>
    <br/>
    <p>To learn about solutions that utilize a central entity to organize the permission to eat or pick up chopsticks:</p>
    <a href="waiter" class="button">Waiter Solution</a>
    <br/>
    <p>To learn about solutions that utilize semaphores:</p>
    <a href="semaphore" class="button">Semaphore Solution</a>
    <br/>
    <p>To learn about the solution that limits the number of philosopher being able to pick up chopsticks:</p>
    <a href="restrict" class="button">Restrict Solution</a>
    <br/>
    <p>To learn about the solution that limits the number of philosopher being able to pick up chopsticks:</p>
    <a href="chandymisra" class="button">Chandy-Misra Solution</a>
    <br/>
</div>


</body>
</html>

