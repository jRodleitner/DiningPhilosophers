package algorithms.restrict;

import java.util.concurrent.Semaphore;

public class MultiPermitSemaphore {
    public final Semaphore semaphore;

    public MultiPermitSemaphore(int nrPhilosophers) {
        semaphore = new Semaphore(nrPhilosophers - 1, true);
    }

}
