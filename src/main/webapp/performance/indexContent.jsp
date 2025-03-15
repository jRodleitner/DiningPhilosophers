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

        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<h2>Performance Tests</h2>
<div class="description">

    <p>
        This page contains the results of performance tests on all the presented approaches, and how to interpret them.
        For each algorithm multiple simulation runs are averaged to come up with individual scores.
        This is also done for each of the four distributions, since algorithm performance is very different depending on which distribution is used.

    </p>

    <h3>Degree of concurrency</h3>

    <p>
        The concurrency score (CS) is calculated by averaging several simulation runs, in this case 20.
        For simulation runs with 5 philosophers, scores close to two indicate ideal concurrency, while those under one indicate no concurrency.
        Since concurrent performance also depends heavily on the chosen distribution, the concurrency scores from the different distributions are averaged.
        Four classes are used to classify algorithms according to this Average Concurrency Score:
    </p>
    <table>
        <tr>
            <th>Average Concurrency Score (Average CS)</th>
            <th>Ranges</th>
        </tr>
        <tr><td>No Concurrency</td><td>0 - 1.0</td></tr>
        <tr><td></td><td></td></tr>
        <tr><td>Moderate Concurrency</td><td>1.0 - 1.5</td></tr>
        <tr><td></td><td></td></tr>
        <tr><td>Good Concurrency</td><td>1.5 - 1.7</td></tr>
        <tr><td></td><td></td></tr>
        <tr><td>High Concurrency</td><td>1.7 - 2.0</td></tr>
        <tr><td></td><td></td></tr>
    </table>

    <h3>Fairness </h3>
    <p>
        The two scores for eat-chance fairness, and eat-time fairness are again obtained by averaging several simulation runs.
    </p>
    <table>
        <tr>
            <th>FS</th>
            <th>Fairness Score</th>
        </tr>

        <tr><td>ECFS</td><td>Eat Chance Fairness Score</td></tr>
        <tr><td></td><td></td></tr>
        <tr><td>ETFS</td><td>Eat Time Fairness Score</td></tr>
        <tr><td></td><td></td></tr>

    </table>

    <p>
        As both metrics are standard deviations of philosophers eat-chances or eat-times lower values indicate better fairness.
        Algorithm improvements are calculated in percentage decrease of standard deviation compared to the base versions of fairness enhancing algorithms.
        Fair Waiter is compared to Pickup Permission Waiter, Fair Tanenbaum is compared to Tanenbaum, The Circulating Token, and Restrict Token algorithms are compared to the Naive approach.
        Improvements above 20% can be interpreted as being significant.
    </p>


    <h3>Test Results</h3>

    <table>
        <tr>
            <th colspan="5">Interval Distribution: Lower Bound = 30 ms, Upper Bound = 300 ms</th>
        </tr>
        <tr>
            <th colspan="5">Runs per algorithm: 20</th>
        </tr>
        <tr>
            <th colspan="5">Simulation time: 2000 time steps</th>
        </tr>
        <tr>
            <th colspan="5">Number of Philosophers: 5</th>
        </tr>
        <tr>
            <th>Algorithm</th>
            <th>CS</th>
            <th>ECFS</th>
            <th>ETFS</th>
            <th>FS Improvement</th>
        </tr>
        <tr><td>Naive</td><td>1.3259</td><td>0.8841</td><td>49.9816</td><td></td></tr>
        <tr><td>Hierarchy</td><td>1.7062</td><td>2.0007</td><td>74.0217</td><td></td></tr>
        <tr><td>Asymmetric</td><td>1.7398</td><td>1.9537</td><td>70.3715</td><td></td></tr>
        <tr><td>Global Token</td><td>0.9819</td><td>0.3715</td><td>40.3125</td><td>57.98% ECFS</td></tr>
        <tr><td>Multiple Token</td><td>1.6660</td><td>0.3966</td><td>53.2681</td><td>55.14% ECFS</td></tr>
        <tr><td>Timeout (200 ms)</td><td>1.7097</td><td>1.3554</td><td>57.9897</td><td></td></tr>
        <tr><td>Instant Timeout</td><td>1.7480</td><td>1.3620</td><td>55.2102</td><td></td></tr>
        <tr><td>Eat Permission Waiter</td><td>0.9896</td><td>0.5657</td><td>43.3324</td><td></td></tr>
        <tr><td>Pickup Permission Waiter</td><td>1.4371</td><td>0.9212</td><td>47.2592</td><td></td></tr>
        <tr><td>Intelligent Waiter</td><td>1.5580</td><td>1.0574</td><td>42.1599</td><td></td></tr>
        <tr><td>Fair Eat-Time Waiter</td><td>1.4808</td><td>1.2977</td><td>22.9090</td><td>51.53% ETFS</td></tr>
        <tr><td>Fair Eat-Chance Waiter</td><td>1.4737</td><td>0.3831</td><td>47.3039</td><td>58.42% ECFS</td></tr>
        <tr><td>Two Waiters</td><td>1.6421</td><td>1.6271</td><td>70.4407</td><td></td></tr>
        <tr><td>Restrict Waiter</td><td>1.4541</td><td>0.8325</td><td>51.4794</td><td></td></tr>
        <tr><td>Table Semaphore</td><td>1.4232</td><td>0.7400</td><td>52.9547</td><td></td></tr>
        <tr><td>Restrict</td><td>1.3584</td><td>0.8677</td><td>45.6994</td><td></td></tr>
        <tr><td>Tanenbaum</td><td>1.8070</td><td>1.3966</td><td>57.9705</td><td></td></tr>
        <tr><td>Fair Eat-Time Tanenbaum</td><td>1.8179</td><td>1.3611</td><td>58.6103</td><td></td></tr>
        <tr><td>Fair Eat-Chance Tanenbaum</td><td>1.8040</td><td>1.3168</td><td>54.5071</td><td>5.71% ECFS</td></tr>
        <tr><td>Chandy-Misra</td><td>1.6890</td><td>0.9507</td><td>51.7728</td><td></td></tr>
        <tr><td>Eat-Chance Restrict Token</td><td>1.5982</td><td>0.4425</td><td>62.5900</td><td>50% ECFS</td></tr>
        <tr><td>Eat-Time Restrict Token</td><td>1.6509</td><td>1.6404</td><td>28.7441</td><td>42.5% ETFS</td></tr>
    </table>


    <p> </p>


    <table>
        <tr>
            <th colspan="5">Deterministic Distribution: delay = 100 ms</th>
        </tr>
        <tr>
            <th colspan="5">Runs per algorithm: 20</th>
        </tr>
        <tr>
            <th colspan="5">Simulation time: 2000 time steps</th>
        </tr>
        <tr>
            <th colspan="5">Number of Philosophers: 5</th>
        </tr>
        <tr>
            <th>Algorithm</th>
            <th>CS</th>
            <th>ECFS</th>
            <th>ETFS</th>
            <th>FS Improvement</th>
        </tr>
        <tr><td>Naive</td><td>1.1326</td><td>0.02</td><td>2.448</td><td></td></tr>
        <tr><td>Hierarchy</td><td>1.9647</td><td>0.9892</td><td>18.255</td><td></td></tr>
        <tr><td>Asymmetric</td><td>1.9665</td><td>1.2643</td><td>23.046</td><td></td></tr>
        <tr><td>Global Token</td><td>0.9847</td><td>0.0000</td><td>2.026</td><td>100% ECFS</td></tr>
        <tr><td>Multiple Token</td><td>1.9673</td><td>0.1580</td><td>4.668</td><td></td></tr>
        <tr><td>Timeout</td><td>1.9556</td><td>0.2605</td><td>6.093</td><td></td></tr>
        <tr><td>Instant Timeout</td><td>1.8162</td><td>0.7595</td><td>13.929</td><td></td></tr>
        <tr><td>Eat Permission Waiter</td><td>0.9841</td><td>0.0000</td><td>2.324</td><td></td></tr>
        <tr><td>Pickup Permission Waiter</td><td>1.7022</td><td>0.3863</td><td>7.854</td><td></td></tr>
        <tr><td>Intelligent Waiter</td><td>1.9097</td><td>0.3876</td><td>7.688</td><td></td></tr>
        <tr><td>Fair Eat-Time Waiter</td><td>1.6065</td><td>0.3515</td><td>6.849</td><td>12.8% ETFS</td></tr>
        <tr><td>Fair Eat-Chance Waiter</td><td>1.6768</td><td>0.3521</td><td>6.749</td><td>8.85% ECFS</td></tr>
        <tr><td>Two Waiters</td><td>1.8787</td><td>3.7277</td><td>67.677</td><td></td></tr>
        <tr><td>Restrict Waiter</td><td>1.7378</td><td>0.5759</td><td>11.406</td><td></td></tr>
        <tr><td>Table Semaphore</td><td>1.6365</td><td>0.4405</td><td>7.834</td><td></td></tr>
        <tr><td>Restrict</td><td>1.4751</td><td>0.0445</td><td>3.309</td><td></td></tr>
        <tr><td>Tanenbaum</td><td>1.9667</td><td>1.0002</td><td>18.288</td><td></td></tr>
        <tr><td>Fair Eat-Time Tanenbaum</td><td>1.9664</td><td>1.0896</td><td>19.660</td><td></td></tr>
        <tr><td>Fair Eat-Chance Tanenbaum</td><td>1.9671</td><td>1.3587</td><td>24.507</td><td></td></tr>
        <tr><td>Chandy-Misra</td><td>1.9150</td><td>0.3490</td><td>5.045</td><td></td></tr>
        <tr><td>Eat-Chance Restrict Token</td><td>1.9282</td><td>0.3592</td><td>7.490</td><td></td></tr>
        <tr><td>Eat-Time Restrict Token</td><td>1.9402</td><td>0.4049</td><td>8.179</td><td></td></tr>
    </table>


    <p>

    </p>

    <table>
        <tr>
            <th colspan="5">Normal Distribution: μ = 100, σ = 50</th>
        </tr>
        <tr>
            <th colspan="5">Runs per algorithm: 20</th>
        </tr>
        <tr>
            <th colspan="5">Simulation time: 2000 time steps</th>
        </tr>
        <tr>
            <th colspan="5">Number of Philosophers: 5</th>
        </tr>
        <tr>
            <th>Algorithm</th>
            <th>CS</th>
            <th>ECFS</th>
            <th>ETFS</th>
            <th>FS Improvement</th>
        </tr>
        <tr><td>Naive</td><td>1.3076</td><td>1.0550</td><td>34.4418</td><td></td></tr>
        <tr><td>Hierarchy</td><td>1.7193</td><td>3.1025</td><td>63.2627</td><td></td></tr>
        <tr><td>Asymmetric</td><td>1.7295</td><td>3.6586</td><td>50.0086</td><td></td></tr>
        <tr><td>Global Token</td><td>0.9792</td><td>0.2870</td><td>28.6236</td><td>72.8% ECFS</td></tr>
        <tr><td>Multiple Token</td><td>1.6713</td><td>0.4425</td><td>44.8131</td><td>58.08% ECFS</td></tr>
        <tr><td>Timeout(200 ms)</td><td>1.5960</td><td>1.8319</td><td>38.2872</td><td></td></tr>
        <tr><td>Instant Timeout</td><td>1.6739</td><td>2.3361</td><td>35.7533</td><td></td></tr>
        <tr><td>Eat Permission Waiter</td><td>0.9893</td><td>0.5588</td><td>31.0267</td><td></td></tr>
        <tr><td>Pickup Permission Waiter</td><td>1.4610</td><td>0.9458</td><td>38.3785</td><td></td></tr>
        <tr><td>Intelligent Waiter</td><td>1.5923</td><td>1.0981</td><td>38.2553</td><td></td></tr>
        <tr><td>Fair Eat-Time Waiter</td><td>1.4857</td><td>1.7760</td><td>15.1961</td><td>60.4% ETFS</td></tr>
        <tr><td>Fair Eat-Chance Waiter</td><td>1.4652</td><td>0.5399</td><td>37.7595</td><td>42.92% ECFS</td></tr>
        <tr><td>Two Waiters</td><td>1.6478</td><td>2.5900</td><td>60.8600</td><td></td></tr>
        <tr><td>Restrict Waiter</td><td>1.4468</td><td>1.0093</td><td>39.5061</td><td></td></tr>
        <tr><td>Table Semaphore</td><td>1.4884</td><td>1.1110</td><td>39.2123</td><td></td></tr>
        <tr><td>Restrict</td><td>1.2140</td><td>1.2382</td><td>29.7509</td><td></td></tr>
        <tr><td>Tanenbaum</td><td>1.8190</td><td>1.7965</td><td>44.6516</td><td></td></tr>
        <tr><td>Fair Eat-Time Tanenbaum</td><td>1.8078</td><td>1.8818</td><td>41.0264</td><td>8.12% ETFS</td></tr>
        <tr><td>Fair Eat-Chance Tanenbaum</td><td>1.8163</td><td>1.6008</td><td>46.6639</td><td>10.89% ECFS</td></tr>
        <tr><td>Chandy-Misra</td><td>1.4666</td><td>2.0112</td><td>22.1077</td><td></td></tr>
        <tr><td>Eat-Chance Restrict Token</td><td>1.5573</td><td>0.4445</td><td>24.3643</td><td>57.87% ECFS</td></tr>
        <tr><td>Eat-Time Restrict Token</td><td>1.6537</td><td>2.1990</td><td>21.4949</td><td>37.59% ETFS</td></tr>
    </table>

    <p> </p>

    <table>
        <tr>
            <th colspan="5">Exponential Distribution: λ = 5</th>
        </tr>
        <tr>
            <th colspan="5">Runs per algorithm: 20</th>
        </tr>
        <tr>
            <th colspan="5">Simulation time: 2000 time steps</th>
        </tr>
        <tr>
            <th colspan="5">Number of Philosophers: 5</th>
        </tr>
        <tr>
            <th>Algorithm</th>
            <th>CS</th>
            <th>ECFS</th>
            <th>ETFS</th>
            <th>FS Improvement</th>
        </tr>
        <tr><td>Naive</td><td>1.2601</td><td>1.1093</td><td>78.9417</td><td></td></tr>
        <tr><td>Hierarchy</td><td>1.5417</td><td>2.5310</td><td>99.9440</td><td></td></tr>
        <tr><td>Asymmetric</td><td>1.6314</td><td>2.7123</td><td>86.6127</td><td></td></tr>
        <tr><td>Global Token</td><td>0.9693</td><td>0.3115</td><td>67.2010</td><td>71.92% ECFS</td></tr>
        <tr><td>Multiple Token</td><td>1.4187</td><td>0.3386</td><td>96.9850</td><td>69.48% ECFS</td></tr>
        <tr><td>Timeout(200 ms)</td><td>1.5938</td><td>1.8307</td><td>81.4835</td><td></td></tr>
        <tr><td>Instant Timeout</td><td>1.6732</td><td>2.1489</td><td>88.6110</td><td></td></tr>
        <tr><td>Eat Permission Waiter</td><td>0.9912</td><td>0.9338</td><td>74.7230</td><td></td></tr>
        <tr><td>Pickup Permission Waiter</td><td>1.3412</td><td>1.2805</td><td>72.0612</td><td></td></tr>
        <tr><td>Intelligent Waiter</td><td>1.4401</td><td>1.3214</td><td>75.8088</td><td></td></tr>
        <tr><td>Fair Eat-Time Waiter</td><td>1.3444</td><td>1.6717</td><td>37.5872</td><td>47.84% ETFS</td></tr>
        <tr><td>Fair Eat-Chance Waiter</td><td>1.3832</td><td>0.5494</td><td>84.6811</td><td>57.09% ECFS</td></tr>
        <tr><td>Two Waiters</td><td>1.5052</td><td>1.7907</td><td>95.0338</td><td></td></tr>
        <tr><td>Restrict Waiter</td><td>1.3771</td><td>1.3168</td><td>77.0305</td><td></td></tr>
        <tr><td>Table Semaphore</td><td>1.3541</td><td>1.1065</td><td>85.5687</td><td></td></tr>
        <tr><td>Restrict</td><td>1.3380</td><td>1.3526</td><td>64.0767</td><td></td></tr>
        <tr><td>Tanenbaum</td><td>1.7342</td><td>2.0393</td><td>62.3498</td><td></td></tr>
        <tr><td>Fair Time Tanenbaum</td><td>1.7247</td><td>2.2296</td><td>81.7054</td><td></td></tr>
        <tr><td>Fair Chance Tanenbaum</td><td>1.7160</td><td>1.8871</td><td>76.2188</td><td>7.46% ECFS</td></tr>
        <tr><td>Chandy-Misra</td><td>1.5739</td><td>1.1275</td><td>74.7704</td><td></td></tr>
        <tr><td>Eat-Chance Restrict Token</td><td>1.4768</td><td>0.7649</td><td>90.1537</td><td>31.05% ECFS</td></tr>
        <tr><td>Eat-Time Restrict Token</td><td>1.4947</td><td>1.8447</td><td>44.6132</td><td>43.49% ETFS</td></tr>
    </table>

    <p>

    </p>

    <table>
        <tr>
            <th>Algorithm</th>
            <th>Average CS</th>
            <th>Subcategory</th>
        </tr>
        <tr><td>Naive</td><td>1.25655</td><td>Moderate Concurrency</td></tr>
        <tr><td>Hierarchy</td><td>1.732975</td><td>High Concurrency</td></tr>
        <tr><td>Asymmetric</td><td>1.7668</td><td>High Concurrency</td></tr>
        <tr><td>Global Token</td><td>0.978775</td><td>No Concurrency</td></tr>
        <tr><td>Multiple Token</td><td>1.680825</td><td>Good Concurrency</td></tr>
        <tr><td>Timeout(200 ms)</td><td>1.713775</td><td>High Concurrency</td></tr>
        <tr><td>Instant Timeout</td><td>1.727825</td><td>High Concurrency</td></tr>
        <tr><td>Eat Permission Waiter</td><td>0.98855</td><td>No Concurrency</td></tr>
        <tr><td>Pickup Permission Waiter</td><td>1.485375</td><td>Moderate Concurrency</td></tr>
        <tr><td>Intelligent Waiter</td><td>1.625025</td><td>Good Concurrency</td></tr>
        <tr><td>Fair Eat-Time Waiter</td><td>1.47935</td><td>Moderate Concurrency</td></tr>
        <tr><td>Fair Eat-Chance Waiter</td><td>1.499725</td><td>Moderate Concurrency</td></tr>
        <tr><td>Two Waiters</td><td>1.66845</td><td>Good Concurrency</td></tr>
        <tr><td>Restrict Waiter</td><td>1.50395</td><td>Good Concurrency</td></tr>
        <tr><td>Table Semaphore</td><td>1.47555</td><td>Moderate Concurrency</td></tr>
        <tr><td>Restrict</td><td>1.346375</td><td>Moderate Concurrency</td></tr>
        <tr><td>Tanenbaum</td><td>1.831725</td><td>High Concurrency</td></tr>
        <tr><td>Fair Eat-Time Tanenbaum</td><td>1.8292</td><td>High Concurrency</td></tr>
        <tr><td>Fair Eat-Chance Tanenbaum</td><td>1.82585</td><td>High Concurrency</td></tr>
        <tr><td>Chandy-Misra</td><td>1.661125</td><td>Good Concurrency</td></tr>
        <tr><td>Eat-Chance Restrict Token</td><td>1.640125</td><td>Good Concurrency</td></tr>
        <tr><td>Eat-Time Restrict Token</td><td>1.684875</td><td>Good Concurrency</td></tr>
    </table>


</div>
</body>
</html>
