package algorithms.timeout;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;
import simulation.SimuType;

public class TimeoutPhilosopher extends AbstractPhilosopher {
    private TimeoutFork rightTimeoutFork;
    public TimeoutPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        rightTimeoutFork = (TimeoutFork)rightFork;
    }



    @Override
    public void run() {
        try {

            while (!isInterrupted()) {
                think();
                pickUpLeftFork();
                boolean succPickup = pickUpRightWithTimeout();
                if(succPickup){
                    eat();
                    putDownLeftFork();
                    putDownRightFork();
                } else {
                    putDownLeftFork();
                }

            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    protected boolean pickUpRightWithTimeout() throws InterruptedException {
        boolean succPickup = rightTimeoutFork.pickUpRight(this);
        if(succPickup && SimuType.getSimulatePickups()){
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
        }
        lastAction = Events.PICKUPRIGHT;
        return succPickup;
    }


}
