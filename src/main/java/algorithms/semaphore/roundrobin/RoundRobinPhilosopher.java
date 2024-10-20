package algorithms.semaphore.roundrobin;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class RoundRobinPhilosopher extends AbstractPhilosopher {
    private final Semaphore[] semaphores;

    private final RoundRobinScheduler scheduler;
    public RoundRobinPhilosopher(int id, AbstractChopstick leftFork, AbstractChopstick rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, RoundRobinScheduler roundRobinScheduler) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        semaphores = roundRobinScheduler.getSemaphores();
        this.scheduler = roundRobinScheduler;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                semaphores[id].acquire();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
                scheduler.updateCurrentTurn();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

}
