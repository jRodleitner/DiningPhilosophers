package simulation;

import java.util.concurrent.Semaphore;

public class VirtualClock {

    private long currentTime = 0;
    private final Semaphore semaphore = new Semaphore(1, true); // Semaphore with 1 permit


    protected void lockClock() {
        try {
            semaphore.acquire();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }


    protected void unlockClock() {
        semaphore.release(); // Releases the semaphore
    }


    protected long getCurrentTime() {
        return currentTime;
    }


    protected void advanceTime(long timeUnits) {
        currentTime += timeUnits;
    }
}
