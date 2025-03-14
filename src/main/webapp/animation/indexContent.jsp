
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dining Philosophers Animation</title>
    <style>

        .container {
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;

            background-image: radial-gradient(circle, #FFC857, #008080, #FFDAB9);
            border-radius: 10px;
            padding: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .svg-container {
            width: 75%;
            height: 420px;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f8f8f8;
            border-radius: 10px;
            padding: 20px;
            gap: 10px;
        }

        .button-container {
            display: flex;
            gap: 10px;
        }


        .container1 {
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            position: relative;
        }



        .form-container {
            max-width: 25%;
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #f8f8f8;
            border-radius: 10px;
        }

        .hidden {
            display: none;
        }

        .blocked {
            fill: #F08080;
        }

        .eat {
            fill: #A8D5BA;
        }

        @keyframes blink {
            0% {
                opacity: 1;
            }
            50% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }


        .blink {
            animation: blink 0.5s infinite;
        }

        @keyframes quick-blink {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.13);
            }
            100% {
                transform: scale(1);
            }
        }

        .quick-blink {
            animation: quick-blink 0.1s;
            display: inline-block;
            transform-origin: center;
        }

        .soft-red-text {
            color: #cc6666;
        }

        .scrollable-box {

            width: 1500px;
            height: 400px;
            border: 2px solid #ccc;
            padding: 20px;
            overflow-y: scroll;
            overflow-x: scroll;
            background-color: #f8f8f8;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }


        .description {
            line-height: 1.6;
            color: #333;
            padding: 3px;
            margin-bottom: 3px;
            max-width: 900px;
        }

        .floating-box {
            position: fixed;
            top: 100px;
            right: 120px;
            padding: 15px;
            opacity: 80%;
            background-color: #AAAA;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            font-size: 16px;
            z-index: 1000;
            transition: opacity 0.5s;
        }

        .floating-box_1 {
            position: absolute;
            bottom: 3%;
            right: 1%;
            padding: 10px;
            opacity: 100%;
            background-color: #FFFACD;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-family: "Courier New", Courier, monospace;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            font-size: clamp(4px, 2vw, 13px);
            font-weight: bold;
            z-index: 1000;
            cursor: pointer;
        }

        .hidebox {
            opacity: 0;
            pointer-events: none;
        }

    </style>
    <script>
        function updateLabels() {

            var thinkDistribution = document.getElementById('thinkDistribution').value;
            var thinkParam1Label = document.getElementById('thinkparam1Label');
            var thinkParam2Label = document.getElementById('thinkparam2Label');

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

            var eatDistribution = document.getElementById('eatDistribution').value;
            var eatParam1Label = document.getElementById('eatparam1Label');
            var eatParam2Label = document.getElementById('eatparam2Label');

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
                    thinkparam1.max = 250;
                    thinkparam2.min = 1;
                    thinkparam2.max = 30;
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
                    eatparam1.max = 250;
                    eatparam2.min = 1;
                    eatparam2.max = 30;
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
                    thinkparam1.setAttribute('value', "50");
                    thinkparam2.setAttribute('value', "100");
                    break;
                case 'DETERMINISTIC':
                    thinkparam1.setAttribute('value', "100");
                    break;
                case 'NORMAL':
                    thinkparam1.setAttribute('value', "75");
                    thinkparam2.setAttribute('value', "20");
                    break;
                case 'EXP':
                    thinkparam1.setAttribute('value', "5");
                    break;

            }
        }

        function updateEatDistribution() {
            const eatDistribution = document.getElementById('eatDistribution').value;
            const eatparam1 = document.getElementById('eatparam1');
            const eatparam2 = document.getElementById('eatparam2');

            switch (eatDistribution) {
                case 'INTERVAL':
                    eatparam1.setAttribute('value', "50");
                    eatparam2.setAttribute('value', "100");
                    break;
                case 'DETERMINISTIC':
                    eatparam1.setAttribute('value', "100");
                    break;
                case 'NORMAL':
                    eatparam1.setAttribute('value', "75");
                    eatparam2.setAttribute('value', "20");
                    break;
                case 'EXP':
                    eatparam1.setAttribute('value', "5");
                    break;

            }

        }

        window.onload = function () {
            updateLabels();

            document.getElementById('algorithm').addEventListener('change', updateLabels);
            document.getElementById('eatDistribution').addEventListener('change', updateEatDistribution);
            document.getElementById('thinkDistribution').addEventListener('change', updateThinkDistribution);



            const scrollThreshold = 10;
            const floatingBox = document.getElementById('floatingBox');

            window.addEventListener('scroll', () => {
                if (window.scrollY > scrollThreshold) {
                    floatingBox.classList.add('hidebox');

                } else {
                    floatingBox.classList.remove('hidebox');
                }
            });

            playAnimation();
        };

    </script>

</head>
<body>

<div class="floating-box" id="floatingBox">
    <span style="color: red; font-size: 16px; font-weight: bold;">&#8595;</span> Scroll down for Animation notes.
</div>



<h2>Dining Philosophers Animation</h2>
<div class="container">

    <div class="svg-container">

        <svg id="dining-philosophers-animation" xmlns="http://www.w3.org/2000/svg" width="490px" height="445px"
             viewBox="-3 -3 490 445" preserveAspectRatio="xMidYMid meet" style="width: 100%; height: auto;">
            <rect fill="#f8f8f8" width="100%" height="100%" x="0" y="0"></rect>
            <!--Ellipses-->
            <ellipse id="philosopher0" cx="244.25" cy="392" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"></ellipse>
            <ellipse id="philosopher1" cx="423.5" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(120,423.5,282)"></ellipse>
            <ellipse id="philosopher2" cx="385" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(50,385,72)"></ellipse>
            <ellipse id="philosopher3" cx="105" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(-55,105,72)"></ellipse>
            <ellipse id="philosopher4" cx="65" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(60,65,282)"></ellipse>

            <ellipse cx="65" cy="282" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"></ellipse>
            <text x="65" y="300" font-size="13" font-family="Arial" text-anchor="middle" alignment-baseline="middle"
                  font-weight="bold">PH_4
            </text>

            <ellipse cx="105" cy="72" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"></ellipse>
            <text x="105" y="58" font-size="13" font-family="Arial" text-anchor="middle" alignment-baseline="middle"
                  font-weight="bold">PH_3
            </text>

            <ellipse cx="423.5" cy="282" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"></ellipse>
            <text x="423.5" y="300" font-size="13" font-family="Arial" text-anchor="middle" alignment-baseline="middle"
                  font-weight="bold">PH_1
            </text>

            <ellipse cx="244.25" cy="392" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"></ellipse>
            <text x="244.25" y="410" font-size="13" font-family="Arial" text-anchor="middle" alignment-baseline="middle"
                  font-weight="bold">PH_0
            </text>

            <ellipse cx="385" cy="72" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"></ellipse>
            <text x="385" y="58" font-size="13" font-family="Arial" text-anchor="middle" alignment-baseline="middle"
                  font-weight="bold">PH_2
            </text>

            <ellipse cx="244.25" cy="201.25" rx="139.25" ry="139.25" fill="#f5f5f5" stroke="#666666"></ellipse>


            <ellipse id="plate0" cx="244.25" cy="297" rx="35" ry="35" fill="#ffffff" stroke="#000000"></ellipse>
            <ellipse id="plate1" cx="339.25" cy="237" rx="35" ry="35" fill="#ffffff" stroke="#000000"></ellipse>
            <ellipse id="plate2" cx="308.5" cy="127" rx="35" ry="35" fill="#ffffff" stroke="#000000"></ellipse>
            <ellipse id="plate3" cx="180" cy="127" rx="35" ry="35" fill="#ffffff" stroke="#000000"></ellipse>
            <ellipse id="plate4" cx="149.25" cy="237" rx="35" ry="35" fill="#ffffff" stroke="#000000"></ellipse>

            <!--Triangles-->
            <path d="M 165 272 L 225 277 L 165 282 Z" fill="#89cff0" stroke="#000000" transform="rotate(-45,195,277)"></path>
            <path d="M 273.5 272 L 333.5 277 L 273.5 282 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(-126,303.5,277)"></path>
            <path d="M 124.25 172 L 184.25 177 L 124.25 182 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(15,154.25,177)"></path>
            <path d="M 213.5 112 L 273.5 117 L 213.5 122 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(90,243.5,117)"></path>
            <path d="M 304.25 172 L 364.25 177 L 304.25 182 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(-195,334.25,177)"></path>
            <!--Arrow Definitions-->
            <defs>
                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto">
                    <polygon points="0 0, 5 3.5, 0 7" fill="#000000"></polygon>
                </marker>
            </defs>
            <!--Arrows from ellipses to triangles-->
            <line id="left0" x1="244.25" y1="392" x2="190" y2="320" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>
            <line id="right0" x1="244.25" y1="392" x2="305" y2="320" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>

            <line id="left1" x1="423.5" y1="282" x2="345" y2="296" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>
            <line id="right1" x1="423.5" y1="282" x2="374" y2="192" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>

            <line id="left2" x1="385" y1="72" x2="366" y2="144" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>
            <line id="right2" x1="385" y1="72" x2="270" y2="85" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>

            <line id="left3" x1="105" y1="72" x2="219" y2="85" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>
            <line id="right3" x1="105" y1="72" x2="120" y2="143" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>

            <line id="left4" x1="65" y1="282" x2="115" y2="190" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>
            <line id="right4" x1="65" y1="282" x2="150" y2="295" stroke="#000000" stroke-width="5"
                  marker-end="url(#arrowhead)" class="hidden"></line>

            <!-- Text elements to show actions on each plate -->
            <text id="text0" x="244.25" y="297" text-anchor="middle" dominant-baseline="middle" font-size="18px"
                  font-weight="bold" fill="#000">[ T ]
            </text>
            <text id="text1" x="339.25" y="237" text-anchor="middle" dominant-baseline="middle" font-size="18px"
                  font-weight="bold" fill="#000">[ T ]
            </text>
            <text id="text2" x="308.5" y="127" text-anchor="middle" dominant-baseline="middle" font-size="18px"
                  font-weight="bold" fill="#000">[ T ]
            </text>
            <text id="text3" x="180" y="127" text-anchor="middle" dominant-baseline="middle" font-size="18px"
                  font-weight="bold" fill="#000">[ T ]
            </text>
            <text id="text4" x="149.25" y="237" text-anchor="middle" dominant-baseline="middle" font-size="18px"
                  font-weight="bold" fill="#000">[ T ]
            </text>

            <text id="time-display" x="245" y="20" text-anchor="middle" font-size="30px" fill="#000">Time: 0</text>
        </svg>
        <div class="button-container">
            <button id="backward-button">&#9194; Backward</button>
            <button id="forward-button">&#9193; Forward</button>
            <button id="play-button" class="hidden">&#9654; Play</button>
            <button id="pause-button">&#9208; Pause</button>
            <button id="restart-button">&#128260; Reset</button>
            <select id="speedSelect" onchange="updateInterval()">
                <option value="1000">Slow</option>
                <option value="1800">Very Slow</option>
                <option value="600">Fast</option>
                <option value="300">Very Fast</option>
                <option value="100">Lightspeed</option>
            </select>
        </div>

        <script>

            const inputString = `
            <%= request.getAttribute("animationresult") != null ? request.getAttribute("animationresult").toString().replace("\n", "\\n").replace("\r", "\\r") : "" %>
            `;
            const sequences = inputString.trim().split('\n').reduce((acc, line) => {

                const parts = line.match(/\[.*?\]/g);
                if (parts) {
                    const key = line.split(' ')[0];
                    acc[key] = parts.map(part => part.trim());
                }
                return acc;
            }, {});


            const philosophers = [
                {
                    id: "PH_0",
                    plate: document.getElementById("plate0"),
                    text: document.getElementById("text0"),
                    leftArrow: document.getElementById("left0"),
                    rightArrow: document.getElementById("right0")
                },
                {
                    id: "PH_1",
                    plate: document.getElementById("plate1"),
                    text: document.getElementById("text1"),
                    leftArrow: document.getElementById("left1"),
                    rightArrow: document.getElementById("right1")
                },
                {
                    id: "PH_2",
                    plate: document.getElementById("plate2"),
                    text: document.getElementById("text2"),
                    leftArrow: document.getElementById("left2"),
                    rightArrow: document.getElementById("right2")
                },
                {
                    id: "PH_3",
                    plate: document.getElementById("plate3"),
                    text: document.getElementById("text3"),
                    leftArrow: document.getElementById("left3"),
                    rightArrow: document.getElementById("right3")
                },
                {
                    id: "PH_4",
                    plate: document.getElementById("plate4"),
                    text: document.getElementById("text4"),
                    leftArrow: document.getElementById("left4"),
                    rightArrow: document.getElementById("right4")
                }
            ];


            const timeDisplay = document.getElementById("time-display");

            let timeStep = 0;
            const maxTimeStep = sequences.PH_0.length;
            let interval = null;
            const blinktimeout = 100;

            function updateState(philosopherIndex, action) {
                const philosopher = philosophers[philosopherIndex];
                const id = philosopher.id;

                switch (action) {

                    case "[ T ]":
                        philosopher.text.textContent = `[ T ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);

                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }


                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }

                        break;


                    case "[ E ]":
                        philosopher.text.textContent = `[ E ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.plate.classList.add("eat");
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }

                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden")
                        }
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden")
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;


                    case "[ B ]":
                        philosopher.text.textContent = `[ B ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.plate.classList.add("blocked");
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }

                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;

                    case"[BLR]":
                        philosopher.text.textContent = `[ B ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.plate.classList.add("blocked");
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden")
                        }
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;
                    case "[BL ]":
                        philosopher.text.textContent = `[ B ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.plate.classList.add("blocked");
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden")
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;
                    case "[BR ]":
                        philosopher.text.textContent = `[ B ]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.plate.classList.add("blocked");
                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;


                    case "[PUL]":
                        philosopher.text.textContent = `[PUL]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.leftArrow.classList.remove("hidden");
                        philosopher.leftArrow.classList.add("blink");

                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        break;


                    case "[PUR]":
                        philosopher.text.textContent = ` [PUR]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        philosopher.rightArrow.classList.remove("hidden");
                        philosopher.rightArrow.classList.add("blink");
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        break;


                    case "[PDL]":
                        philosopher.text.textContent = `[PDL]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden");
                        }
                        philosopher.leftArrow.classList.add("blink");
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden");
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        break;


                    case "[PDR]":
                        philosopher.text.textContent = `[PDR]`;
                        philosopher.text.classList.add("quick-blink");
                        philosopher.plate.classList.add("quick-blink");
                        setTimeout(() => {
                            philosopher.text.classList.remove('quick-blink');
                            philosopher.plate.classList.remove("quick-blink");
                        }, blinktimeout);
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden");
                        }
                        philosopher.rightArrow.classList.add("blink");
                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden");
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        break;

                    case "[   ]":
                        philosopher.text.textContent = ``;
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }

                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }

                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;
                    case "[LR ]":
                        philosopher.text.textContent = ``;
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden")
                        }
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;
                    case "[L  ]":
                        philosopher.text.textContent = ``;
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.remove("hidden")
                        }
                        if (!philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.add("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;
                    case "[R  ]":
                        philosopher.text.textContent = ``;
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (!philosopher.leftArrow.classList.contains("hidden")) {
                            philosopher.leftArrow.classList.add("hidden")
                        }
                        if (philosopher.rightArrow.classList.contains("hidden")) {
                            philosopher.rightArrow.classList.remove("hidden")
                        }
                        if (philosopher.plate.classList.contains("eat")) {
                            philosopher.plate.classList.remove("eat");
                        }
                        if (philosopher.plate.classList.contains("blocked")) {
                            philosopher.plate.classList.remove("blocked");
                        }
                        if (philosopher.leftArrow.classList.contains("blink")) {
                            philosopher.leftArrow.classList.remove("blink")
                        }
                        if (philosopher.rightArrow.classList.contains("blink")) {
                            philosopher.rightArrow.classList.remove("blink")
                        }
                        break;

                }
            }

            function renderTimeStep() {
                Object.keys(sequences).forEach((philosopher, index) => {
                    updateState(index, sequences[philosopher][timeStep]);
                });
                timeDisplay.textContent = "Time: " + (timeStep + 1);
            }

            let currentIntervalDuration = 1000;

            function playAnimation() {
                if (interval === null) {
                    interval = setInterval(() => {
                        if (timeStep < maxTimeStep - 1) {
                            document.getElementById("play-button").classList.add("hidden");
                            document.getElementById("pause-button").classList.remove("hidden");
                            timeStep++;
                            renderTimeStep();
                        } else {
                            document.getElementById("pause-button").classList.add("hidden");
                            document.getElementById("play-button").classList.remove("hidden");
                            clearInterval(interval);
                            interval = null;
                        }
                    }, currentIntervalDuration);
                }
            }

            function pauseAnimation() {
                if (interval !== null) {
                    clearInterval(interval);
                    interval = null;
                }
            }

            document.getElementById("forward-button").addEventListener("click", () => {
                if (timeStep < maxTimeStep - 1) {
                    document.getElementById("pause-button").classList.add("hidden");
                    document.getElementById("play-button").classList.remove("hidden");
                    pauseAnimation()
                    timeStep++;
                    renderTimeStep();
                }
            });

            document.getElementById("backward-button").addEventListener("click", () => {
                if (timeStep > 0) {
                    document.getElementById("pause-button").classList.add("hidden");
                    document.getElementById("play-button").classList.remove("hidden");
                    pauseAnimation()
                    timeStep--;
                    renderTimeStep();
                }
            });

            document.getElementById("pause-button").addEventListener("click", () => {
                document.getElementById("pause-button").classList.add("hidden");
                document.getElementById("play-button").classList.remove("hidden");
                pauseAnimation()
            });

            document.getElementById("play-button").addEventListener("click", () => {
                document.getElementById("play-button").classList.add("hidden");
                document.getElementById("pause-button").classList.remove("hidden");
                playAnimation()
            });

            document.getElementById("restart-button").addEventListener("click", () => {
                document.getElementById("pause-button").classList.add("hidden");
                document.getElementById("play-button").classList.remove("hidden");
                timeStep = 0;
                pauseAnimation()
                renderTimeStep()
            });

            function updateInterval() {
                const speedSelect = document.getElementById('speedSelect');
                currentIntervalDuration = parseInt(speedSelect.value);
                if (interval !== null) {
                    clearInterval(interval);
                    interval = null;
                    playAnimation();
                }
            }


            renderTimeStep();
        </script>


    </div>

    <div class="form-container">
        <h3>Dining Philosophers Simulation</h3>
        <form name="animationForm" action="${pageContext.request.contextPath}/animation" method="post">

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

                <optgroup label="Distributed">
                    <option value="CHANDYMISRA" <%= "CHANDYMISRA".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Chandy-Misra
                    </option>
                    <option value="CHANCE_RESTRICT_TOKEN" <%= "CHANCE_RESTRICT_TOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Restrict Token (Chance-based)
                    </option>
                    <option value="TIME_RESTRICT_TOKEN" <%= "TIME_RESTRICT_TOKEN".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Restrict Token (Time-based)
                    </option>
                </optgroup>

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
                        Eat Permission Waiter
                    </option>
                    <option value="PICKUPWAITER" <%= "PICKUPWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Pickup Permission Waiter
                    </option>
                    <option value="INTELLIGENTWAITER" <%= "INTELLIGENTWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Intelligent Waiter
                    </option>
                    <option value="FAIR_CHANCE_WAITER" <%= "FAIR_CHANCE_WAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Waiter (Chance-based)
                    </option>
                    <option value="FAIR_EATTIME_WAITER" <%= "FAIR_EATTIME_WAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Waiter (Time-based)
                    </option>
                    <option value="TWOWAITERS" <%= "TWOWAITERS".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Two Waiters
                    </option>
                    <option value="RESTRICTWAITER" <%= "RESTRICTWAITER".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Restrict Waiter
                    </option>
                </optgroup>

                <optgroup label="Semaphore">
                    <option value="TABLESEMAPHORE" <%= "TABLESEMAPHORE".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Table-Semaphore
                    </option>
                    <option value="RESTRICT" <%= "RESTRICT".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Restrict
                    </option>
                    <option value="TANENBAUM" <%= "TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Tanenbaum
                    </option>
                    <option value="FAIR_CHANCE_TANENBAUM" <%= "FAIR_CHANCE_TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Tanenbaum (Chance-based)
                    </option>
                    <option value="FAIR_TIME_TANENBAUM" <%= "FAIR_TIME_TANENBAUM".equals(request.getParameter("algorithm")) ? "selected" : "" %>>
                        Fair Tanenbaum (Time-based)
                    </option>

                </optgroup>
            </select>

            <br><br>

            <label for="simulationTime">Simulation Time Steps (100-500):</label>
            <input type="number" id="simulationTime" name="simulationTime" min="100" max="500"
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

            <label id=timeoutLabel for="timeout">Timeout (0-200):</label>
            <input type="number" id="timeout" name="timeout" min="0" max="500"
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
            <div class="soft-red-text"><p style="font-size: 13px; font-family: 'Courier New', Courier, monospace; ">To play back the animation, run the Dining Philosophers simulation first.</p></div>

        </form>

    </div>

</div>
<br>
<div class="container1">
    <div class="scrollable-box">
        <c:if test="${not empty result}">
            <pre>${result}</pre>
        </c:if>
    </div>
    <div class="floating-box_1" onclick="this.style.opacity = '0.3'; this.style.transition = 'opacity 0.3s';">
        <h4>Legend:</h4>
        [ T ] = Think  <br>
        [PUL] = Pick Up Left <br>
        [PUR] = Pick Up Right <br>
        [ E ] = Eat <br>
        [PDL] = Put Down Left <br>
        [PDR] = Put Down Right <br>
        [ B ] = Blocked <br>
    </div>
</div>

<br>



<h2>Animation Notes</h2>
<div class="description">
    <p>
        This Animation page lets you explore visual representations of the algorithms.
        Start by running a simulation, as each run is unique and depends on your chosen parameters and algorithms.
        You can play, pause, navigate backward, forward, or restart, and adjust playback speed in the drop-down menu.
        The animation follows Dijkstras classic 5-philosopher setup, displaying frame by frame, based on the timeline data.
        Use the scroll-box on the bottom to view the respective timelines.

    </p>
    <h3>Parameters</h3>
    <ul>

        <li><b>Number of philosophers: </b>On this page, only simulations with 5 philosophers can be simulated and animated.</li>

        <li><b>Execution Time: </b> The simulation utilizes a Discrete Time-Stepping Virtual Time.
            One time "unit" represents a loop iteration that is a step in the simulation timeline.
            We control the actual time passage via a short waiting period in each iteration to give the philosophers
            time to complete actions.
            Philosophers use this reference time to log their respective actions after completion.
            This results in a quantization effect where each completed act is mapped to a discrete virtual
            simulation-time point.
            Note that there is an actual simulation running in the background that utilizes Java Threads.
            Increasing the simulation time will prolong the execution time of the backend, due to the longer simulation
            duration and the following processing of the results.
            The maximum execution time is 1000, this will result in a waiting period of up to 20 seconds before results
            are visible.
        </li>

        <li><b>Distribution settings: </b> There are four distributions you can choose from.
            <ul>
                <li>Deterministic: Only has one parameter and is a static delay. For the naive implementation, this will
                    provoke deadlocks! (min: 30, max: 400)
                </li>
                <li>Interval: This distribution calculates a value between the given Lb = Lower Bound and Ub = Upper
                    Bound. (Lb min: 30, Lb max: 400), (Ub min: 30, Ub max: 400)
                </li>
                <li>Normal: Has parameters mu = &mu; = the mean, and sigma = &sigma; = the standard deviation.
                    This will simulate philosophers with normally distributed delays, according to the given parameters.
                    (&mu; min: 50, &mu; max: 250), (&sigma; min: 1, &sigma; max: 30)
                </li>
                <li>Exponential: Parameter lambda = &lambda; = rate parameter. Frequent low values, but sometimes large
                    outliers occur. Lower lambda means that higher values become more likely. (min: 3, max: 12)
                </li>

            </ul>
        </li>
        <li><b>Simulation Type: </b> Two types are available. The "Simulate Pickups"-mode lets you track the pick-ups and
            put-downs of the philosophers.
            Since simulating the pickups results in a slight overhead, there is also a "simple" mode, that is a little
            more performant and will return results quicker.
            The "simple" mode will only display thinking and eating.
        </li>

        <li><b>Timeout: </b> Values between 0 and 200 are possible. A timeout of 0 is equivalent to an instant timeout.
        </li>

    </ul>

    <img src="<%= request.getContextPath() %>/pictures/distribution.svg" alt="Dining Philosophers Problem" width="847" height="225">


    <h3>Statistics:</h3>
    <p>
        A simulation run will output detailed statistics, including the measures:
    </p>


    <uL>
        <li><b>Concurrency: </b> Total combined (simulated) eating time, divided by length of the timeline.
            Maximum
            concurrency is bounded at two for 5-philosophers.
            Results close to this value
            indicate good concurrency.
        </li>
        <li><b>Eat-chance fairness: </b> Standard deviation of all the philosophers eat chances (The times philosophers
            successfully picked up both chopsticks and ate)
        </li>
        <li><b>Eat-time fairness: </b> Standard deviation of the philosophers accumulated simulation time spent eating.
            (The number of blocks per timeline that indicate eating)
        </li>
    </uL>

    <p>
        For exponential and normal distributions, longer run times may help capture large outliers.
    </p>
</div>

</body>
</html>
