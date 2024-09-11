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
        .hidden {
            display: none;
        }
        .blocked {
            fill: #F08080; /* Color for blocked */
        }

        .eat {
            fill: #A8D5BA; /* Color for eating */
        }
    </style>
</head>
<body>
<svg id="dining-philosophers-animation" xmlns="http://www.w3.org/2000/svg" width="490px" height="434px" viewBox="-0.5 -0.5 490 434">
    <rect fill="#ffffff" width="100%" height="100%" x="0" y="0"/>
    <!--Ellipses-->
    <ellipse id="philosopher0" cx="244.25" cy="392" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656"/>
    <ellipse id="philosopher1" cx="423.5" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656" transform="rotate(120,423.5,282)"/>
    <ellipse id="philosopher2" cx="385" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656" transform="rotate(50,385,72)"/>
    <ellipse id="philosopher3" cx="105" cy="72" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656" transform="rotate(-55,105,72)"/>
    <ellipse id="philosopher4" cx="65" cy="282" rx="60" ry="40" fill="#fff2cc" stroke="#d6b656" transform="rotate(60,65,282)"/>

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
    <path d="M 273.5 272 L 333.5 277 L 273.5 282 Z" fill="#89cff0" stroke="#000000" transform="rotate(-126,303.5,277)"/>
    <path d="M 124.25 172 L 184.25 177 L 124.25 182 Z" fill="#89cff0" stroke="#000000" transform="rotate(15,154.25,177)"/>
    <path d="M 213.5 112 L 273.5 117 L 213.5 122 Z" fill="#89cff0" stroke="#000000" transform="rotate(90,243.5,117)"/>
    <path d="M 304.25 172 L 364.25 177 L 304.25 182 Z" fill="#89cff0" stroke="#000000" transform="rotate(-195,334.25,177)"/>
    <!--Arrow Definitions-->
    <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto">
            <polygon points="0 0, 5 3.5, 0 7" fill="#000000"/>
        </marker>
    </defs>
    <!--Arrows from ellipses to triangles-->
    <line id="left0" x1="244.25" y1="392" x2="190" y2="320" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>
    <line id="right0" x1="244.25" y1="392" x2="305" y2="320" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>

    <line id="left1" x1="423.5" y1="282" x2="345" y2="296" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>
    <line id="right1" x1="423.5" y1="282" x2="374" y2="192" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>

    <line id="left2" x1="385" y1="72" x2="366" y2="144" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>
    <line id="right2" x1="385" y1="72" x2="270" y2="85" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>

    <line id="left3" x1="105" y1="72" x2="219" y2="85" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>
    <line id="right3" x1="105" y1="72" x2="120" y2="143" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>

    <line id="left4" x1="65" y1="282" x2="115" y2="190" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>
    <line id="right4" x1="65" y1="282" x2="150" y2="295" stroke="#000000" stroke-width="5" marker-end="url(#arrowhead)" class="hidden"></line>

    <!-- Text elements to show actions on each plate -->
    <text id="text0" x="244.25" y="297" text-anchor="middle" dominant-baseline="middle" font-size="18px" font-weight="bold" fill="#000">[ T ]</text>
    <text id="text1" x="339.25" y="237" text-anchor="middle" dominant-baseline="middle" font-size="18px" font-weight="bold" fill="#000">[ T ]</text>
    <text id="text2" x="308.5" y="127" text-anchor="middle" dominant-baseline="middle" font-size="18px" font-weight="bold" fill="#000">[ T ]</text>
    <text id="text3" x="180" y="127" text-anchor="middle" dominant-baseline="middle" font-size="18px" font-weight="bold" fill="#000">[ T ]</text>
    <text id="text4" x="149.25" y="237" text-anchor="middle" dominant-baseline="middle" font-size="18px" font-weight="bold" fill="#000">[ T ]</text>

    <text id="time-display" x="245" y="20" text-anchor="middle" font-size="30px" fill="#000">Time: 0</text>
</svg>

<script>

    const inputString = `
PH_0 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][PUR][ E ][ E ][ E ][ E ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][PUL]
PH_1 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][PUR][ E ][ E ][ E ][ E ][ E ][ B ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][PUL][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ]
PH_2 [ T ][ T ][ T ][ T ][ T ][ B ][ B ][PUL][PUR][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][PUL][PUR][ E ][ E ][ E ][ B ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][ B ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ]
PH_3 [ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][PUL][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][PUR][ E ][ E ]
PH_4 [ T ][ T ][ T ][ T ][ T ][PUL][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][PDL][ B ][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][PUR][ E ][ E ][ E ][ E ][PDL][PDR][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ T ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][ B ][PUL][ B ][ B ][ B ][ B ][ B ][PUR][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ E ][ B ][PDL][PDR][ T ][ T ][ T ]
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

    console.log(sequenceses);

    // Define the action sequences fo
    // r each philosopher
    const sequences = {
        PH_0: ["[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[PUL]", "[PUR]", "[ E ]", "[ E ]", "[ E ]", "[ E ]", "[ E ]", "[ E ]"],
        PH_1: ["[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ B ]", "[ B ]", "[ B ]", "[ B ]"],
        PH_2: ["[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[PUL]"],
        PH_3: ["[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[PUL]", "[PUR]", "[ E ]", "[ E ]"],
        PH_4: ["[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]", "[ T ]"]
    };

    // Reference to text and arrow elements in the SVG
    const philosophers = [
        { id: "PH_0", plate: document.getElementById("plate0"), text: document.getElementById("text0"), leftArrow: document.getElementById("left0"), rightArrow: document.getElementById("right0") },
        { id: "PH_1", plate: document.getElementById("plate1"), text: document.getElementById("text1"), leftArrow: document.getElementById("left1"), rightArrow: document.getElementById("right1") },
        { id: "PH_2", plate: document.getElementById("plate2"), text: document.getElementById("text2"), leftArrow: document.getElementById("left2"), rightArrow: document.getElementById("right2") },
        { id: "PH_3", plate: document.getElementById("plate3"), text: document.getElementById("text3"), leftArrow: document.getElementById("left3"), rightArrow: document.getElementById("right3") },
        { id: "PH_4", plate: document.getElementById("plate4"), text: document.getElementById("text4"), leftArrow: document.getElementById("left4"), rightArrow: document.getElementById("right4") }
    ];

    // Reference to the time display element
    const timeDisplay = document.getElementById("time-display");

    // Update the state based on the current action
    function updateState(philosopherIndex, action) {
        const philosopher = philosophers[philosopherIndex];
        const id = philosopher.id;
        // Set the text on the philosopher's plate including the ID
        switch (action) {
            case "[ T ]":
                philosopher.text.textContent = `[ T ]`;
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }
                break;
            case "[ E ]":
                philosopher.text.textContent = `[ E ]`;
                philosopher.plate.classList.add("eat");
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }

                break;
            case "[ B ]":
                philosopher.text.textContent = `[ B ]`;
                philosopher.plate.classList.add("blocked");
                if (philosopher.plate.classList.contains("eat")) {
                    philosopher.plate.classList.remove("eat");
                }
                break;
            case "[PUL]":
                philosopher.text.textContent = `[PUL]`;
                philosopher.leftArrow.classList.remove("hidden");
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }
                break;
            case "[PUR]":
                philosopher.text.textContent = ` [PUR]`;
                philosopher.rightArrow.classList.remove("hidden");
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }
                break;
            case "[PDL]":
                philosopher.text.textContent = `[PDL]`;
                philosopher.leftArrow.classList.add("hidden");
                if (philosopher.plate.classList.contains("eat")) {
                    philosopher.plate.classList.remove("eat");
                }
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }
                break;
            case "[PDR]":
                philosopher.text.textContent = `[PDR]`;
                philosopher.rightArrow.classList.add("hidden");
                if (philosopher.plate.classList.contains("eat")) {
                    philosopher.plate.classList.remove("eat");
                }
                if (philosopher.plate.classList.contains("blocked")) {
                    philosopher.plate.classList.remove("blocked");
                }
                break;
        }
    }

    // Animate the philosophers based on the sequence
    function animatePhilosophers() {
        let timeStep = 0;

        const firstKey = Object.keys(sequenceses)[0];
        const firstArray = sequenceses[firstKey];
        const lengthOfFirstArray = firstArray.length;

        const interval = setInterval(() => {
            if (timeStep >= lengthOfFirstArray) {
                clearInterval(interval); // Stop animation when sequences end
                return;
            }

            // Update each philosopher's state at the current time step
            Object.keys(sequenceses).forEach((philosopher, index) => {
                updateState(index, sequenceses[philosopher][timeStep]);
            });

            // Update the time display
            timeDisplay.textContent = "Time: " + String(timeStep + 1);

            timeStep++;
        }, 100); // Change the step time as needed
    }

    // Start the animation
    animatePhilosophers();
</script>


</body>
</html>
