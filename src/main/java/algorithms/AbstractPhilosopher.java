package algorithms;
import parser.Events;
import simulation.*;

import java.util.concurrent.TimeUnit;

public abstract class AbstractPhilosopher extends Thread {
    protected final int id;
    protected AbstractChopstick leftChopstick;
    protected AbstractChopstick rightChopstick;
    protected final DiningTable table;
    protected final StringBuilder sb;
    protected String lastAction;
    protected boolean simulatePickups;
    protected int pickedUp;


    protected final Distribution eatDistr;

    protected final Distribution thinkDistr;

    public AbstractPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        this.id = id;
        this.leftChopstick = leftChopstick;
        this.rightChopstick = rightChopstick;
        this.table = table;
        this.sb = new StringBuilder();
        this.thinkDistr = thinkistr;
        this.eatDistr = eatDistr;
        this.lastAction = "";
        this.simulatePickups = table.getSimuType().getSimulatePickups();
        this.pickedUp = 0;
    }

    public StringBuilder getSB(){
        return sb;
    }

    protected void sbLog(int id, String action, long duration) {
        sb.append(String.format("P_%d:%s:%d\n", id, action, duration));
    }

    public int getPhId() {
        return id;
    }

    protected void think() throws InterruptedException {
        long duration = thinkDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.THINK, table.getCurrentTime());
        lastAction = Events.THINK;
    }


    protected void pickUpLeftChopstick() throws InterruptedException {
        leftChopstick.pickUp(this);
        if(simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp++;
        lastAction = Events.PICKUPLEFT;
    }

    protected void pickUpRightChopstick() throws InterruptedException {
        rightChopstick.pickUp(this);
        if(simulatePickups) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
            table.unlockClock();
        }
        pickedUp++;
        lastAction = Events.PICKUPRIGHT;
    }

    protected void eat() throws InterruptedException {
        if(!simulatePickups){
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUP, table.getCurrentTime()); //If we do not simulate the pickups we just indicate that the pickup was successful at this point
            table.unlockClock();
        }

        long duration = eatDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.EAT, table.getCurrentTime());
        lastAction = Events.EAT;
    }

    protected void putDownLeftChopstick() {

        if(simulatePickups) {
            table.lockClock();
            leftChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
            table.unlockClock();
        } else {
            leftChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNLEFT;

    }

    protected void putDownRightChopstick() {

        if(simulatePickups){
            table.lockClock();
            rightChopstick.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
            table.unlockClock();
        } else {
            rightChopstick.putDown(this);
        }
        pickedUp--;
        lastAction = Events.PUTDOWNRIGHT;


    }

    public AbstractChopstick getRightChopstick(){
        return rightChopstick;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AbstractPhilosopher that = (AbstractPhilosopher) o;
        return id == that.id;
    }

    public String getLastAction(){
        return lastAction;
    }

    public int getPickedUp(){
        return pickedUp;
    }

    public void setPickedUp(int pickedUp){
        this.pickedUp = pickedUp;
    }
}
