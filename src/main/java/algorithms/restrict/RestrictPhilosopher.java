package algorithms.restrict;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class RestrictPhilosopher extends AbstractPhilosopher {


    private final GlobalSemaphore globalSemaphore;

    public RestrictPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, GlobalSemaphore globalSemaphore) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.globalSemaphore = globalSemaphore;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                globalSemaphore.semaphore.acquire();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                globalSemaphore.semaphore.release();
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
