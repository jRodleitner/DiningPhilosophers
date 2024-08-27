package simulation;

public class VirtualClock {
    private long currentTime = 0;

    public synchronized long getCurrentTime() {
        return currentTime;
    }

    public synchronized void advanceTime(long timeUnits) {
        currentTime += timeUnits;
    }
}

