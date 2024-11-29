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

        li {
            margin-left: 2em;
            text-indent: -2em;
        }
    </style>
</head>
<body>
<h2>About</h2>
<div class="description">
    Hi, my name is Jona, I am a Computer Science Student at Johannes Kepler University in Linz, Austria.
    This Website is the Project for my Bachelors Thesis and aims to provide a deeper understanding of the
    Dining Philosophers Problem.
    I present and evaluate several Algorithms, with which you can interact and learn about on the
    Simulation and Animation pages.

    <h3>Bibliography: </h3>
    <ol>
        <li id="citation1" >[1] Dijkstra, Edsger W. EWD-1000. E.W. Dijkstra Archive. Center for American History, University of Texas at Austin. https://www.cs.utexas.edu/~EWD/ewd10xx/EWD1000.PDF</li>
        <li id="citation2" >[2] Andrew S. Tanenbaum. Operating Systems: Design and Implementation. 3rd edition. Pearson Education, Inc., 2006.</li>
        <li id="citation3" >[3] Dijkstra, E. W. Hierarchical ordering of sequential processes. Acta Informatica 1(2): 115–138, 1971</li>
        <li id="citation4" >[4] Andrew S. Tanenbaum, Herbert Bos. Modern Operating Systems. 4th edition. Pearson Education, Inc., 2015. ????</li>
        <li id="citation5" >[5] Allen B. Downey. The Little Book of Semaphores. 2nd edition. Green Tea Press, 2011 p????.</li>
        <li id="citation6" >[6] Nancy A. Lynch. Distributed Algorithms. Morgan Kaufmann, 1996. p. ?????</li>
        <li id="citation7" >[7] R. Davidrajuh. "Verifying Solutions to the Dining Philosophers Problem with Activity-Oriented Petri Nets." Proceedings of the 4th International Conference on Artificial Intelligence with Applications in Engineering and Technology (ICAIET), 2014, pp. 163–168.</li>
        <li id="citation8" >[8] C. A. R. Hoare. Communicating Sequential Processes. NJ, USA: Prentice Hall, 1985.</li>
        <li id="citation9" >[9] William Stallings. Operating Systems: Internals and Design Principles. 9th edition. Harlow, Essex, England: Pearson, 2018, p. 310. ???? </li>
        <li id="citation10" >[10] K. M. Chandy, J. Misra. "The Drinking Philosophers Problem." ACM Transactions on Programming Languages and Systems, 1984. </li>
        <li id="citation11" >[11] Abraham Silberschatz, Peter B. Galvin, Greg Gagne. Operating System Concepts. 10th edition. Wiley, 2018. p ?????</li>
        <li id="citation12" >[12] Lars Wanhammar. "DSP Algorithms." In DSP Integrated Circuits, Academic Press, 1999, pp. 225–275. </li>
        <li id="citation13" >[13] Edward G. Coffman Jr., Michael J. Elphick, Arie Shoshani. "System Deadlocks." ACM Computing Surveys, vol. 3, no. 2, 1971, pp. 67–78. </li>
        <li id="citation14" >[14] Hagit Attiya, Roy Friedman. "Local and Global Fairness in Concurrent Systems." Proceedings of the 12th Annual ACM Symposium on Principles of Distributed Computing, 1993, pp. 163–174.</li>
    </ol>

    <h3>Web Sources Used:</h3>
    <ol>
        <li id="w_citation1">[1] URL: https://zerobone.net/blog/cs/dining-philosophers-problem/</li>
        <li id="w_citation2">[2] URL: https://docs.oracle.com/javase/1.5.0/docs/api/java/util/concurrent/locks/ReentrantLock.html</li>
        <li id="w_citation3">[3] URL: https://www.stolaf.edu/people/rab/pdc/text/dpsolns.html?utm_source=chatgpt.com</li>
        <li id="w_citation4">[4] URL: https://softwaresim.com/blog/introduction-to-discrete-time-simulation/ </li>

        <li id="w_citation5">[5] Another Author, "Another Source", Another Publisher, Year.</li>
        <li id="w_citation6">[6] Another Author, "Another Source", Another Publisher, Year.</li>
        <li id="w_citation7">[7] Another Author, "Another Source", Another Publisher, Year.</li>
        <li id="w_citation8">[8] Another Author, "Another Source", Another Publisher, Year.</li>
        <li id="w_citation9">[9] Another Author, "Another Source", Another Publisher, Year.</li>
    </ol>

    <h3>Resources/ Libraries Used:</h3>
    <ol>
        <li>Pseudocode Highlighting: Prism.js URL: https://prismjs.com/</li>
        <li>Web Server - Backend: Jakarta Servlet URL: https://jakarta.ee/specifications/servlet/</li>
        <li>Web Server Deployment: Apache Tomcat URL: https://tomcat.apache.org/</li>
        <li>IDE: Intellij</li>
        <li>Project: Maven</li>
    </ol>
</div>
</body>
</html>
