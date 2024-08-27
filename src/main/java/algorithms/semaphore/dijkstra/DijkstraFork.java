package algorithms.semaphore.dijkstra;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;

import java.util.concurrent.Semaphore;

public class DijkstraFork extends AbstractFork {
    public DijkstraFork(int id) {
        super(id);
        forkSemaphore = new Semaphore(1);
    }

    Semaphore forkSemaphore;

    @Override
    public synchronized boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {

        boolean pickedUp = forkSemaphore.tryAcquire();

        if(pickedUp){
            return true;
        } else {
            return false;
        }

    }

    public synchronized void putDown(AbstractPhilosopher philosopher) {
        forkSemaphore.release();
    }

}
