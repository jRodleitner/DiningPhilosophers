package algorithms.semaphore.fair_tanenbaum;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import algorithms.semaphore.tanenbaum.Monitor;
import parser.Events;
import simulation.DiningTable;

public class FairTanenbaumPhilosopher extends AbstractPhilosopher {

    private final FairMonitor monitor;

    public FairTanenbaumPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairMonitor monitor) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.monitor = monitor;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                pickUp();
                eats();
                putDown();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }


    private void pickUp() throws InterruptedException {
        monitor.mutex.acquire();
        monitor.updateState(id, Events.HUNGRY);
        monitor.test(id);
        monitor.mutex.release();

        monitor.semaphores[id].acquire();

        pickUpLeftChopstick();
        pickUpRightChopstick();
    }

    private void eats() throws InterruptedException {
        eat();
        monitor.mutex.acquire();
        monitor.updateEatTime(id);
        monitor.mutex.release();
    }



    private void putDown() throws InterruptedException {
        putDownLeftChopstick();
        putDownRightChopstick();

        monitor.mutex.acquire();
        monitor.updateState(id, Events.THINK);
        monitor.checkAll();
        monitor.mutex.release();
    }
}

