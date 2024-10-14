package algorithms.semaphore.fair_tanenbaum;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class FairTanenbaumPhilosopher extends AbstractPhilosopher {

    private final FairMonitor monitor;

    public FairTanenbaumPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairMonitor monitor) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.monitor = monitor;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                pickUp();
                eat();
                putDown();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    private void pickUp() throws InterruptedException {
        monitor.mutex.acquire(); // Enter critical section
        monitor.states[id] = Events.BLOCKED; // Philosopher is hungry
        monitor.hungryQueue.add(id); // Add philosopher to the hungry queue
        monitor.test(id); // Check if they can eat
        monitor.mutex.release(); // Exit critical section

        monitor.semaphores[id].acquire(); // Block if they can't eat yet

        pickUpLeftFork();
        pickUpRightFork();
    }

    private void putDown() throws InterruptedException {
        putDownLeftFork();
        putDownRightFork();

        monitor.mutex.acquire(); // Enter critical section
        monitor.states[id] = Events.THINK; // Philosopher is thinking again
        monitor.recheckHungryQueue();
        monitor.mutex.release(); // Exit critical section
    }
}

