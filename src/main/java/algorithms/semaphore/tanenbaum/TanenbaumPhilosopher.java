package algorithms.semaphore.tanenbaum;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class TanenbaumPhilosopher extends AbstractPhilosopher {

    private final Monitor monitor;

    public TanenbaumPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, Monitor monitor) {
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
        monitor.mutex.acquire();
        monitor.states[id] = Events.HUNGRY;
        monitor.test(id);
        monitor.mutex.release();

        monitor.semaphores[id].acquire();

        pickUpLeftFork();
        pickUpRightFork();
    }



    private void putDown() throws InterruptedException {
        putDownLeftFork();
        putDownRightFork();

        monitor.mutex.acquire();
        monitor.states[id] = Events.THINK;
        int left = (id + monitor.states.length - 1) % monitor.states.length;
        int right = (id + 1) % monitor.states.length;
        monitor.test(left);
        monitor.test(right);
        monitor.mutex.release();
    }
}

