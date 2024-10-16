package algorithms.waiter.queuewaiter;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class AtomicGuestPhilosopher extends AbstractPhilosopher {

    private final Waiter waiter;
    public AtomicGuestPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, Waiter waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.waiter = waiter;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission(this);
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
                waiter.returnPermission();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
