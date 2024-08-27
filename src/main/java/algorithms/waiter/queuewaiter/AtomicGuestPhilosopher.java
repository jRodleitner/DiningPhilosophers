package algorithms.waiter.queuewaiter;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class AtomicGuestPhilosopher extends AbstractPhilosopher {

    private volatile Waiter waiter;
    public AtomicGuestPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, Waiter waiter) {
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
                eat();
                putDownLeftFork();
                putDownRightFork();
                waiter.returnPermission();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
