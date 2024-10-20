package algorithms.semaphore.roundrobin;

import java.util.concurrent.Semaphore;

public class RoundRobinScheduler {

    private final Semaphore[] semaphores;
    int currentTurn = 0;
    public RoundRobinScheduler(int nrPhilosophers){
        semaphores = new Semaphore[nrPhilosophers];

        semaphores[0] = new Semaphore(1);
        for (int i = 1; i < nrPhilosophers; i++) {
            semaphores[i] = new Semaphore(0);
        }

    }

    protected Semaphore[] getSemaphores(){
        return semaphores;
    }

    protected synchronized void updateCurrentTurn(){
        currentTurn = (currentTurn + 1) % semaphores.length;
        semaphores[currentTurn].release();
    }




}
