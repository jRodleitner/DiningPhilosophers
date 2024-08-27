package algorithms.token.singletoken;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class TokenPhilosopher extends AbstractPhilosopher {
    protected TokenPhilosopher rightPhilosopher = null;
    protected volatile GlobalToken token;
    private final Object tokenLock = new Object();

    public TokenPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
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

                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();

                token.passToken();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

//package algorithms.token;

/*import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class TokenPhilosopher extends AbstractPhilosopher {
    public TokenPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr, TokenPhilosopher leftphilosopher) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
        this.leftPhilosopher = leftphilosopher;
    }

    protected TokenPhilosopher leftPhilosopher;
    protected Token token;


    protected void acceptToken(Token token){
        this.token = token;
    }

    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                pickUpLeftFork();
                pickUpRightFork();
                eat();
                putDownLeftFork();
                putDownRightFork();
                token.passToken();

            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }


}*/


