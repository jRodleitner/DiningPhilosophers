package algorithms;
import parser.Events;
import simulation.*;

import java.util.Objects;
import java.util.concurrent.TimeUnit;

public abstract class AbstractPhilosopher extends Thread {
    protected final int id;
    protected AbstractFork leftFork;
    protected AbstractFork rightFork;
    protected final DiningTable table;
    protected final StringBuilder sb;


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
    }


    protected void pickUpLeftFork() throws InterruptedException {
        leftFork.pickUp(this);
        table.advanceTime();
        sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
    }

    protected void pickUpRightFork() throws InterruptedException {
        rightFork.pickUp(this);
        table.advanceTime();
        sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
    }

    protected void eat() throws InterruptedException {
        //long duration = (long) (Math.random() * 100);
        long duration = eatDistr.calculateDuration();
        TimeUnit.MILLISECONDS.sleep(duration);
        sbLog(id, Events.EAT, table.getCurrentTime());
    }

    protected void putDownLeftFork() {
        leftFork.putDown(this);
        table.advanceTime();
        sbLog(id, Events.PUTDOWNLEFT, table.getCurrentTime());
    }

    protected void putDownRightFork() {
        rightFork.putDown(this);
        table.advanceTime();
        sbLog(id, Events.PUTDOWNRIGHT, table.getCurrentTime());
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
