package algorithms.waiter.fairwaiter;


import algorithms.AbstractPhilosopher;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;

public class FairWaiter {

    private AbstractPhilosopher permittedPhilosopher;
    private final Deque<FairGuestPhilosopher> queuedPhilosophers;


    public FairWaiter() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(AbstractPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add((FairGuestPhilosopher) philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission() {
        long minEats = Integer.MAX_VALUE;
        for (FairGuestPhilosopher ph : queuedPhilosophers) {
            if (ph.eatTimes < minEats && !ph.equals(permittedPhilosopher)) {
                minEats = ph.eatTimes;
                permittedPhilosopher = ph;
            }
        }

        queuedPhilosophers.remove((FairGuestPhilosopher) permittedPhilosopher);
        notifyAll();

    }
}
