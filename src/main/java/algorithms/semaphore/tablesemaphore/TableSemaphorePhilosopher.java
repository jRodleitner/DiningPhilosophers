package algorithms.semaphore.tablesemaphore;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class TableSemaphorePhilosopher extends AbstractPhilosopher {

    private volatile Semaphore semaphore;
    public TableSemaphorePhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, TableSemaphore tableSemaphore) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.semaphore = tableSemaphore.semaphore;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                semaphore.acquire();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                semaphore.release();
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
