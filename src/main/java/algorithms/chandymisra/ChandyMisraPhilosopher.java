package algorithms.chandymisra;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.locks.Lock;

public class ChandyMisraPhilosopher extends AbstractPhilosopher {

    private final ChandyMisraChopstick leftChopstick;
    private final ChandyMisraChopstick rightChopstick;

    private ChandyMisraPhilosopher leftNeighbor, rightNeighbor;

    private boolean goingToEatRequest = false;

    private boolean stillRunning = true;

    public ChandyMisraPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.leftChopstick = (ChandyMisraChopstick) leftChopstick;
        this.rightChopstick = (ChandyMisraChopstick) rightChopstick;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                thinking();
                processChopsticks(true);
                obtainChopsticksIfNecessary();
                eating();
                processChopsticks(true);  // Ensure release of chopsticks after last eat
            }
        } catch (InterruptedException e) {
            //System.out.println("Philosopher " + id + " interrupted" );
            stillRunning = false;
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    private void obtainChopsticksIfNecessary() throws InterruptedException {
        //System.out.println("Philosopher " + id + " is preparing to eat.");
        goingToEatRequest = true;
        waitForChopstick(leftChopstick);
        waitForChopstick(rightChopstick);
        goingToEatRequest = false;
        //System.out.println("Philosopher " + id + " obtained both chopsticks and is ready to eat.");
    }

    private void waitForChopstick(ChandyMisraChopstick chopstick) throws InterruptedException {
        synchronized (chopstick) {
            //try {
                //System.out.println("Philosopher " + id + " is waiting for chopstick " + chopstick.getId());
                while (chopstick.owner != this) {
                    processChopsticks(true);  // Release dirty chopstick while waiting
                    chopstick.wait();
                }
                //System.out.println("Philosopher " + id + " acquired chopstick " + chopstick.getId());
            /*} catch (InterruptedException e) {
                System.out.println("Philosopher " + id + " interrupted while waiting for chopstick " + chopstick.getId());
                Thread.currentThread().interrupt();  // Handle interruption
            }*/
        }
    }

    private void processChopsticks(boolean isRequestRequired) {
        //System.out.println("Philosopher " + id + " is processing chopsticks.");
        giveUpChopstickIfNecessary(leftChopstick, leftNeighbor, isRequestRequired);
        giveUpChopstickIfNecessary(rightChopstick, rightNeighbor, isRequestRequired);
    }

    private void giveUpChopstickIfNecessary(ChandyMisraChopstick chopstick, ChandyMisraPhilosopher receiver, boolean isRequestRequired) {
        synchronized (chopstick) {
            if ((receiver.goingToEatRequest || !isRequestRequired) && !chopstick.isClean && chopstick.owner == this) {
                chopstick.isClean = true;
                chopstick.owner = receiver;
                chopstick.notifyAll();  // Notify waiting philosopher
                //System.out.println("Philosopher " + id + " gave chopstick " + chopstick.getId() + " to philosopher " + receiver.id);
            }
        }
    }

    private void eating() throws InterruptedException {
        //System.out.println("Philosopher " + id + " is starting to eat.");
        pickUpLeftChopstick();
        pickUpRightChopstick();
        eat();
        rightChopstick.isClean = leftChopstick.isClean = false;
        //System.out.println("Philosopher " + id + " has finished eating.");
        putDownLeftChopstick();
        putDownRightChopstick();
    }

    private void thinking() throws InterruptedException {
        think();
    }

    public void setNeighbors(ChandyMisraPhilosopher leftNeighbor, ChandyMisraPhilosopher rightNeighbor) {
        this.leftNeighbor = leftNeighbor;
        this.rightNeighbor = rightNeighbor;
    }

    @Override
    protected void pickUpLeftChopstick() throws InterruptedException {
        if(simulatePickups) {
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

        if(simulatePickups) {
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

        if(simulatePickups) {
            table.lockClock();
            //leftChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
            table.unlockClock();
        } else {
            //leftChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNLEFT;

    }

    @Override
    protected void putDownRightChopstick() {

        if(simulatePickups){
            table.lockClock();
            //rightChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
            table.unlockClock();
        } else {
            //rightChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNRIGHT;
    }

}

/*
    @Override
    protected void pickUpLeftChopstick() throws InterruptedException {
        if(simulatePickups) {
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

        if(simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp++;
        lastAction = Events.PICKUPRIGHT;
    }

    protected void putDownLeftChopstick() {

        if(simulatePickups) {
            table.lockClock();
            //leftChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
            table.unlockClock();
        } else {
            //leftChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNLEFT;

    }

    protected void putDownRightChopstick() {

        if(simulatePickups){
            table.lockClock();
            //rightChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
            table.unlockClock();
        } else {
            //rightChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNRIGHT;
    }*/
