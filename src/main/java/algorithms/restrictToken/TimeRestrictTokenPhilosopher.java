package algorithms.restrictToken;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

import java.util.concurrent.TimeUnit;


public class TimeRestrictTokenPhilosopher extends AbstractPhilosopher {

    private RestrictToken restrictToken;
    private TimeRestrictTokenPhilosopher leftNeighbour, rightNeighbour;
    public long eatTime = 0;

    public TimeRestrictTokenPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, RestrictToken restrictToken) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
        this.restrictToken = restrictToken;
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                if(restrictToken != null) {
                    restrictToken.waitIfRestricted(id);
                }
                pickUpLeftChopstick();
                pickUpRightChopstick();
                eatTime += eatFair();
                requestTokenFromNeighbours();
                putDownLeftChopstick();
                putDownRightChopstick();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    public synchronized void requestTokenFromNeighbours(){
        RestrictToken receivedLft = leftNeighbour.handOverTokenIfHolding(this);
        RestrictToken receivedRgt = rightNeighbour.handOverTokenIfHolding(this);

        if(receivedLft != null) restrictToken = receivedLft;
        if(receivedRgt != null) restrictToken = receivedRgt;
    }

    public synchronized RestrictToken handOverTokenIfHolding(TimeRestrictTokenPhilosopher requester) {
        if(restrictToken != null && requester.eatTime > eatTime) {
            restrictToken.updateRestricted(requester.getPhId());
            RestrictToken token = restrictToken;
            restrictToken = null;
            return token;
        }
        else return null;
    }


    public void setNeighbors(TimeRestrictTokenPhilosopher left, TimeRestrictTokenPhilosopher right) {
        leftNeighbour = left;
        rightNeighbour = right;
    }

    protected long eatFair() throws InterruptedException {
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
        return duration;
    }
}
