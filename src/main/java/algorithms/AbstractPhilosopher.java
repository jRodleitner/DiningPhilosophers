package algorithms;
import parser.Events;
import simulation.*;

import java.util.concurrent.TimeUnit;

public abstract class AbstractPhilosopher extends Thread {
    protected final int id;
    protected AbstractFork leftFork;
    protected AbstractFork rightFork;
    protected final DiningTable table;
    protected final StringBuilder sb;
    protected String lastAction;


    protected final Distribution eatDistr;

    protected final Distribution thinkDistr;

    public AbstractPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        this.id = id;
        this.leftFork = leftFork;
        this.rightFork = rightFork;
        this.table = table;
        this.sb = new StringBuilder();
        this.thinkDistr = thinkistr;
        this.eatDistr = eatDistr;
        this.lastAction = "";
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
        //long duration = (long) (Math.random() * 100);
        long duration = thinkDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.THINK, table.getCurrentTime());
        lastAction = Events.THINK;
    }


    protected void pickUpLeftFork() throws InterruptedException {
        leftFork.pickUp(this);
        if(SimuType.getSimulatePickups()) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
            table.unlockClock();
        }
        lastAction = Events.PICKUPLEFT;
    }

    protected void pickUpRightFork() throws InterruptedException {
        rightFork.pickUp(this);
        if(SimuType.getSimulatePickups()) {
            table.lockClock();
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
            table.unlockClock();
        }
        lastAction = Events.PICKUPRIGHT;
    }

    protected void eat() throws InterruptedException {
        if(!SimuType.getSimulatePickups()){
            sbLog(id, Events.PICKUP, table.getCurrentTime()); //If we do not simulate the pickups we just indicate that the pickup was successful at this point
        }

        long duration = eatDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.EAT, table.getCurrentTime());
        lastAction = Events.EAT;
    }

    protected void putDownLeftFork() {

        if(SimuType.getSimulatePickups()) {
            table.lockClock();
            leftFork.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
            table.unlockClock();
        } else {
            leftFork.putDown(this);
        }

        lastAction = Events.PUTDOWNLEFT;
    }

    protected void putDownRightFork() {

        if(SimuType.getSimulatePickups()){
            table.lockClock();
            rightFork.putDown(this);
            table.advanceTime();
            sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
            table.unlockClock();
        } else {
            rightFork.putDown(this);
        }

        lastAction = Events.PUTDOWNRIGHT;

        if(!SimuType.getSimulatePickups()){
            table.advanceTime();
        }
    }

    public AbstractFork getRightFork(){
        return rightFork;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AbstractPhilosopher that = (AbstractPhilosopher) o;
        return id == that.id;
    }
}
