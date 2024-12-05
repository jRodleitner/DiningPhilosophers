package algorithms.token.singletoken;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class TokenPhilosopher extends AbstractPhilosopher {
    protected TokenPhilosopher rightPhilosopher = null;
    protected volatile GlobalToken token;
    private final Lock tokenLock = new ReentrantLock(true);

    public TokenPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    public void setToken (GlobalToken token){
        this.token = token;
    }

    public void setRightPhilosopher(TokenPhilosopher rightPhilosopher){
        this.rightPhilosopher = rightPhilosopher;
    }

    protected void acceptToken(GlobalToken token) {
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

                pickUpLeftChopstick();
                pickUpRightChopstick();
                eat();
                putDownLeftChopstick();
                putDownRightChopstick();

                token.passToken();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }
}



