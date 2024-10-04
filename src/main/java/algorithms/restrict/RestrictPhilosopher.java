package algorithms.restrict;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class RestrictPhilosopher extends AbstractPhilosopher {
    public RestrictPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
