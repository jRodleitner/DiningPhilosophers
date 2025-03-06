package algorithms.restrict;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class RestrictPhilosopher extends AbstractPhilosopher {


    private final MultiPermitSemaphore multiPermitSemaphore;

    public RestrictPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, MultiPermitSemaphore multiPermitSemaphore) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.multiPermitSemaphore = multiPermitSemaphore;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                multiPermitSemaphore.semaphore.acquire();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                multiPermitSemaphore.semaphore.release();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
