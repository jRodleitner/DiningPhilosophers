<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dining Philosophers Simulation Page</title>
    <script>
        function updateLabels() {
            // Update labels for thinkDistribution
            var thinkDistribution = document.getElementById('thinkDistribution').value;
            var thinkParam1Label = document.getElementById('thinkparam1Label');
            var thinkParam2Label = document.getElementById('thinkparam2Label');
            //var thinkParam1Input = document.getElementById('thinkparam1');
            var thinkParam2Input = document.getElementById('thinkparam2');

            if (thinkDistribution === 'INTERVAL') {
                thinkParam1Label.textContent = 'Lb:';
                thinkParam2Label.textContent = 'Ub:';
                thinkParam2Label.style.display = 'inline';
                thinkParam2Input.style.display = 'inline';
            } else if (thinkDistribution === 'DETERMINISTIC') {
                thinkParam1Label.textContent = 'det:';
                thinkParam2Label.style.display = 'none';
                thinkParam2Input.style.display = 'none';
            } else if (thinkDistribution === 'NORMAL') {
                thinkParam1Label.textContent = 'mu:';
                thinkParam2Label.textContent = 'sigma:';
                thinkParam2Label.style.display = 'inline';
                thinkParam2Input.style.display = 'inline';
            } else if (thinkDistribution === 'EXP') {
                thinkParam1Label.textContent = 'lambda:';
                thinkParam2Label.style.display = 'none';
                thinkParam2Input.style.display = 'none';
            }

            // Update labels for eatDistribution
            var eatDistribution = document.getElementById('eatDistribution').value;
            var eatParam1Label = document.getElementById('eatparam1Label');
            var eatParam2Label = document.getElementById('eatparam2Label');
            //var eatParam1Input = document.getElementById('eatparam1');
            var eatParam2Input = document.getElementById('eatparam2');

            if (eatDistribution === 'INTERVAL') {
                eatParam1Label.textContent = 'Lb:';
                eatParam2Label.textContent = 'Ub:';
                eatParam2Label.style.display = 'inline';
                eatParam2Input.style.display = 'inline';
            } else if (eatDistribution === 'DETERMINISTIC') {
                eatParam1Label.textContent = 'det:';
                eatParam2Label.style.display = 'none';
                eatParam2Input.style.display = 'none';
            } else if (eatDistribution === 'NORMAL') {
                eatParam1Label.textContent = 'mu:';
                eatParam2Label.textContent = 'sigma:';
                eatParam2Label.style.display = 'inline';
                eatParam2Input.style.display = 'inline';
            } else if (eatDistribution === 'EXP') {
                eatParam1Label.textContent = 'lambda:';
                eatParam2Label.style.display = 'none';
                eatParam2Input.style.display = 'none';
            }
        }

        window.onload = function() {
            // Update labels when the page loads
            updateLabels();
        };
    </script>
</head>
<body>
<h1>Simulation Page</h1>

<form name="simulationForm" action="/simulation" method="post">

    <label for="algorithm">Choose an Algorithm:</label>
    <select id="algorithm" name="algorithm">


        <option value="NAIVE">Naive</option>
        <option value="ASYMMETRIC">Asymmetric</option>
        <option value="HIERARCHY">Hierarchy</option>
        <option value="restrict">Restrict</option>
        <option value="timeout">Timeout</option>
        <option value="CHANDYMISRA">Chandy-Misra</option>

        <optgroup label="Token">
            <option value="Multiple Token">Multiple Token</option>
            <option value="Global Token">Global Token</option>
        </optgroup>
        <optgroup label="Waiter">
            <option value="Atomic Waiter">Atomic Waiter</option>
            <option value="Pickup Waiter">Pickup Waiter</option>
            <option value="Fair Waiter">Fair Waiter</option>
            <option value="Two Waiters">Two Waiters</option>
        </optgroup>
        <optgroup label="Semaphore">
            <option value="algo4">Dijkstra</option>
            <option value="algo4">Tanenbaum</option>
            <option value="algo4">Fair Tanenbaum</option>
            <option value="algo4">Round-Robin</option>
            <option value="algo4">Table-Semaphore</option>
        </optgroup>
    </select>

    <br><br>

    <label for="nrPhil">Number of Philosophers (2-9):</label><br>
    <input type="number" id="nrPhil" name="nrPhil" min="2" max="9" value="${param.nrPhil != null ? param.nrPhil : '5'}" required><br><br>

    <label for="simulationTime">Simulation Time (10-3000):</label><br>
    <input type="number" id="simulationTime" name="simulationTime" min="10" max="3000" value="${param.simulationTime != null ? param.simulationTime : '50'}" required><br><br>

    <!-- Think Distribution -->
    <label for="thinkDistribution">Think Distribution :</label>
    <select id="thinkDistribution" name="thinkDistribution" onchange="updateLabels()">
        <option value="INTERVAL">Interval</option>
        <option value="DETERMINISTIC">Deterministic</option>
        <option value="NORMAL">Normal</option>
        <option value="EXP">Exponential</option>
    </select>

    <br>
    <label id="thinkparam1Label" for="thinkparam1">Lb:</label>
    <input type="number" id="thinkparam1" name="thinkparam1" min="0" max="500" value = "${param.thinkparam1 != null ? param.thinkparam1 : '50'}" >

    <label id="thinkparam2Label" for="thinkparam2">Ub:</label>
    <input type="number" id="thinkparam2" name="thinkparam2" min="0" max="500" value="${param.thinkparam2 != null ? param.thinkparam2 : '100'}" ><br><br>

    <!-- Eat Distribution -->
    <label for="eatDistribution">Eat Distribution :</label>
    <select id="eatDistribution" name="eatDistribution" onchange="updateLabels()">
        <option value="INTERVAL">Interval</option>
        <option value="DETERMINISTIC">Deterministic</option>
        <option value="NORMAL">Normal</option>
        <option value="EXP">Exponential</option>
    </select>

    <br>
    <label id="eatparam1Label" for="eatparam1">Lb:</label>
    <input type="number" id="eatparam1" name="eatparam1" min="0" max="500" value = "${param.eatparam1 != null ? param.eatparam1 : '50'}" >

    <label id="eatparam2Label" for="eatparam2">Ub:</label>
    <input type="number" id="eatparam2" name="eatparam2" min="0" max="500" value="${param.eatparam2 != null ? param.eatparam2 : '100'}" ><br><br>

    <input type="submit" value="Run Simulation">
</form>

<c:if test="${not empty result}">
    <h2>Simulation Result</h2>
    <pre>${result}</pre>
</c:if>

</body>
</html>
