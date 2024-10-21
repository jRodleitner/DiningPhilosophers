package algorithms.timeout;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class TimeoutPhilosopher extends AbstractPhilosopher {
    private final TimeoutChopstick rightTimeoutChopstick;
    public TimeoutPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        rightTimeoutChopstick = (TimeoutChopstick)rightChopstick;
    }



    @Override
    public void run() {
        try {

            while (!isInterrupted()) {
                think();
                pickUpLeftChopstick();
                boolean successfulPickup = pickUpRightWithTimeout();
                while (!successfulPickup) {
                    putDownLeftChopstick();
                    int random = (int) (Math.random() * 25) + 1;
                    Thread.sleep(random);
                    pickUpLeftChopstick();
                    successfulPickup = pickUpRightWithTimeout();
                }
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();

            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    protected boolean pickUpRightWithTimeout() throws InterruptedException {
        boolean successfulPickup = rightTimeoutChopstick.pickUpRight(this);
        if(successfulPickup){
            if(simulatePickups){
                table.lockClock();
                table.advanceTime();
                sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
                table.unlockClock();
            }
            pickedUp++;
            lastAction = Events.PICKUPRIGHT;
        }
        return successfulPickup;
    }


}
