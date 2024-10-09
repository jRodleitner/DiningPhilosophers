
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
    </style>
</head>
<body>
<div class="description">
    <h2>Atomic Waiter Solution</h2>
    <img src="../pictures/waiter.svg" alt="Dining Philosophers Problem" width="400" height="350">
    <p>The Waiter Solution introduces an additional entity into the system, that handles requests according to a queue.
        When a philosopher wants to eat they have to notify the waiter. The waiter will then push the request into its queue.
        The philosopher that was added to the queue first will then be permitted to eat. After the philosopher finished eating the waiter
        will then hand the permission to the philosopher next in the queue.

    Since only one philosopher is permitted to eat at a time, we avoided the circular wait
        condition but sadly also eliminated the concurrency from our system.
    </p>

    <img src="../pictures/waiter-request.svg" alt="Dining Philosophers Problem" width="400" height="350">

    <ul>
        <li>Deadlocks: Prevents deadlocks</li>
        <li>Fairness: We introduce ...</li>
        <li>Concurrency: Concurrency of the system is given, since the philosophers are not prevented from eating by this approach.</li>
        <li>Implementation: The changes required to implement this solution are quite minimal, no complex logic needed. </li>
    </ul>

    <h2>Pickup Waiter Solution</h2>
    <p>We can reintroduce some concurrency into the system by limiting the permission only to the times of pickups.
        This ensures that multiple philosophers will be able to get a permission by the waiter.  </p>

    <h2>Fair Waiter Solution</h2>


    <h2>Two Waiters Solution</h2>
    <img src="../pictures/multiplewaiters.svg" alt="Dining Philosophers Problem" width="400" height="350">
</div>


<h2>Atomic Waiter Solution</h2>
</body>
</html>
