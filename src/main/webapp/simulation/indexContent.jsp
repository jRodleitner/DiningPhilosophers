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
            height: 411px;
            border: 1px solid #ccc;
            padding: 10px;
            overflow-y: scroll;
            overflow-x: scroll;
            background-color: #f8f8f8;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;
            border-radius: 10px;
        }

        .fixed-box {
            width: 1500px;
            height: 150px;
            border: 1px solid #ccc;
            padding: 5px;
            background-color: #f8f8f8;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;
            border-radius: 10px;
        }

        .form-container {
            max-width: 700px; /* Adjust based on your form's size */
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #f8f8f8;
            border-radius: 10px;
        }

        pre {
            font-family: inherit; /* Inherit from .scrollable-box */
            white-space: pre;
        }

        .description {
            line-height: 1.6; /* Increases spacing between lines for readability */
            color: #333;
            padding: 3px;
            margin-bottom: 3px;
            max-width: 900px;
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

            const thinkparam1 = document.getElementById('thinkparam1');
            const thinkparam2 = document.getElementById('thinkparam2');

            switch (thinkDistribution) {
                case 'INTERVAL':
                    thinkparam1.min = 30;
                    thinkparam1.max = 400;
                    thinkparam2.min = 30;
                    thinkparam2.max = 400;
                    break;
                case 'DETERMINISTIC':
                    thinkparam1.min = 30;
                    thinkparam1.max = 400;
                    break;
                case 'NORMAL':
                    thinkparam1.min = 50;
                    thinkparam1.max = 400;
                    thinkparam2.min = 0;
                    thinkparam2.max = 20;
                    break;
                case 'EXP':
                    thinkparam1.min = 3;
                    thinkparam1.max = 12;
                    break;

            }

            const eatparam1 = document.getElementById('eatparam1');
            const eatparam2 = document.getElementById('eatparam2');

            switch (eatDistribution) {
                case 'INTERVAL':
                    eatparam1.min = 30;
                    eatparam1.max = 400;
                    eatparam2.min = 30;
                    eatparam2.max = 400;
                    break;
                case 'DETERMINISTIC':
                    eatparam1.min = 30;
                    eatparam1.max = 400;
                    break;
                case 'NORMAL':
                    eatparam1.min = 50;
                    eatparam1.max = 200;
                    eatparam2.min = 1;
                    eatparam2.max = 40;
                    break;
                case 'EXP':
                    eatparam1.min = 3;
                    eatparam1.max = 12;
                    break;

            }

        }

        function updateThinkDistribution() {
            const thinkDistribution = document.getElementById('thinkDistribution').value;
            const thinkparam1 = document.getElementById('thinkparam1');
            const thinkparam2 = document.getElementById('thinkparam2');

            switch (thinkDistribution) {
                case 'INTERVAL':
                    thinkparam1.setAttribute('value', "50");  // Set default value for Interval
                    thinkparam2.setAttribute('value', "100"); // Set default value for Interval
                    break;
                case 'DETERMINISTIC':
                    thinkparam1.setAttribute('value', "100");  // Set default value for Deterministic
                    break;
                case 'NORMAL':
                    thinkparam1.setAttribute('value', "75");  // Set default value for Normal
                    thinkparam2.setAttribute('value', "5");  // Set default value for Normal
                    break;
                case 'EXP':
                    thinkparam1.setAttribute('value', "5");   // Set default value for Exponential
                    break;

            }
        }

        function updateEatDistribution() {
            const eatDistribution = document.getElementById('eatDistribution').value;
            const eatparam1 = document.getElementById('eatparam1');
            const eatparam2 = document.getElementById('eatparam2');

            switch (eatDistribution) {
                case 'INTERVAL':
                    eatparam1.setAttribute('value', "50");  // Set default value for Interval
                    eatparam2.setAttribute('value', "100"); // Set default value for Interval
                    break;
                case 'DETERMINISTIC':
                    eatparam1.setAttribute('value', "100");
                    break;
                case 'NORMAL':
                    eatparam1.setAttribute('value', "75");  // Set default value for Normal
                    eatparam2.setAttribute('value', "5");  // Set default value for Normal
                    break;
                case 'EXP':
                    eatparam1.setAttribute('value', "5");   // Set default value for Exponential
                    break;

            }

        }

        window.onload = function () {
            updateLabels();

            document.getElementById('algorithm').addEventListener('change', updateLabels);
            document.getElementById('eatDistribution').addEventListener('change', updateEatDistribution);
            document.getElementById('thinkDistribution').addEventListener('change', updateThinkDistribution);
        };


    </script>
</head>
<body>
<h2>Dining Philosophers Simulation Page</h2>

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
                <option value="HIERARCHY" <%= "HIERARCHY".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Hierarchy
                </option>
                <option value="ASYMMETRIC" <%= "ASYMMETRIC".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Asymmetric
                </option>
                <option value="TIMEOUT" <%= "TIMEOUT".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Timeout
                </option>
                <option value="RESTRICT" <%= "RESTRICT".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Restrict
                </option>
                <option value="CHANDYMISRA" <%= "CHANDYMISRA".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                    Chandy-Misra
                </option>

                <optgroup label="Token">
                    <option value="GLOBALTOKEN" <%= "GLOBALTOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Global Token
                    </option>
                    <option value="MULTIPLETOKEN" <%= "MULTIPLETOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Multiple Token
                    </option>

                </optgroup>

                <optgroup label="Waiter">
                    <option value="ATOMICWAITER" <%= "ATOMICWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Atomic Waiter
                    </option>
                    <option value="PICKUPWAITER" <%= "PICKUPWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Pickup Waiter
                    </option>
                    <option value="INTELLIGENTWAITER" <%= "INTELLIGENTWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Intelligent Pickup Waiter
                    </option>
                    <option value="FAIR_CHANCE_WAITER" <%= "FAIR_CHANCE_WAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Eat Chance Waiter
                    </option>
                    <option value="FAIR_EATTIME_WAITER" <%= "FAIR_EATTIME_WAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Eat Time Waiter
                    </option>
                    <option value="TWOWAITERS" <%= "TWOWAITERS".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Two Waiters
                    </option>
                </optgroup>

                <optgroup label="Semaphore">
                    <option value="TABLESEMAPHORE" <%= "TABLESEMAPHORE".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Table-Semaphore
                    </option>
                    <option value="DIJKSTRA" <%= "DIJKSTRA".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Dijkstra
                    </option>
                    <option value="TANENBAUM" <%= "TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Tanenbaum
                    </option>
                    <option value="FAIR_CHANCE_TANENBAUM" <%= "FAIR_CHANCE_TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Chance Tanenbaum
                    </option>
                    <option value="FAIR_TIME_TANENBAUM" <%= "FAIR_TIME_TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Eat Time Tanenbaum
                    </option>
                    <option value="ROUNDROBIN" <%= "ROUNDROBIN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Round-Robin
                    </option>
                </optgroup>
            </select>

            <br><br>

            <label for="nrPhil">Number of Philosophers (2-9):</label>
            <input type="number" id="nrPhil" name="nrPhil" min="2" max="9"
                   value="${param.nrPhil != null ? param.nrPhil : '5'}" required><br><br>

            <label for="simulationTime">Simulation Time (100-1000):</label>
            <input type="number" id="simulationTime" name="simulationTime" min="100" max="1000"
                   value="${param.simulationTime != null ? param.simulationTime : '100'}" required><br><br>

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
            <input type="number" id="thinkparam1" name="thinkparam1" min="30" max="400" step="0.001"
                   value="${param.thinkparam1 != null ? param.thinkparam1 : '50'}">
            <label id="thinkparam2Label" for="thinkparam2">Ub:</label>
            <input type="number" id="thinkparam2" name="thinkparam2" min="30" max="400" step="0.001"
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
            <input type="number" id="eatparam1" name="eatparam1" min="30" max="400" step="0.001"
                   value="${param.eatparam1 != null ? param.eatparam1 : '50'}">
            <label id="eatparam2Label" for="eatparam2">Ub:</label>
            <input type="number" id="eatparam2" name="eatparam2" min="30" max="400" step="0.001"
                   value="${param.eatparam2 != null ? param.eatparam2 : '100'}">
            <br>

            <label id=timeoutLabel for="timeout">Timeout (10-200):</label>
            <input type="number" id="timeout" name="timeout" min="10" max="200"
                   value="${param.timeout != null ? param.timeout : '100'}" required>
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
            <input type="submit" value="&#9654; Run Simulation" style="font-size: 16px; padding: 10px 20px;">
        </form>
    </div>
</div>
<br>
<div class="container1">
    <div class="fixed-box">
        <h3>Legend</h3>
        <p>[ T ] = Think, [ E ] = Eat, [ B ] = Blocked, [PUB] = Pick up Both Forks, [PUL] = Pick up left Fork, [PUL] =
            Pick up right Fork, [PDR] = Put down right Fork, [PDL] = Put down left Fork, [   ] = Philosopher does nothing (other philosopher performs pickup/putdown)</p>
        <br>
    </div>

</div>
<h2>Simulation Notes</h2>
<div class="description">
<p>
    This is a simulation page that lets you experiment with the different solutions presented on this website.
    Every simulation run will be unique and dependent on the chosen parameters/ algorithms.
    Most of the time simulations will be longer than the length of the simulation box, so horizontal scrolling of this
    box will be necessary.
    <br>
    There are several options, with which you can alter the simulation parameters:
</p>
<ul>

    <li><b>Number of philosophers: </b>On this Simulation page simulations with 2-9 philosophers is possible. We limit the number of philosophers on here due to Server constraints.</li>

    <li><b>Execution Time: </b> The simulation utilizes a Discrete Time-Stepping Virtual Time.
        One time "unit" represents a loop iteration that is a step in the simulation timeline.
        We control the actual time passage via a short waiting period in each iteration to give the philosophers time to complete actions.
        Philosophers use this reference time to log their respective actions after completion.
        This results in a quantization effect where each completed act is mapped to a discrete virtual simulation-time point.
        Note that there is an actual simulation running in the background that utilizes Java Threads.
        Increasing the simulation time will prolong the execution time of the backend, due to the longer simulation duration and the following processing of the results.
        The maximum execution time is 1000, this will result in a waiting period of up to 20 seconds before results are visible.
    </li>

    <li><b>Distribution settings: </b> There are four types of distributions that can be chosen.
        <ul>
           <li>Deterministic: Only has one parameter and is a static delay. For the naive implementation this will provoke deadlocks!</li>
            <li>Interval: This distribution calculates a value between the given Lb = Lower Bound and Ub = Upper Bound.</li>
            <li>Normal:  Has parameters mu = &mu; = the mean, and sigma = &sigma; = the standard deviation.
                This will simulate philosophers with normally distributed delays, according to the given parameters.</li>
            <li>Exponential: Parameter lambda = &lambda; = rate parameter. Frequent low values, but sometimes large outliers occur. Lower lambda means that higher values become more likely.</li>

        </ul>
    </li>
    <li><b>Simulation Type: </b> Two types are available. The Simulate Pickups mode lets you track the pick-ups and put-downs of the philosophers.
        Since simulating the pickups results in a slight overhead, there is also a "simple" mode, that is a little more performant and will return results quicker.
        This helps to track the behavior of the algorithms.
        The "simple" mode will only display thinking and eating.</li>

</ul>

<p>
    Bear in mind that for  simulation runs simulation timelines can differ in length, as philosophers log actions only after they finished an action.
    When the solution is completed there is a cut-off point and philosophers are no longer able to log their actions.
    Especially for the exponential and normal distributions longer run times might be necessary, since large outliers are possible with these distributions.

    <img src="../pictures/distribution.svg" alt="Dining Philosophers Problem" width="847" height="225">


</p>
</div>
</body>
</html>
