package algorithms.semaphore.instant_timeout;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;

import java.util.concurrent.Semaphore;

public class InstantTimeoutChopstick extends AbstractChopstick {
    public InstantTimeoutChopstick(int id) {
        super(id);
        forkSemaphore = new Semaphore(1, true);
    }

    Semaphore forkSemaphore;

    @Override
    public synchronized boolean pickUp(AbstractPhilosopher philosopher) {
        return forkSemaphore.tryAcquire();
    }

    public synchronized void putDown(AbstractPhilosopher philosopher) {
        forkSemaphore.release();
    }

}
