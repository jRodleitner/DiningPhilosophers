package algorithms.waiter.intelligent;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class IntelligentPickupGuestPhilosopher extends AbstractPhilosopher {

    private final IntelligentWaiter waiter;

    public IntelligentPickupGuestPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, IntelligentWaiter waiter) {
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
                waiter.returnPermission();
                eat();
                waiter.removeEatState(this);
                putDownLeftChopstick();
                putDownRightChopstick();

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
