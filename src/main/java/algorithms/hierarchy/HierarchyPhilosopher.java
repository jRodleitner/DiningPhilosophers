package algorithms.hierarchy;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class HierarchyPhilosopher extends AbstractPhilosopher {
    //pickup fork with lower id first

    public HierarchyPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                if(leftFork.getId() < rightFork.getId()){
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
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
