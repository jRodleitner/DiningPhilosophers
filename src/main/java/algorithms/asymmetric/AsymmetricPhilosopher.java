package algorithms.asymmetric;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class AsymmetricPhilosopher extends AbstractPhilosopher {

    public AsymmetricPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            boolean even = id % 2 == 0;
            while (!isInterrupted()) {
                think();
                if(even){
                    pickUpLeftChopstick();
                    pickUpRightChopstick();
                    eat();
                    putDownLeftChopstick();
                    putDownRightChopstick();
                } else {
                    pickUpRightChopstick();
                    pickUpLeftChopstick();
                    eat();
                    putDownRightChopstick();
                    putDownLeftChopstick();
                }

            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            table.unlockClock();
        }
    }

}
