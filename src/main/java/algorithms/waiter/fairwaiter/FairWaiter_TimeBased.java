package algorithms.waiter.fairwaiter;


import java.util.ArrayDeque;
import java.util.Deque;

public class FairWaiter_TimeBased {

    private volatile GuestPhilosopher_TimeBased permittedPhilosopher;
    private final Deque<GuestPhilosopher_TimeBased> queuedPhilosophers;


    public FairWaiter_TimeBased() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(GuestPhilosopher_TimeBased philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(GuestPhilosopher_TimeBased philosopher) throws InterruptedException {
        boolean foundOtherPhilosopherInQueue = false;
        long minEatTime = Integer.MAX_VALUE;
        for (GuestPhilosopher_TimeBased ph : queuedPhilosophers) {
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
