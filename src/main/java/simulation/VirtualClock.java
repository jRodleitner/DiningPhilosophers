package simulation;

import java.util.concurrent.Semaphore;

public class VirtualClock {

    private long currentTime = 0;
    private final Semaphore semaphore = new Semaphore(1, true);


    protected void lockClock() {
        try {
            semaphore.acquire();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }


    protected void unlockClock() {
        semaphore.release();
    }


    protected long getCurrentTime() {
        return currentTime;
    }


    //left in since some future algorithm-simulations might need to adjust this
    protected void advanceTime(long timeUnits) {
        currentTime += timeUnits;
    }
}
