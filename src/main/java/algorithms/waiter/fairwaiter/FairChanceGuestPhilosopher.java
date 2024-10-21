package algorithms.waiter.fairwaiter;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.TimeUnit;

public class FairChanceGuestPhilosopher extends AbstractPhilosopher {

    protected int eatChances;

    private final FairChanceWaiter waiter;
    public FairChanceGuestPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairChanceWaiter waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        eatChances = 0;
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
                eat();
                eatChances++;
                putDownLeftChopstick();
                putDownRightChopstick();

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
