package algorithms.semaphore.tanenbaum;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class TanenbaumPhilosopher extends AbstractPhilosopher {

    private volatile Monitor global;

    public TanenbaumPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, Monitor global) {
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
        think();
    }

    private void pickup() throws InterruptedException {
        global.mutex.acquire();
        global.states[id] = Events.BLOCKED;
        global.test(id);
        global.mutex.release();

        global.semaphores[id].acquire();

        pickUpLeftFork();
        pickUpRightFork();
    }

    private void eats() throws InterruptedException {
        eat(); // Simulate eating
    }

    private void putdown() throws InterruptedException {
        putDownLeftFork();
        putDownRightFork();

        global.mutex.acquire();
        global.states[id] = Events.THINK;
        int left = (id + global.states.length - 1) % global.states.length;
        int right = (id + 1) % global.states.length;
        global.test(left);
        global.test(right);
        global.mutex.release();
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
