package algorithms.semaphore.roundrobin;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class RoundRobinPhilosopher extends AbstractPhilosopher {
    Semaphore[] semaphores;
    public RoundRobinPhilosopher(int id, AbstractChopstick leftFork, AbstractChopstick rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, PhilosopherSemaphores philosopherSemaphores) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.semaphores = philosopherSemaphores.semaphores;
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
                semaphores[(id + 1) % semaphores.length].release();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

}
