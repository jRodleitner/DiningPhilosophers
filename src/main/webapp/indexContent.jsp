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
            line-height: 1.4; /* Increases spacing between lines for readability */
            color: #333;
            padding: 14px;
            margin-bottom: 15px;
            max-width: 800px;
        }

        /* Add a Google Font if Needed */
    </style>
</head>
<body>
<h2>The Dining Philosophers Problem</h2>
<!-- General Description -->
<div class="description">
    <p>The Dining Philosophers Problem is a classic thought experiment to illustrate the challenges of designing concurrent systems. It was introduced by Edsgar Dijkstra in 1965.  </p>
    <img src="pictures/dining.png" alt="Dining Philosophers Problem" width="400" height="350">
    <h3>The Philosophers</h3>
    <p>The process of a Philosopher consists  </p>
    <ul>
        <li>Think for some time</li>
        <li>Pick up Chopsticks</li>
        <li>Eat for some time</li>
        <li>Put down chopsticks</li>
    </ul>
    <img src="pictures/eatsleep.png" alt="Dining Philosophers Problem" width="400" height="60">
    <p></p>
    <h3>Challenges</h3>

    <h4>Deadlocks</h4>
    <img src="pictures/deadlock.png" alt="Dining Philosophers Problem" width="400" height="350">
    <h4>Starvation</h4>
    <img src="pictures/starvation.png" alt="Dining Philosophers Problem" width="400" height="350">
    <h4>Concurrency</h4>
    <img src="pictures/concurrency.png" alt="Dining Philosophers Problem" width="400" height="350">

    <h2>Solutions</h2>
</div>

<a href="hierarchy_asymmetric" class="button">Asymmetric/ Resource Hierarchy Solution</a>
<br/>
<a href="timeout" class="button">Timeout Solution</a>
<br/>
<a href="token" class="button">Token Solution</a>
<br/>
<a href="waiter" class="button">Waiter Solution</a>
<br/>
<a href="semaphore" class="button">Semaphore Solution</a>
<br/>
<a href="restrict" class="button">Restrict Solution</a>
<br/>
<a href="chandymisra" class="button">Chandy-Misra Solution</a>
<br/>
</body>
</html>

