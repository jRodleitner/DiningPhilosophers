package algorithms.token.multipletoken;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class MultipleTokenPhilosopher extends AbstractPhilosopher {

    protected MultipleTokenPhilosopher rightPhilosopher = null;
    protected volatile Token token;
    private final Object tokenLock = new Object();

    public MultipleTokenPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    public void setToken (Token token){
        this.token = token;
    }

    public void setRightPhilosopher(MultipleTokenPhilosopher rightPhilosopher){
        this.rightPhilosopher = rightPhilosopher;
    }
    protected void acceptToken(Token token) {
        synchronized (tokenLock) {
            this.token = token;
            tokenLock.notify();
        }
    }

    public void run() {
        try {
            while (!isInterrupted()) {
                think();

                synchronized (tokenLock) {
                    while (token == null) {
                        try {
                            tokenLock.wait();
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                            return;
                        }
                    }
                }

                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();

                token.passToken();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}
