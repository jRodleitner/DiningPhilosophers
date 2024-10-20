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
<h2>Restrict Solution</h2>
<div class="description">
    <p>The Restrict Solution </p>
    <img src="../pictures/restrict.svg" alt="Dining Philosophers Problem" width="400" height="350">#
    <p>
        One effective method to prevent deadlocks in the dining philosophers problem is to limit the number of philosophers allowed to attempt eating at the same time.
        For a group of n philosophers, we restrict this number to n-1, meaning only n-1 philosophers can try to pick up their chopsticks simultaneously.
        To introduce at least some fairness, we pass this restriction around the philosophers.
        After a philosopher finishes picking up their chopsticks, the restriction moves to the next adjacent philosopher(in our implementation to the right).


    </p>

    <p>
        We introduce a Restrict class that handles the restricted philosopher:
    </p>
    <pre><code>
        [PseudoCode]

        class Restrict {

            int restrict;
            int numberOfPhilosophers;

            Restrict(int numberOfPhilosophers){
                restrict = 0;
                this.numberOfPhilosophers = numberOfPhilosophers;
            }

            synchronized void updateRestricted(){
                restrict = (restrict + 1) % numberOfPhilosophers;
            }

            synchronized int getRestricted(){
                return restrict;
            }
        }
    </code></pre>
    <p>
        The Philosopher class can stay as is, we only have to modify the Fork class.
        For this purpose we create a Subclass and add the according changes.
    </p>
    <pre><code>
        [PseudoCode]

        class RestrictChopstick extends Chopstick {

            Restrict restrict;


            RestrictChopstick(int id, Restrict restrict) {
                super(id);
                this.restrict = restrict;
            }

            @Override
            synchronized boolean pickUp(AbstractPhilosopher philosopher) {
                while (!isAvailable || philosopher.getPhId() == restrict.getRestricted() ) {
                    wait();
                }
                if(this.equals( philosopher.getRightFork())){
                    //update restricted when philosopher picked up both chopsticks
                    restrict.updateRestricted();
                }
                isAvailable = false;
                return true;
            }

        }
    </code></pre>

    <p>Now let us evaluate the Restrict solution based on the key-challenges:</p>
    <ul>
        <li>Deadlocks: By limiting the number of philosophers to (n-1), we eliminate the possibility of the circular wait condition, as defined by Coffman.</li>
        <li>Starvation: </li>
        <li>Fairness: We do not provide fairness to the system using this solution</li>
        <li>Concurrency: We do not prevent concurrency but in some situations we could block a philosopher from eating, when it would be possible.</li>
        <li>Implementation: The changes required to implement this solution are simple. </li>
        <li>Performance: Overhead </li>
    </ul>

    <p>
        You can find the respective Simulation and Animation pages here:
    </p>
    <a href="../simulation/?algorithm=RESTRICT" class="button">Restrict Simulation</a>
    <a href="../animation/?algorithm=RESTRICT" class="button">Restrict Animation</a>
</div>

</body>
</html>
