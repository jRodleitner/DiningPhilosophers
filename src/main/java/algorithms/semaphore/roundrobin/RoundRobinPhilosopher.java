package algorithms.semaphore.roundrobin;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.Semaphore;

public class RoundRobinPhilosopher extends AbstractPhilosopher {
    Semaphore[] semaphores;
    public RoundRobinPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, PhilosopherSemaphores philosopherSemaphores) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.semaphores = philosopherSemaphores.semaphores;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                semaphores[id].acquire();
                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();
                semaphores[(id + 1) % semaphores.length].release();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

}
