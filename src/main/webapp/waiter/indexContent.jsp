
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
            padding: 15px;
            overflow: auto;
            white-space: pre-wrap; /* Wrap lines */
            word-wrap: break-word; /* Break long lines */
            border-radius: 5px; /* Rounded corners */
            font-family: "Courier New", Courier, monospace;
        }


        code {
            background-color: #f5f5f5; /* Match pre background */
            color: #333;
            font-family: "Courier New", Courier, monospace;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="description">
    <h2>Atomic Waiter Solution</h2>
    <img src="../pictures/waiter.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        The Waiter Solution introduces a central entity to manage chopstick access and prevent deadlocks.
        With this approach, philosophers must notify the waiter whenever they want to eat.
        The waiter maintains a queue of requests and grants permission to eat based on the order in which philosophers were added the queue.
        When a philosopher is first in the queue, they are given permission to pick up both chopsticks and start eating.
        Once they finish, the waiter grants permission to the next philosopher in line, ensuring that only one philosopher eats at a time.
        By controlling access through the waiter, we eliminate the circular wait condition defined by Coffman.
        However, this approach also removes concurrency, meaning only one philosopher can eat at any given moment.
    </p>

    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>Now let us evaluate the Atomic Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We introduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>

    <pre><code>
        codeee
        codeee
    </code></pre>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>

    <h2>Pickup Waiter Solution</h2>
    <p>
        We can reintroduce some concurrency into the system by limiting the waiter's permission to just the chopstick pickup phase.
        This way, multiple philosophers can receive permission from the waiter simultaneously, allowing them to pick up chopsticks and eat at the same time.
        This approach helps to balance concurrency while still preventing deadlocks by avoiding the circular wait condition.
        Additionally, we check if the current philosopher in the queue is next to a philosopher who is currently eating.
        We skip this philosopher and allow another philosopher that is not adjacent to an eating philosopher to eat.
        The main drawback of this solution is that the waiter will always assign the permission to the philosopher that requested the chopsticks first.
        Thus, we do not provide any fairness to the system.
    </p>

    <p>Now let us evaluate the Pickup Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>
    <pre><code>
        codeee
        codeee
    </code></pre>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>

    <h2>Intelligent Pickup Waiter Solution</h2>
    <p>
        Additionally, we check if the current philosopher in the queue is next to a philosopher who is currently eating.
        We skip this philosopher and allow another philosopher that is not adjacent to an eating philosopher to eat.
        However, there is still one drawback to this solution, as a waiter will always assign the permission to the philosopher that requested the chopsticks first, or one that is currently able to eat.
        Thus we do not provide fairness to the system in this way.
    </p>

    <p>Now let us evaluate the Pickup Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>
    <pre><code>
        codeee
        codeee
    </code></pre>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>

    <h2>Fair Waiter Solution</h2>
    <p>
        We can enhance fairness in the Waiter Solution by tracking how many times each philosopher has had the
        chance to eat during the simulation.
        The waiter will then prioritize the philosopher with the least accumulated eating time,
        attempting to ensure that all philosophers get a fair opportunity to eat.
    </p>

    <p>Now let us evaluate the Fair Waiter approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>

    <pre><code>
        codeee
        codeee
    </code></pre>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>


    <h2>Two Waiters Solution</h2>
    <img src="../pictures/multiplewaiters.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>
        Another idea would be to introduce more than one waiter into the system.
        Each of the waiters will then be assigned to manage a subset of the philosophers.
    </p>
    <p>Now let us evaluate the Two Waiters approach based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We reintroduce ...</li>
        <li>Concurrency: The Atomic Waiter algorithm removes concurrency from the system</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
        <li>Performance: </li>
    </ul>

    <pre><code>
        codeee
        codeee
    </code></pre>
    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Simulation</a>
    <a href="../animation/?algorithm=ATOMICWAITER" class="button">Atomic Waiter Animation</a>
</div>


</body>
</html>
