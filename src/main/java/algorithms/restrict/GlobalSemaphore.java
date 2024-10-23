package algorithms.restrict;

import java.util.concurrent.Semaphore;

public class GlobalSemaphore {
    public final Semaphore semaphore;

    public GlobalSemaphore(int nrPhilosophers) {
        semaphore = new Semaphore(nrPhilosophers - 1, true);
    }

}
