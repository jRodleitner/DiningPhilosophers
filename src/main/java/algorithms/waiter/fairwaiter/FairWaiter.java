package algorithms.waiter.fairwaiter;


import algorithms.AbstractPhilosopher;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;

public class FairWaiter {

    private AbstractPhilosopher permittedPhilosopher;
    private Deque<AbstractPhilosopher> queuedPhilosophers;
    private ArrayList<FairGuestPhilosopher> philosophers;


    public FairWaiter(){
        permittedPhilosopher = null;
        queuedPhilosophers = new ArrayDeque<>();
        philosophers = new ArrayList<>();
    }


    public synchronized void requestPermission(AbstractPhilosopher philosopher) throws InterruptedException {
        queuedPhilosophers.add(philosopher);
        philosophers.add((FairGuestPhilosopher) philosopher);

        if (permittedPhilosopher == null) {
            permittedPhilosopher = queuedPhilosophers.poll(); //no philosopher is currently permitted, thus one has to be assigned
            philosophers.remove(permittedPhilosopher);
        }

        while (!philosopher.equals(permittedPhilosopher)) {
            wait();
        }

    }

    public synchronized void returnPermission(){
        int minEats = Integer.MAX_VALUE;
        for(FairGuestPhilosopher ph: philosophers){
            if (ph.eatTimes < minEats) {
                minEats = ph.eatTimes;
            }
        }
        for(FairGuestPhilosopher ph: philosophers){
            if (ph.eatTimes == minEats) {
                permittedPhilosopher = ph;
                System.out.println("Philosopher preferred: " + ph + "mineats:" + ph.eatTimes);
                philosophers.remove(ph);
                queuedPhilosophers.remove(ph);
                break;
            }
        }

        notify();

    }
}
