package algorithms.waiter.fairwaiter;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class FairGuestPhilosopher extends AbstractPhilosopher {

    protected int eatTimes;

    private volatile FairWaiter waiter;
    public FairGuestPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairWaiter waiter) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        eatTimes = 0;
        this.waiter = waiter;
    }

    //TODO CHANGE to PICKUP???
    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission(this);
                pickUpLeftFork();
                pickUpRightFork();
                eat();
                eatTimes++;
                putDownLeftFork();
                putDownRightFork();
                waiter.returnPermission();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

}
