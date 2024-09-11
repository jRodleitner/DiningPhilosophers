package simulation;

import java.util.concurrent.Semaphore;

public class VirtualClock {

    private long currentTime = 0;

    public synchronized long getCurrentTime() {
        return currentTime;
    }

    public synchronized void advanceTime(long timeUnits) {
        currentTime += timeUnits;
    }

    public synchronized long getCurrentTimeAndAdvanceTime(long timeUnits) {
        currentTime += timeUnits;
        return currentTime;
    }
}

