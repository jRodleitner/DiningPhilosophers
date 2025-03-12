
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About</title>
    <style>
        .button {
            display: inline-block;
            color: white;
            background-color: #216477;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 20px;
            font-weight: bold;
            transition: background-color 0.3s ease, color 0.3s ease;
            margin: 5px 0;
        }

        /* Hover Effect */
        .button:hover {
            background-color: #438699;
            color: #e0e0e0;
        }

        .description {
            line-height: 1.4;
            color: #333;
            padding: 14px;
            margin-bottom: 15px;
            max-width: 800px;
        }

        ol {
            list-style-type: none;
            margin-right: 1cm;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin-bottom: 15px;
        }


    </style>
</head>
<body>
<h2>About</h2>
<div class="description">
    <p>
        Hi, my name is Jona, I am a Computer Science Student at Johannes Kepler University in Linz, Austria.
        This Website is the Project for my Bachelors Thesis "Building a webapplication to compare algorithms for coordinating processes", and aims to provide a deeper understanding of the
        Dining Philosophers Problem.
        I present and evaluate several Algorithms, with which you can interact and learn about on the
        Simulation and Animation pages.
    </p>
    <h3>Books and Academic Research used:</h3>
    <ol>
        <li>Matthew J. Sottile, Timothy G. Mattson, Craig E. Rasmussen - <i>Introduction to Concurrency in Programming Languages</i> (2009) - <a href="https://www.taylorfrancis.com/books/mono/10.1201/b17174/introduction-concurrency-programming-languages-matthew-sottile-timothy-mattson-craig-rasmussen">Link</a></li>

        <li>Brian Goetz, Tim Peierls, Joshua Bloch, Joseph Bowbeer, David Holmes, Doug Lea - <i>Java Concurrency in Practice</i> (2006)</li>

        <li>Andrew S. Tanenbaum, Herbert Bos - <i>Modern Operating Systems</i> (4th ed., 2015)</li>

        <li>Andrew S. Tanenbaum, Maarten Van Steen - <i>Distributed Systems: Principles and Paradigms</i> (2nd ed., 2007)</li>

        <li>Abraham Silberschatz, Peter B. Galvin, Greg Gagne - <i>Operating System Concepts</i> (10th ed., 2018)</li>

        <li>Nancy A. Lynch - <i>Distributed Algorithms</i> (1996)</li>

        <li>Allen B. Downey - <i>The Little Book of Semaphores</i> (2nd ed., 2011) - <a href="https://greenteapress.com/semaphores/">Link</a></li>

        <li>William Stallings - <i>Operating Systems: Internals and Design Principles</i> (9th ed., 2018)</li>


        <li>Arnold Buss, Ahmed Al Rowaei - <i>A Comparison of the Accuracy of Discrete Event and Discrete Time</i> (2010) - <a href="https://doi.org/10.1109/WSC.2010.5679045">Link</a></li>

        <li>C. A. R. Hoare - <i>Communicating Sequential Processes</i> (1978) - <a href="https://doi.org/10.1145/359576.359585">Link</a></li>

        <li>E. W. Dijkstra - <i>EWD 1000</i> (1987) - <a href="http://www.cs.utexas.edu/users/EWD/">Link</a></li>

        <li>E. W. Dijkstra - <i>Hierarchical Ordering of Sequential Processes</i> (1971) - <a href="https://doi.org/10.1007/BF00289517">Link</a></li>

        <li> Coffman, Edward G. Jr., Elphick, Michael J., Shoshani, Arie - <i>System Deadlocks</i> (1971) - <a href="https://dl.acm.org/doi/10.1145/356586.356588" target="_blank">Link</a> </li>

        <li> Davidrajuh, R. - <i>Verifying Solutions to the Dining Philosophers Problem with Activity-Oriented Petri Nets</i> (2014) - <a href="https://ieeexplore.ieee.org/document/7351829" target="_blank">Link</a> </li>

        <li> Krishnaprasad, S. - <i>Concurrent/Distributed Programming Illustrated Using the Dining Philosophers Problem</i> (2003) - <a href="https://dl.acm.org/doi/abs/10.5555/767598.767617" target="_blank">Link</a> </li>

        <li>Chandy, K. M., Misra, J. - <i>The Drinking Philosophers Problem</i> (1984) - <a href="https://dl.acm.org/doi/10.1145/1780.1804">Link</a> </li>

        <li>Armando R. Gingras - <i>Dining Philosophers Revisited</i> (1990) - <a href="https://doi.org/10.1145/101085.101091">Link</a></li>


    </ol>

    <h3>Web Resources Used:</h3>
    <ol>
        <li>Wikipedia contributors - <i>Dining Philosophers Problem</i> - <a href="https://en.wikipedia.org/wiki/Dining_philosophers_problem">Link</a></li>

        <li>Oracle - <i>Java Language Specification, Java SE 8 Edition: Section 17.2.2</i> (2014) - <a href="https://docs.oracle.com/javase/specs/jls/se8/html/jls-17.html#jls-17.2.2">Link</a></li>

        <li>Oracle - <i>ReentrantLock</i> - <a href="https://docs.oracle.com/javase/1.5.0/docs/api/java/util/concurrent/locks/ReentrantLock.html">Link</a></li>

        <li>Oracle - <i>Semaphore</i> - <a href="https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html">Link</a></li>

        <li>Oracle - <i>Synchronization Methods</i> - <a href="https://docs.oracle.com/javase/tutorial/essential/concurrency/syncmeth.html">Link</a></li>

        <li>Alexander Mayorov - <i>The Dining Philosophers Problem and Different Ways of Solving It</i> (2021) - <a href="https://zerobone.net/blog/cs/dining-philosophers-problem/">Link</a></li>

        <li>Impact Media Lab - <i>Visual Design for SciComm</i> - <a href="https://www.impactmedialab.com/scicomm/visual-design-for-scicomm">Link</a></li>

        <li>Anonymous - <i>Dining Philosophers Code Example</i> - <a href="https://ideone.com/GQie7p">Link</a></li>

        <li>Richard Allen Bartle - <i>Solutions to the Dining Philosophers Problem</i> - <a href="https://www.stolaf.edu/people/rab/pdc/text/dpsolns.html">Link</a></li>
    </ol>

    <h3>Technologies/ Libraries used:</h3>
    <ol>
        <li>Language: Java 22 - <a href="https://www.oracle.com/java/technologies/javase/jdk22-archive-downloads.html">Link</a></li>
        <li>Pseudocode Highlighting: Prism.js - <a href="https://prismjs.com/">Link</a></li>
        <li>Web Server - Backend: Jakarta Servlet - <a href="https://jakarta.ee/specifications/servlet/">Link</a></li>
        <li>Web Server Deployment: Apache Tomcat - <a href="https://tomcat.apache.org/">Link</a></li>
        <li>IDE used: IntelliJ - <a href="https://www.jetbrains.com/idea/">Link</a></li>
        <li>Project Build: Maven - <a href="https://maven.apache.org/">Link</a></li>
    </ol>

    <h3>Related Work:</h3>
    <ol>

        <li>Justin DeBenedetto et al. - <i>Placating Plato with Plates of Pasta: An Interactive Tool for Teaching the Dining Philosophers Problem</i> (2017) - <a href="https://doi.org/10.1109/FIE.2017.8190443">Link</a></li>

        <li>University of Notre Dame - <i>Interactive Explanation of the Dining Philosophers Problem</i> - <a href="https://nlp.nd.edu/justin/dining/interactiveExplanation.php">Link</a></li>

        <li>Dmitry Zinoviev - <i>Discrete Event Simulation: It's Easy with SimPy!</i> (2018) - <a href="https://doi.org/10.48550/arXiv.2405.01562">Link</a></li>

        <li> Wilensky, U. - <i>NetLogo Dining Philosophers Model</i> (2003) - <a href="http://ccl.northwestern.edu/netlogo/models/DiningPhilosophers">Link</a></li>

        <li> Nguyen, T. M., Nguyen, C. D., Nguyen, T. H., Ngo, T. T. H. - <i>OS Dining Philosopher - University Project</i> (2022) - <a href="https://github.com/minhngt62/os-dining-philosopher" target="_blank">Link</a> </li>
    </ol>
</div>
</body>
</html>
