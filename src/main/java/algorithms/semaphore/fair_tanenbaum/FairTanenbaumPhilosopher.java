package algorithms.semaphore.fair_tanenbaum;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class FairTanenbaumPhilosopher extends AbstractPhilosopher {

    private volatile FairGlobals global;

    public FairTanenbaumPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairGlobals global) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.global = global;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                thinks();
                pickup();
                eats();
                putdown();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private void thinks() throws InterruptedException {
        think(); // Simulate thinking
    }

    private void pickup() throws InterruptedException {
        global.mutex.acquire(); // Enter critical section
        global.states[id] = Events.BLOCKED; // Philosopher is hungry
        global.hungryQueue.add(id); // Add philosopher to the hungry queue
        global.test(id); // Check if they can eat
        global.mutex.release(); // Exit critical section

        global.semaphores[id].acquire(); // Block if they can't eat yet

        pickUpLeftFork();
        pickUpRightFork();
    }

    private void eats() throws InterruptedException {
        eat(); // Simulate eating
    }

    private void putdown() throws InterruptedException {
        putDownLeftFork();
        putDownRightFork();

        global.mutex.acquire(); // Enter critical section
        global.states[id] = Events.THINK; // Philosopher is thinking again
        global.recheckHungryQueue();
        global.mutex.release(); // Exit critical section
    }
}





/*package algorithms.semaphore.dijkstra;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class SemaphorePhilosopher extends AbstractPhilosopher {

    private volatile Globals global;
    public SemaphorePhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                thinks();
                pickup();
                eats();
                putdown();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private void thinks() throws InterruptedException {

        think();
    }

    private void pickup() throws InterruptedException {
        global.mutex.acquire();
        global.states[id] = Events.BLOCKED;
        global.mutex.release();


        pickUpLeftFork();
        pickUpRightFork();
    }

    private void eats() throws InterruptedException {
        global.mutex.acquire();
        global.states[id] = Events.EAT;
        global.mutex.release();
        eat();
    }

    private void putdown() throws InterruptedException {
        putDownLeftFork();
        putDownRightFork();
        global.mutex.acquire();
        global.states[id] = Events.THINK;
        global.mutex.release();
    }
}*/
