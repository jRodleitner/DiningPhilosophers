package algorithms.waiter.fairwaiter;

import java.util.ArrayDeque;
import java.util.Deque;

public class FairWaiter_ChanceBased {

    private volatile GuestPhilosopher_ChanceBased permittedPhilosopher;
    private final Deque<GuestPhilosopher_ChanceBased> queuedPhilosophers;


    public FairWaiter_ChanceBased() {
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(GuestPhilosopher_ChanceBased philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(GuestPhilosopher_ChanceBased philosopher) throws InterruptedException {
        boolean foundOtherPhilosopherInQueue = false;
        int minEatChances = Integer.MAX_VALUE;
        for (GuestPhilosopher_ChanceBased ph : queuedPhilosophers) {
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
