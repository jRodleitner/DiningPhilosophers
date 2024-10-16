package algorithms.waiter.fairwaiter;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.TimeUnit;

public class FairGuestPhilosopher extends AbstractPhilosopher {

    protected volatile long eatTimes;

    private volatile FairWaiter waiter;
    public FairGuestPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairWaiter waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        eatTimes = 0;
        this.waiter = waiter;
    }

    //TODO CHANGE to PICKUP???
    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission(this);
                pickUpLeftChopstick();
                pickUpRightChopstick();
                waiter.returnPermission(this);
                eatTimes += eatFair();
                putDownLeftChopstick();
                putDownRightChopstick();

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    protected Long eatFair() throws InterruptedException {
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

}
