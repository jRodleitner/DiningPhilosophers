package algorithms.restrictToken;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;


public class RestrictTokenPhilosopher extends AbstractPhilosopher {

    private RestrictToken restrictToken;
    private RestrictTokenPhilosopher leftNeighbour, rightNeighbour;
    public int eatChances = 0;

    public RestrictTokenPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, RestrictToken restrictToken) {
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
                eat();
                eatChances++;
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

    public synchronized RestrictToken handOverTokenIfHolding(RestrictTokenPhilosopher requester) {
        if(restrictToken != null && requester.eatChances > eatChances) {
            restrictToken.updateRestricted(requester.getPhId());
            RestrictToken token = restrictToken;
            restrictToken = null;
            return token;
        }
        else return null;
    }


    public void setNeighbors(RestrictTokenPhilosopher left, RestrictTokenPhilosopher right) {
        leftNeighbour = left;
        rightNeighbour = right;
    }
}
