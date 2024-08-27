package algorithms.waiter.queuewaiter;

import algorithms.AbstractPhilosopher;

import java.util.ArrayDeque;
import java.util.Deque;

public class Waiter {

    private AbstractPhilosopher permittedPhilosopher;

    private Deque<AbstractPhilosopher> queuedPhilosophers;

    public Waiter(){
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
    }


    public synchronized void requestPermission(AbstractPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);
        if (permittedPhilosopher == null) permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(){
        permittedPhilosopher = queuedPhilosophers.poll();
        notify();
    }
}
