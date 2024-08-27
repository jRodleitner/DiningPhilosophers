package algorithms.semaphore.roundrobin;

import java.util.concurrent.Semaphore;

public class PhilosopherSemaphores {

    protected Semaphore[] semaphores;
    public PhilosopherSemaphores(int nrPhilosophers){
        semaphores = new Semaphore[nrPhilosophers];

        semaphores[0] = new Semaphore(1);
        for (int i = 1; i < nrPhilosophers; i++) {
            semaphores[i] = new Semaphore(0);
        }

    }


}
