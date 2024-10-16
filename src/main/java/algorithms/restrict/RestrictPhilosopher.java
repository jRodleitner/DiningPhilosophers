package algorithms.restrict;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class RestrictPhilosopher extends AbstractPhilosopher {
    public RestrictPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
