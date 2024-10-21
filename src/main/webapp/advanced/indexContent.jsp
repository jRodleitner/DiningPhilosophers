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
<h2>Advanced Solution</h2>
<div class="description">
  <img src="../pictures/chandymisra.svg" alt="Dining Philosophers Problem" width="400" height="350">
  <p>
    On this page I want to introduce you to some newer approaches to the Dining Philosophers Problem, based on
    more recent literature.
  </p>
  <ul>
    <li>Impl.</li>
  </ul>
  <img src="../pictures/chandymisra_init.svg" alt="Dining Philosophers Problem" width="400" height="350">
  <p>
    Boob beeb pop
  </p>

  <p>
    To implement theChandy-Misra Solution
  </p>
  <pre><code>
        [PseudoCode]


    </code></pre>

  <pre><code>
        [PseudoCode]

    </code></pre>

  <p>
    Now let us evaluate the  Algorithm according to the key challenges:
  </p>
  <ul>
    <li>Deadlocks:</li>
    <li>Fairness: </li>
    <li>Concurrency: </li>
    <li>Implementation:  </li>
    <li>Performance:  </li>
  </ul>

  <p>
    You can find the respective Simulation and Animation pages here:
  </p>

  <a href="../simulation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Simulation</a>
  <a href="../animation/?algorithm=CHANDYMISRA" class="button">Chandy-Misra Animation</a>





</div>

</body>
</html>
