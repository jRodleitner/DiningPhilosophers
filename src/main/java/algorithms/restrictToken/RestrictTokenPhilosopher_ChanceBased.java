package algorithms.restrictToken;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;


public class RestrictTokenPhilosopher_ChanceBased extends AbstractPhilosopher {

    private RestrictToken restrictToken;
    private RestrictTokenPhilosopher_ChanceBased leftNeighbour, rightNeighbour;
    public int eatChances = 0;

    public RestrictTokenPhilosopher_ChanceBased(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr, RestrictToken restrictToken) {
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

    public synchronized RestrictToken handOverTokenIfHolding(RestrictTokenPhilosopher_ChanceBased requester) {
        if(restrictToken != null && requester.eatChances > eatChances) {
            restrictToken.updateRestricted(requester.getPhId());
            RestrictToken token = restrictToken;
            restrictToken = null;
            return token;
        }
        else return null;
    }


    public void setNeighbors(RestrictTokenPhilosopher_ChanceBased left, RestrictTokenPhilosopher_ChanceBased right) {
        leftNeighbour = left;
        rightNeighbour = right;
    }
}
