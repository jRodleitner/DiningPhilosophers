<%--
  Created by IntelliJ IDEA.
  User: jonar
  Date: 12.09.2024
  Time: 00:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dining Philosophers Animation</title>
    <style>
        .container {
            height: 500px;
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

        .svg-container {
            display: flex;
            flex-direction: column; /* Stack the SVG and buttons vertically */
            align-items: center; /* Center the content horizontally */
            background-color: #FFFF;
            border-radius: 10px;
            padding: 20px;
            gap: 10px; /* Adds space between the SVG and the buttons */
        }

        .button-container {
            display: flex;
            gap: 10px; /* Adds space between the buttons */
        }

        .hidden {
            display: none;
        }

        .blocked {
            fill: #F08080; /* Color for blocked */
        }

        .eat {
            fill: #A8D5BA; /* Color for eating */
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
            animation: blink 0.5s infinite; /* Blink every 0.5 seconds */
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
            animation: quick-blink 0.1s; /* Blink for 0.3 seconds */
            display: inline-block; /* Ensure the transform applies correctly without affecting layout */
            transform-origin: center;
        }

        .form-container {
            max-width: 700px; /* Adjust based on your form's size */
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #f0f0f0;
            border-radius: 10px;
        }

        .scrollable-box {
            width: 400px;
            height: 465px;
            border: 1px solid #ccc;
            padding: 20px;
            overflow-y: scroll;
            overflow-x: scroll;
            background-color: #FFFF;
            font-family: "Courier New", Courier, monospace;
            font-size: 12px;

            border-radius: 10px;
        }

    </style>
</head>
<body>
<h2>Animation Page</h2>
<div class="container">
    <div class="svg-container">


        <svg id="dining-philosophers-animation" xmlns="http://www.w3.org/2000/svg" width="490px" height="438px"
             viewBox="-0.5 -0.5 490 434">
            <rect fill="#ffffff" width="100%" height="100%" x="0" y="0"/>
            <!--Ellipses-->
            <ellipse id="philosopher0" cx="244.25" cy="392" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"/>
            <ellipse id="philosopher1" cx="423.5" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(120,423.5,282)"/>
            <ellipse id="philosopher2" cx="385" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(50,385,72)"/>
            <ellipse id="philosopher3" cx="105" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(-55,105,72)"/>
            <ellipse id="philosopher4" cx="65" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"
                     transform="rotate(60,65,282)"/>

            <ellipse cx="65" cy="282" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"/>
            <ellipse cx="105" cy="72" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"/>
            <ellipse cx="423.5" cy="282" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"/>
            <ellipse cx="244.25" cy="392" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"/>
            <ellipse cx="385" cy="72" rx="30" ry="30" fill="#f5f5f5" stroke="#666666"/>

            <ellipse cx="244.25" cy="201.25" rx="139.25" ry="139.25" fill="#f5f5f5" stroke="#666666"/>


            <ellipse id="plate0" cx="244.25" cy="297" rx="35" ry="35" fill="#ffffff" stroke="#000000"/>
            <ellipse id="plate1" cx="339.25" cy="237" rx="35" ry="35" fill="#ffffff" stroke="#000000"/>
            <ellipse id="plate2" cx="308.5" cy="127" rx="35" ry="35" fill="#ffffff" stroke="#000000"/>
            <ellipse id="plate3" cx="180" cy="127" rx="35" ry="35" fill="#ffffff" stroke="#000000"/>
            <ellipse id="plate4" cx="149.25" cy="237" rx="35" ry="35" fill="#ffffff" stroke="#000000"/>

            <!--Triangles-->
            <path d="M 165 272 L 225 277 L 165 282 Z" fill="#89cff0" stroke="#000000" transform="rotate(-45,195,277)"/>
            <path d="M 273.5 272 L 333.5 277 L 273.5 282 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(-126,303.5,277)"/>
            <path d="M 124.25 172 L 184.25 177 L 124.25 182 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(15,154.25,177)"/>
            <path d="M 213.5 112 L 273.5 117 L 213.5 122 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(90,243.5,117)"/>
            <path d="M 304.25 172 L 364.25 177 L 304.25 182 Z" fill="#89cff0" stroke="#000000"
                  transform="rotate(-195,334.25,177)"/>
            <!--Arrow Definitions-->
            <defs>
                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto">
                    <polygon points="0 0, 5 3.5, 0 7" fill="#000000"/>
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
            <button id="backward-button">&#9194;Backward</button>
            <button id="forward-button">&#9193;Forward</button>
            <button id="play-button">&#9654;Play</button>
            <button id="pause-button" class="hidden">&#9208;Pause</button>
            <button id="restart-button">&#128260;Reset</button>
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
            <%= request.getAttribute("result") != null ? request.getAttribute("result").toString().replace("\n", "\\n").replace("\r", "\\r") : "" %>
            `;
            // Convert input string into JavaScript object with arrays of arrays
            const sequenceses = inputString.trim().split('\n').reduce((acc, line) => {
                // Extract key and bracketed values
                const parts = line.match(/\[.*?\]/g);
                if (parts) {
                    // Get the key (first part before the first bracket)
                    const key = line.split(' ')[0];
                    acc[key] = parts.map(part => part.trim()); // Clean up any extra whitespace
                }
                return acc;
            }, {});


            // Reference to text and arrow elements in the SVG
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

            // Reference to the time display element
            const timeDisplay = document.getElementById("time-display");

            let timeStep = 0;
            const maxTimeStep = sequenceses.PH_0.length; // Assuming all philosophers have the same length of sequence
            let interval = null;
            const blinktimeout = 100;

            // Update the state based on the current action
            function updateState(philosopherIndex, action) {
                const philosopher = philosophers[philosopherIndex];
                const id = philosopher.id;
                // Set the text on the philosopher's plate including the ID
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

                        /* additionals */
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

                        /*additionals*/
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
                Object.keys(sequenceses).forEach((philosopher, index) => {
                    updateState(index, sequenceses[philosopher][timeStep]);
                });
                timeDisplay.textContent = "Time: " + (timeStep + 1);
            }

            let currentIntervalDuration = 1000;

            function playAnimation() {
                if (interval === null) {
                    interval = setInterval(() => {
                        if (timeStep < maxTimeStep - 1) {
                            timeStep++;
                            renderTimeStep();
                        } else {
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
                    timeStep++;
                    renderTimeStep();
                }
            });

            document.getElementById("backward-button").addEventListener("click", () => {
                if (timeStep > 0) {
                    timeStep--;
                    renderTimeStep();
                }
            });

            document.getElementById("play-button").addEventListener("click", () => {
                document.getElementById("play-button").classList.add("hidden");
                document.getElementById("pause-button").classList.remove("hidden");
                playAnimation();
            });

            document.getElementById("pause-button").addEventListener("click", () => {
                document.getElementById("pause-button").classList.add("hidden");
                document.getElementById("play-button").classList.remove("hidden");
                pauseAnimation();
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
                    playAnimation(); // Restart with the new interval
                }
            }

            // Initial render
            renderTimeStep();
        </script>

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
    </div>
    <div class="form-container">
        <form name="animationForm" action="/animation" method="post">

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
            <input type="submit" value="Run Simulation" style="font-size: 16px; padding: 10px 20px;">
        </form>

    </div>
    <div class="scrollable-box">
        <c:if test="${not empty result}">
            <pre>${result}</pre>
        </c:if>
    </div>
</div>

</body>
</html>
