package algorithms.waiter.fairwaiter;


import algorithms.AbstractPhilosopher;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;

public class FairWaiter {

    private volatile FairGuestPhilosopher permittedPhilosopher;
    private final Deque<FairGuestPhilosopher> queuedPhilosophers;


    public FairWaiter() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(FairGuestPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(FairGuestPhilosopher philosopher) throws InterruptedException {
        boolean foundOtherPhilosopherInQueue = false;
        long minEats = Integer.MAX_VALUE;
        for (FairGuestPhilosopher ph : queuedPhilosophers) {
            if (ph.eatTimes < minEats && !ph.equals(philosopher)) {
                minEats = ph.eatTimes;
                permittedPhilosopher = ph;
                foundOtherPhilosopherInQueue = true;
            }
        }
        if(!foundOtherPhilosopherInQueue) permittedPhilosopher = null;
        else queuedPhilosophers.remove(permittedPhilosopher);
        notifyAll();
    }
}
