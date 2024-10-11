package algorithms.waiter.intelligent;

import algorithms.AbstractPhilosopher;

import java.util.ArrayDeque;
import java.util.Deque;

public class IntelligentWaiter {

    private volatile AbstractPhilosopher permittedPhilosopher;

    private final Deque<AbstractPhilosopher> queuedPhilosophers;

    private final int nrPhilosophers;


    private final boolean[] eatStates;

    public IntelligentWaiter(int nrPhilosophers) {
        this.nrPhilosophers = nrPhilosophers;
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
        eatStates = new boolean[nrPhilosophers];
    }


    protected synchronized void requestPermission(AbstractPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);
        if (permittedPhilosopher == null) permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }
        setEatState(philosopher);
    }

    protected synchronized void returnPermission() {

        for (AbstractPhilosopher ph : queuedPhilosophers) {
            int leftPhilosopher = (ph.getPhId() - 1 + nrPhilosophers) % nrPhilosophers;  // Index of the left philosopher
            int rightPhilosopher = (ph.getPhId() + 1) % nrPhilosophers;                  // Index of the right philosopher
            if ((!eatStates[leftPhilosopher] && !eatStates[rightPhilosopher]) && !ph.equals(permittedPhilosopher)) {
                permittedPhilosopher = ph;
                queuedPhilosophers.remove(ph);
                notifyAll();  // Notify here after finding the philosopher
                return;  // Exit the method since the philosopher has been found
            }
        }
        // If no ideal philosopher is found, assign the next one in the queue
        permittedPhilosopher = queuedPhilosophers.poll();
        notifyAll();  // Notify if a philosopher is picked from the queue
    }

    private void setEatState(AbstractPhilosopher philosopher) {
        eatStates[philosopher.getPhId()] = true;
    }

    protected synchronized void removeEatState(AbstractPhilosopher philosopher) {
        eatStates[philosopher.getPhId()] = false;
    }

}
