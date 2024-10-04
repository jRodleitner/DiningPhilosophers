package algorithms.asymmetric;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class AsymmetricPhilosopher extends AbstractPhilosopher {

    public AsymmetricPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            boolean even = id % 2 == 0;
            while (!isInterrupted()) {
                think();
                if(even){
                    pickUpLeftFork();
                    pickUpRightFork();
                    eat();
                    putDownLeftFork();
                    putDownRightFork();
                } else {
                    pickUpRightFork();
                    pickUpLeftFork();
                    eat();
                    putDownRightFork();
                    putDownLeftFork();
                }

            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            table.unlockClock();
        }
    }

}
