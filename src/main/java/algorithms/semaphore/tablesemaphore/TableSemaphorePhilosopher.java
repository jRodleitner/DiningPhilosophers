package algorithms.semaphore.tablesemaphore;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class TableSemaphorePhilosopher extends AbstractPhilosopher {

    private volatile Semaphore semaphore;
    public TableSemaphorePhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, TableSemaphore tableSemaphore) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.semaphore = tableSemaphore.semaphore;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                semaphore.acquire();
                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();
                semaphore.release();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

}
