package algorithms;

import java.util.concurrent.Semaphore;

public class SimpleChopstick extends AbstractChopstick {

    Semaphore chopstickSemaphore;

    public SimpleChopstick(int id) {
        super(id);
        chopstickSemaphore = new Semaphore(1, true);
    }


    @Override
    public boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {
        chopstickSemaphore.acquire();
        return true;
    }

    @Override
    public void putDown(AbstractPhilosopher philosopher) {
        chopstickSemaphore.release();
    }
}



