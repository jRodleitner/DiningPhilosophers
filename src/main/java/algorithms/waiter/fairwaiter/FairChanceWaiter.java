package algorithms.waiter.fairwaiter;

import java.util.ArrayDeque;
import java.util.Deque;

public class FairChanceWaiter {

    private volatile FairChanceGuestPhilosopher permittedPhilosopher;
    private final Deque<FairChanceGuestPhilosopher> queuedPhilosophers;


    public FairChanceWaiter() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(FairChanceGuestPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(FairChanceGuestPhilosopher philosopher) throws InterruptedException {
        boolean foundOtherPhilosopherInQueue = false;
        int minEatChances = Integer.MAX_VALUE;
        for (FairChanceGuestPhilosopher ph : queuedPhilosophers) {
            if (ph.eatChances < minEatChances && !ph.equals(philosopher)) {
                minEatChances = ph.eatChances;
                permittedPhilosopher = ph;
                foundOtherPhilosopherInQueue = true;
            }
        }
        if(!foundOtherPhilosopherInQueue) permittedPhilosopher = null;
        else queuedPhilosophers.remove(permittedPhilosopher);
        notifyAll();
    }
}
