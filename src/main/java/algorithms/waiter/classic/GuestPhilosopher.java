package algorithms.waiter.classic;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;


public class GuestPhilosopher extends AbstractPhilosopher {

    private final ClassicWaiter waiter;

    public GuestPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, ClassicWaiter waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.waiter = waiter;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
                waiter.returnForks();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}

