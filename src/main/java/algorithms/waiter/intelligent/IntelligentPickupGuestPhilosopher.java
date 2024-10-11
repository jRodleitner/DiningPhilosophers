package algorithms.waiter.intelligent;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import algorithms.waiter.queuewaiter.Waiter;
import simulation.DiningTable;

public class IntelligentPickupGuestPhilosopher extends AbstractPhilosopher {

    private final IntelligentWaiter waiter;

    public IntelligentPickupGuestPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, IntelligentWaiter waiter) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.waiter = waiter;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission(this);
                pickUpLeftFork();
                pickUpRightFork();
                waiter.returnPermission();
                eat();
                putDownLeftFork();
                putDownRightFork();
                waiter.removeEatState(this);

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
