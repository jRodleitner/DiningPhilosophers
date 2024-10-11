package simulation;

import algorithms.Distribution;
import parser.Animation;
import parser.Parser;

import java.util.ArrayList;
import java.util.List;

public class Execute {

    public static List<String> execute(int nrPhil, int simulationTime, String algorithm, boolean simulatePickups, String eatDistribution, double eatPar1, double eatPar2, String thinkDistribution, double thinkPar1, double thinkPar2, int timeout, boolean animate) throws InterruptedException {
        List<String> results = new ArrayList<>();
        SimuType simuType = new SimuType(simulatePickups, animate);
        Animation animation = new Animation();
        Distribution thinkDistr = new Distribution(thinkDistribution, thinkPar1, thinkPar2);
        Distribution eatDistr = new Distribution(eatDistribution, eatPar1, eatPar2);
        DiningTable table = new DiningTable(nrPhil, algorithm, thinkDistr, eatDistr, timeout, simuType, animation);


        table.startDinner();
        while (simulationTime > 0) {
            simulationTime--;
            Thread.sleep(10);
            //TODO inspect logic!
            //table.lockClock();
            table.advanceTime();
            //table.unlockClock();
        }
        table.stopDinner();


        String simulationResult = String.format(
                "Algorithm: %s\nSimulation Type: %s\n%s\n\nThink Distribution: %s, Parameters: %s %s\nEat Distribution: %s, Parameters: %s %s",
                algorithm, simuType.simulationType,
                Parser.parse(table.philosophers, table),
                thinkDistribution, thinkPar1, thinkDistribution.equals(Distribution.EXP) || thinkDistribution.equals(Distribution.DETERMINISTIC) ? "" : thinkPar2,
                eatDistribution, eatPar1, eatDistribution.equals(Distribution.EXP) || eatDistribution.equals(Distribution.DETERMINISTIC) ? "" : eatPar2
        );
        results.add(simulationResult);

        if (table.getSimuType().getAnimate()) results.add(table.getAnimation().getAnimationString());

        return results;

    }

    public static void main(String[] args) throws InterruptedException {
        System.out.println(execute(5, 400, Algorithm.FAIRWAITER, true, Distribution.INTERVAL, 50, 100, Distribution.INTERVAL, 50, 100, 200, false));
        /*int number = 12;
        int std = 20;
        System.out.println(Distribution.exponentialDistributionDuration(number));
        System.out.println(Distribution.exponentialDistributionDuration(number));
        System.out.println(Distribution.exponentialDistributionDuration(number));
        System.out.println(Distribution.exponentialDistributionDuration(number));
        System.out.println(Distribution.exponentialDistributionDuration(number));*/

    }
}

