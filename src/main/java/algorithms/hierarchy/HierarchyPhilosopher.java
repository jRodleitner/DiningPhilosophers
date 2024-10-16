package algorithms.hierarchy;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class HierarchyPhilosopher extends AbstractPhilosopher {
    //pickup fork with lower id first

    public HierarchyPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                if(leftChopstick.getId() < rightChopstick.getId()){
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
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
