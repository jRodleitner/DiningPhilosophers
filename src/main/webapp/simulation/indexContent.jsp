<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dining Philosophers Simulation Page</title>
    <style>
        .container {
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px; /* Adds space between the form and the result box */
            /*background-color: #FF6F61;*/
            background-image: radial-gradient(circle, #FFC857, #008080, #FFDAB9);
            border-radius: 10px;
            padding: 20px;
        }

        .container1 {
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px; /* Adds space between the form and the result box */
        }

        .scrollable-box {
            width: 1150px;
            height: 370px;
            border: 1px solid #ccc;
            padding: 10px;
            overflow-y: scroll;
            overflow-x: scroll;
            background-color: #f0f0f0;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;
            border-radius: 10px;
        }

        .fixed-box {
            width: 1500px;
            height: 150px;
            border: 1px solid #ccc;
            padding: 5px;
            background-color: #f0f0f0;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;
            border-radius: 10px;
        }

        .form-container {
            max-width: 700px; /* Adjust based on your form's size */
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #f0f0f0;
            border-radius: 10px;
        }

        pre {
            font-family: inherit; /* Inherit from .scrollable-box */
            white-space: pre;
        }

        .error {
            color: red;
        }
    </style>
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

            // Update visibility for timeout
            var algorithm = document.getElementById('algorithm').value;
            var timeoutLabel = document.getElementById('timeoutLabel');
            var timeoutInput = document.getElementById('timeout');

            if (algorithm === 'TIMEOUT') {
                timeoutLabel.style.display = 'inline';
                timeoutInput.style.display = 'inline';
            } else {
                timeoutLabel.style.display = 'none';
                timeoutInput.style.display = 'none';
            }

        }

        window.onload = function () {
            updateLabels();
            document.getElementById('algorithm').addEventListener('change', updateLabels);
        };
    </script>
</head>
<body>
<h2>Simulation Page</h2>

<div class="container">
    <!-- Scrollable Box for Results -->
    <div class="scrollable-box">
        <c:if test="${not empty result}">
            <pre>${result}</pre>
        </c:if>
    </div>

    <!-- Form Container -->
    <div class="form-container">

        <form name="simulationForm" action="/simulation" method="post">

            <label for="algorithm">Choose an Algorithm:</label>
            <select id="algorithm" name="algorithm">
                <option value="NAIVE" <%= "NAIVE".equals(request.getParameter("algorithm")) ? "selected" : "" %>>Naive
                </option>
                <option value="ASYMMETRIC" <%= "ASYMMETRIC".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Asymmetric
                </option>
                <option value="HIERARCHY" <%= "HIERARCHY".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Hierarchy
                </option>
                <option value="RESTRICT" <%= "RESTRICT".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Restrict
                </option>
                <option value="TIMEOUT" <%= "TIMEOUT".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Timeout
                </option>
                <option value="CHANDYMISRA" <%= "CHANDYMISRA".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Chandy-Misra
                </option>

                <optgroup label="Token">
                    <option value="MULTIPLETOKEN" <%= "MULTIPLETOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Multiple Token
                    </option>
                    <option value="GLOBALTOKEN" <%= "GLOBALTOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Global Token
                    </option>
                </optgroup>

                <optgroup label="Waiter">
                    <option value="ATOMICWAITER" <%= "ATOMICWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Atomic Waiter
                    </option>
                    <option value="PICKUPWAITER" <%= "PICKUPWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Pickup Waiter
                    </option>
                    <option value="FAIRWAITER" <%= "FAIRWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Waiter
                    </option>
                    <option value="TWOWAITERS" <%= "TWOWAITERS".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Two Waiters
                    </option>
                </optgroup>

                <optgroup label="Semaphore">
                    <option value="DIJKSTRA" <%= "DIJKSTRA".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Dijkstra
                    </option>
                    <option value="TANENBAUM" <%= "TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Tanenbaum
                    </option>
                    <option value="FAIRTANENBAUM" <%= "FAIRTANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Tanenbaum
                    </option>
                    <option value="ROUNDROBIN" <%= "ROUNDROBIN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Round-Robin
                    </option>
                    <option value="TABLESEMAPHORE" <%= "TABLESEMAPHORE".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Table-Semaphore
                    </option>
                </optgroup>
            </select>

            <br><br>

            <label for="nrPhil">Number of Philosophers (2-9):</label>
            <input type="number" id="nrPhil" name="nrPhil" min="2" max="9"
                   value="${param.nrPhil != null ? param.nrPhil : '5'}" required><br><br>

            <label for="simulationTime">Simulation Time (10-500):</label>
            <input type="number" id="simulationTime" name="simulationTime" min="10" max="500"
                   value="${param.simulationTime != null ? param.simulationTime : '50'}" required><br><br>

            <!-- Think Distribution -->
            <label for="thinkDistribution">Think Distribution:</label>
            <select id="thinkDistribution" name="thinkDistribution" onchange="updateLabels()">
                <option value="INTERVAL" <%= "INTERVAL".equals(request.getParameter("thinkDistribution")) ? "selected" : "" %>>
                    Interval
                </option>
                <option value="DETERMINISTIC" <%= "DETERMINISTIC".equals(request.getParameter("thinkDistribution")) ? "selected" : "" %>>
                    Deterministic
                </option>
                <option value="NORMAL" <%= "NORMAL".equals(request.getParameter("thinkDistribution")) ? "selected" : "" %>>
                    Normal
                </option>
                <option value="EXP" <%= "EXP".equals(request.getParameter("thinkDistribution")) ? "selected" : "" %>>
                    Exponential
                </option>
            </select>

            <br>
            <label id="thinkparam1Label" for="thinkparam1">Lb:</label>
            <input type="number" id="thinkparam1" name="thinkparam1" min="0" max="500"
                   value="${param.thinkparam1 != null ? param.thinkparam1 : '50'}">
            <label id="thinkparam2Label" for="thinkparam2">Ub:</label>
            <input type="number" id="thinkparam2" name="thinkparam2" min="0" max="500"
                   value="${param.thinkparam2 != null ? param.thinkparam2 : '100'}"><br><br>

            <!-- Eat Distribution -->
            <label for="eatDistribution">Eat Distribution:</label>
            <select id="eatDistribution" name="eatDistribution" onchange="updateLabels()">
                <option value="INTERVAL" <%= "INTERVAL".equals(request.getParameter("eatDistribution")) ? "selected" : "" %>>
                    Interval
                </option>
                <option value="DETERMINISTIC" <%= "DETERMINISTIC".equals(request.getParameter("eatDistribution")) ? "selected" : "" %>>
                    Deterministic
                </option>
                <option value="NORMAL" <%= "NORMAL".equals(request.getParameter("eatDistribution")) ? "selected" : "" %>>
                    Normal
                </option>
                <option value="EXP" <%= "EXP".equals(request.getParameter("eatDistribution")) ? "selected" : "" %>>
                    Exponential
                </option>
            </select>


            <br>
            <label id="eatparam1Label" for="eatparam1">Lb:</label>
            <input type="number" id="eatparam1" name="eatparam1" min="0" max="500"
                   value="${param.eatparam1 != null ? param.eatparam1 : '50'}">
            <label id="eatparam2Label" for="eatparam2">Ub:</label>
            <input type="number" id="eatparam2" name="eatparam2" min="0" max="500"
                   value="${param.eatparam2 != null ? param.eatparam2 : '100'}">
            <br>

            <label id=timeoutLabel for="timeout">Timeout (5-500):</label>
            <input type="number" id="timeout" name="timeout" min="5" max="500"
                   value="${param.timeout != null ? param.timeout : '200'}" required>
            <br>
            <br>


            <label for="simulationType">Simulation Type:</label>
            <select id="simulationType" name="simulationType" onchange="updateLabels()">
                <option value="true" <%= "true".equals(request.getParameter("simulationType")) ? "selected" : "" %>>
                    SimulatePickup
                </option>
                <option value="false" <%= "false".equals(request.getParameter("simulationType")) ? "selected" : "" %>>
                    Simple
                </option>
            </select>
            <br>
            <br>
            <input type="submit" value="Run Simulation">
        </form>
    </div>
</div>
<br>
<div class="container1">
    <div class="fixed-box">
        <h3>Legend</h3>
        <p>[ T ] = Think, [ E ] = Eat, [ B ] = Blocked, [PUB] = Pick up Both Forks, [PUL] = Pick up left Fork, [PUL] =
            Pick up right Fork, [PDR] = Put down right Fork, [PDL] = Put down left Fork</p>
        <br>
    </div>

</div>
<h2>Simulation Notes</h2>
<p>Execution Time: The Execution Time can be set up to 3000 Simulation units, thus there is a significant waiting time
    until the results are returned by the server</p>
</body>
</html>
