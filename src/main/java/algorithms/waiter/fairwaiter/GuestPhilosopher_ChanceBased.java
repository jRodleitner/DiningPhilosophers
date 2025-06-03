package algorithms.waiter.fairwaiter;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class GuestPhilosopher_ChanceBased extends AbstractPhilosopher {

    protected int eatChances;

    private final FairWaiter_ChanceBased waiter;
    public GuestPhilosopher_ChanceBased(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, FairWaiter_ChanceBased waiter) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        eatChances = 0;
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
