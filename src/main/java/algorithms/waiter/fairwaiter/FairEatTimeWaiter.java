package algorithms.waiter.fairwaiter;


import java.util.ArrayDeque;
import java.util.Deque;

public class FairEatTimeWaiter {

    private volatile FairEatTimeGuestPhilosopher permittedPhilosopher;
    private final Deque<FairEatTimeGuestPhilosopher> queuedPhilosophers;


    public FairEatTimeWaiter() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(FairEatTimeGuestPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(FairEatTimeGuestPhilosopher philosopher) throws InterruptedException {
        boolean foundOtherPhilosopherInQueue = false;
        long minEatTime = Integer.MAX_VALUE;
        for (FairEatTimeGuestPhilosopher ph : queuedPhilosophers) {
            if (ph.eatTime < minEatTime && !ph.equals(philosopher)) {
                minEatTime = ph.eatTime;
                permittedPhilosopher = ph;
                foundOtherPhilosopherInQueue = true;
            }
        }
        if(!foundOtherPhilosopherInQueue) permittedPhilosopher = null;
        else queuedPhilosophers.remove(permittedPhilosopher);
        notifyAll();
    }
}
