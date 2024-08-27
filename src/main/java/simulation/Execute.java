package simulation;

import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Parser;

public class Execute {

    public static String execute(int nrPhil, int simulationTime, String algorithm, String eatDistribution, double eatPar1, double eatPar2, String thinkDistribution, double thinkPar1, double thinkPar2, int timeout ) throws InterruptedException{

        Distribution thinkDistr = new Distribution(thinkDistribution,thinkPar1 , thinkPar2);
        Distribution eatDistr = new Distribution(eatDistribution, eatPar1, eatPar2);
        DiningTable table = new DiningTable(nrPhil, algorithm, thinkDistr, eatDistr, timeout);

        table.startDinner();
        while(simulationTime > 0){
            simulationTime--;
            Thread.sleep(10);
            table.advanceTime();
        }
        table.stopDinner();

        String result = String.format(
                "Algorithm: %s\n%s\n\nThink Distribution: %s, Parameters: %s, %s\nEat Distribution: %s, Parameters: %s, %s",
                algorithm,
                Parser.parse(table.philosophers),
                thinkDistribution, thinkPar1, thinkPar2,
                eatDistribution, eatPar1, eatPar2
        );
        /*for(AbstractPhilosopher philosopher: table.philosophers){
            System.out.println(philosopher.getSB().toString());
        }*/
        return result;

    }

    public static void main(String[] args) throws InterruptedException {

        System.out.println(execute(4, 10, Algorithm.TIMEOUT, Distribution.INTERVAL, 50, 100, Distribution.INTERVAL, 50, 100, 200));

    }
}
    /*
    private static boolean deadlock = false;

    public static void setDeadlock(boolean locked){
        deadlock = locked;
    }*/

        /*for(AbstractPhilosopher philosopher: table.philosophers){
            System.out.println(philosopher.getSB().toString());
        }*/

        /*int time = 50;

        Distribution thinkDistr = new Distribution(Distribution.INTERVAL, 0, 100);
        Distribution eatDistr = new Distribution(Distribution.INTERVAL, 0, 100);
        DiningTable table = new DiningTable(3, "NAIVE", thinkDistr, eatDistr);

        table.startDinner();
        while(time > 0){
            time--;
            Thread.sleep(10);
            table.advanceTime();
        }
        table.stopDinner();

        System.out.println(Parser.parse(table.philosophers));

        /*for(AbstractPhilosopher philosopher: table.philosophers){
            System.out.println(philosopher.getSB().toString());
        }
    }*/
