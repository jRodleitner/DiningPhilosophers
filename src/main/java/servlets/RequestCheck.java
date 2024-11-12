package servlets;

import algorithms.Distribution;
import simulation.Algorithm;

public class RequestCheck {
    private static final int MIN_PHILOSOPHERS = 2;
    private static final int MAX_PHILOSOPHERS = 9;
    private static final int TIME_MIN = 100;
    private static final int TIME_MAX = 1000;
    private static final int TIMEOUT_MIN = 0;
    private static final int TIMEOUT_MAX = 200;
    private static final int DET_MIN = 30;
    private static final int DET_MAX = 400;
    private static final int INTERVAL_MIN = 30;
    private static final int INTERVAL_MAX = 400;
    private static final int MIN_MU_NORM = 50;
    private static final int MAX_MU_NORM = 400;
    private static final int MIN_SIGMA_NORM = 1;
    private static final int MAX_SIGMA_NORM = 30;
    private static final int MIN_EXP = 3;
    private static final int MAX_EXP = 12;
    private static final int MAX_ANIMATION_TIME = 500;

    public static boolean checkSimulationRequestValidity(int nrPhil, int simulationTime, String algorithm, String eatDistribution, double eatPar1, double eatPar2, String thinkDistribution, double thinkPar1, double thinkPar2, int timeout) {
        return checkPhilosopherCount(nrPhil, MIN_PHILOSOPHERS, MAX_PHILOSOPHERS) &&
                checkSimulationTimeBounds(simulationTime, TIME_MIN, TIME_MAX) &&
                isValidAlgorithm(algorithm) &&
                checkTimeout(timeout) &&
                checkDistribution(eatDistribution, eatPar1, eatPar2) &&
                checkDistribution(thinkDistribution, thinkPar1, thinkPar2);
    }

    public static boolean checkAnimationRequestValidity( int simulationTime, String algorithm, String eatDistribution, double eatPar1, double eatPar2, String thinkDistribution, double thinkPar1, double thinkPar2, int timeout) {
        return checkSimulationTimeBounds(simulationTime, TIME_MIN, MAX_ANIMATION_TIME) &&
                isValidAlgorithm(algorithm) &&
                checkTimeout(timeout) &&
                checkDistribution(eatDistribution, eatPar1, eatPar2) &&
                checkDistribution(thinkDistribution, thinkPar1, thinkPar2);
    }

    private static boolean checkPhilosopherCount(int count, int min, int max) {
        return count >= min && count <= max;
    }

    private static boolean checkSimulationTimeBounds(int time, int min, int max) {
        return time >= min && time <= max;
    }

    private static boolean isValidAlgorithm(String algorithm) {
        return algorithm != null && Algorithm.ALL_ALGORITHMS.contains(algorithm);
    }

    private static boolean checkTimeout(int timeout) {
        return timeout >= TIMEOUT_MIN && timeout <= TIMEOUT_MAX;
    }

    private static boolean checkDistribution(String distribution, double param1, double param2) {
        switch (distribution) {
            case Distribution.DETERMINISTIC:
                return param1 >= DET_MIN && param1 <= DET_MAX;
            case Distribution.NORMAL:
                return param1 >= MIN_MU_NORM && param1 <= MAX_MU_NORM && param2 >= MIN_SIGMA_NORM && param2 <= MAX_SIGMA_NORM;
            case Distribution.EXP:
                return param1 >= MIN_EXP && param1 <= MAX_EXP;
            case Distribution.INTERVAL:
                return param1 >= INTERVAL_MIN && param1 <= INTERVAL_MAX && param2 >= INTERVAL_MIN && param2 <= INTERVAL_MAX && param2 >= param1;
            default:
                return false;
        }
    }
}

