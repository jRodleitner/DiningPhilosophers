package algorithms.restrictToken;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;


public class RestrictTokenPhilosopher_TimeBased extends AbstractPhilosopher {

    private RestrictToken restrictToken;
    private RestrictTokenPhilosopher_TimeBased leftNeighbour, rightNeighbour;
    protected long eatTime = 0;

    public RestrictTokenPhilosopher_TimeBased(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, RestrictToken restrictToken) {
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

    public synchronized RestrictToken handOverTokenIfHolding(RestrictTokenPhilosopher_TimeBased requester) {
        if(restrictToken != null && requester.eatTime > eatTime) {
            restrictToken.updateRestricted(requester.getPhId());
            RestrictToken token = restrictToken;
            restrictToken = null;
            return token;
        }
        else return null;
    }


    public void setNeighbors(RestrictTokenPhilosopher_TimeBased left, RestrictTokenPhilosopher_TimeBased right) {
        leftNeighbour = left;
        rightNeighbour = right;
    }

}
