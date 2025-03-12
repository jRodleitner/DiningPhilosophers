package algorithms.chandymisra;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.TimeUnit;

public class ChandyMisraPhilosopher extends AbstractPhilosopher {

    private final ChandyMisraChopstick leftChopstick;
    private final ChandyMisraChopstick rightChopstick;

    private ChandyMisraPhilosopher leftNeighbor, rightNeighbor;

    private boolean goingToEatRequest = false;

    public ChandyMisraPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.leftChopstick = (ChandyMisraChopstick) leftChopstick;
        this.rightChopstick = (ChandyMisraChopstick) rightChopstick;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                checkForRequests();
                think();
                checkForRequests();
                requestChopsticksIfNecessary();
                eating();
                checkForRequests();  // Ensure release of chopsticks after last eat
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    private void requestChopsticksIfNecessary() throws InterruptedException {
        goingToEatRequest = true;
        while(leftChopstick.owner != this || rightChopstick.owner != this) {
            waitForChopstick(leftChopstick);
            waitForChopstick(rightChopstick);
        }
        goingToEatRequest = false;
    }

    private void waitForChopstick(ChandyMisraChopstick chopstick) throws InterruptedException {
        synchronized (chopstick) {
            while (chopstick.owner != this) {
                checkForRequests();  // Release dirty chopstick while waiting
                chopstick.wait(10);
            }
        }
    }

    private void checkForRequests() {
        giveUpChopstickIfRequested(leftChopstick, leftNeighbor);
        giveUpChopstickIfRequested(rightChopstick, rightNeighbor);
    }

    private void giveUpChopstickIfRequested(ChandyMisraChopstick chopstick, ChandyMisraPhilosopher receiver) {
        synchronized (chopstick) {
            if ((receiver.goingToEatRequest) && !chopstick.isClean && chopstick.owner == this) {
                chopstick.isClean = true;
                chopstick.owner = receiver;
                chopstick.notifyAll();  // Notify waiting philosopher
            }
        }
    }

    private void eating() throws InterruptedException {
        pickUpLeftChopstick();
        pickUpRightChopstick();
        eat();
        putDownLeftChopstick();
        putDownRightChopstick();
        rightChopstick.isClean = leftChopstick.isClean = false;
    }

    @Override
    protected void think() throws InterruptedException {
        long remainingTime = thinkDistr.calculateDuration();

        while (remainingTime > 0) {
            long sleepTime = Math.min(remainingTime, 10);
            TimeUnit.MILLISECONDS.sleep(sleepTime);
            checkForRequests();
            remainingTime -= sleepTime;
        }

        sbLog(id, Events.THINK, table.getCurrentTime());
        lastAction = Events.THINK;
    }

    public void setNeighbors(ChandyMisraPhilosopher leftNeighbor, ChandyMisraPhilosopher rightNeighbor) {
        this.leftNeighbor = leftNeighbor;
        this.rightNeighbor = rightNeighbor;
    }

    //________________________________________________________________________________________________________________//
    //____________________________________________Modified pickUps/putDowns for efficiency____________________________//
    //________________________________________________________________________________________________________________//

    @Override
    protected void pickUpLeftChopstick() throws InterruptedException {
        if (simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp++;
        lastAction = Events.PICKUPLEFT;
    }

    @Override
    protected void pickUpRightChopstick() throws InterruptedException {

        if (simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp++;
        lastAction = Events.PICKUPRIGHT;
    }

    @Override
    protected void putDownLeftChopstick() {

        if (simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp--;
        lastAction = Events.PUTDOWNLEFT;

    }

    @Override
    protected void putDownRightChopstick() {

        if (simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp--;
        lastAction = Events.PUTDOWNRIGHT;
    }

}

