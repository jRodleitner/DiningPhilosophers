package algorithms.waiter.fairwaiter;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class GuestPhilosopher_TimeBased extends AbstractPhilosopher {

    protected long eatTime;

    private final FairWaiter_TimeBased waiter;
    public GuestPhilosopher_TimeBased(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairWaiter_TimeBased waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        eatTime = 0;
        this.waiter = waiter;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                waiter.requestPermission(this);
                pickUpLeftChopstick();
                pickUpRightChopstick();
                waiter.returnPermission(this);
                eatTime += eatFair();
                putDownLeftChopstick();
                putDownRightChopstick();

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }


}
