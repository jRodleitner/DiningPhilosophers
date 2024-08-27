package algorithms.timeout;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import simulation.DiningTable;

public class TimeoutFork extends AbstractFork {
    int timeout;
    public TimeoutFork(int id, int timeout) {
        super(id);
        this.timeout = timeout;
    }


    public synchronized boolean pickUpRight(AbstractPhilosopher philosopher) throws InterruptedException {
        long startTime = System.currentTimeMillis();
        long remainingTime = timeout;

        while (!isAvailable) {
            if (remainingTime <= 0) {
                //System.out.println("TIMEOUT:" + philosopher.getName() + "Time: " + table.getCurrentTime());
                return false;
            }

            wait(remainingTime);
            remainingTime = timeout - (System.currentTimeMillis() - startTime);
        }

        isAvailable = false;
        return true;
    }

}
