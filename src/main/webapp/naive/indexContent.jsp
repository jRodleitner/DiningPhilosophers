<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Naive Dining Philosophers</title>
</head>
<body>
<h1>NAIVE page</h1>

<form name="simulationForm" action="/naive" method="post">
    <label for="nrPhil">Number of Philosophers (1-9):</label><br>
    <input type="number" id="nrPhil" name="nrPhil" min="1" max="9" value="${param.nrPhil}" required><br><br>

    <label for="simulationTime">Simulation Time (10-3000):</label><br>
    <input type="number" id="simulationTime" name="simulationTime" min="10" max="3000" value="${param.simulationTime}" required><br><br>

    <label for="choices">Choose an option:</label>
    <select id="choices" name="choices">
        <option value="option1">Option 1</option>
        <option value="option2">Option 2</option>
        <option value="option3">Option 3</option>
    </select>

    <input type="submit" value="Run Simulation">
</form>

<c:if test="${not empty result}">
    <h2>Simulation Result</h2>
    <pre>${result}</pre>
</c:if>

</body>
</html>
