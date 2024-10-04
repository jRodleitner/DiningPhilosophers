package simulation;

import java.util.concurrent.Semaphore;

public class VirtualClock {

    private long currentTime = 0;
    private final Semaphore semaphore = new Semaphore(1); // Semaphore with 1 permit

    // Method to acquire the semaphore (protected)
    protected void lockClock() {
        try {
            semaphore.acquire(); // Acquires the semaphore, blocking if it's not available
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restore interrupted status
            //throw new RuntimeException("Thread was interrupted while acquiring the lock", e);
        }
    }

    // Method to release the semaphore (protected)
    protected void unlockClock() {
        semaphore.release(); // Releases the semaphore
    }

    // Get the current time (protected)
    protected long getCurrentTime() {
        return currentTime;
    }

    // Advance time (protected)
    protected void advanceTime(long timeUnits) {
        currentTime += timeUnits;
    }
}
