package algorithms.semaphore.fair_tanenbaum;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.TimeUnit;

public class FairTimeTanenbaumPhilosopher extends AbstractPhilosopher {

    private final FairTimeMonitor monitor;

    public FairTimeTanenbaumPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairTimeMonitor monitor) {
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
        long eatTime = eatFair();
        monitor.mutex.acquire();
        monitor.updateEatTime(id, eatTime);
        monitor.mutex.release();
    }

    protected long eatFair() throws InterruptedException {
        if(!simulatePickups){
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUP, table.getCurrentTime()); //If we do not simulate the pickups we just indicate that the pickup was successful at this point
            table.unlockClock();
        }

        long duration = eatDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.EAT, table.getCurrentTime());
        lastAction = Events.EAT;
        return duration;
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