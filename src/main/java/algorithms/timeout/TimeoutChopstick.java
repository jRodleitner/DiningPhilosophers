package algorithms.timeout;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;

public class TimeoutChopstick extends AbstractChopstick {
    int timeout;
    public TimeoutChopstick(int id, int timeout) {
        super(id);
        this.timeout = timeout;
    }


    public synchronized boolean pickUpRight(AbstractPhilosopher philosopher) throws InterruptedException {
        long startTime = System.currentTimeMillis();
        long remainingTime = timeout;

        while (!isAvailable) {
            if (remainingTime <= 0) {
                return false;
            }

            wait(remainingTime);
            remainingTime = timeout - (System.currentTimeMillis() - startTime);
        }

        isAvailable = false;
        return true;
    }

}
