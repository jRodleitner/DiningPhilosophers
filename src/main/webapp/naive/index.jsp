<%--
  Created by IntelliJ IDEA.
  User: jonar
  Date: 27.08.2024
  Time: 11:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Naive Dining Philosophers</title>
  </head>
  <body>
  <h1>NAIVE page</h1>


  <form name="simulationForm" action="index.jsp" method="post">
    <label for="nrPhil">Number of Philosophers (1-9):</label><br>
    <input type="number" id="nrPhil" name="nrPhil" min="1" max="9" required><br><br>

    <label for="simulationTime">Simulation Time (11-2999):</label><br>
    <input type="number" id="simulationTime" name="simulationTime" min="11" max="2999" required><br><br>

    <input type="submit" value="Run Simulation">
  </form>


  </body>
</html>
