package algorithms.semaphore.fair_tanenbaum;

import parser.Events;

import java.util.ArrayDeque;
import java.util.Queue;
import java.util.concurrent.Semaphore;

public class FairMonitor {
    protected String[] states;
    protected Semaphore[] semaphores;
    Semaphore mutex;
    Queue<Integer> hungryQueue; // Queue to track hungry philosophers

    public FairMonitor(int nrPhilosophers) {
        states = new String[nrPhilosophers];
        semaphores = new Semaphore[nrPhilosophers];
        for (int i = 0; i < nrPhilosophers; i++) {
            states[i] = Events.THINK;
            semaphores[i] = new Semaphore(0, true); // Start blocked
        }
        mutex = new Semaphore(1, true);
        hungryQueue = new ArrayDeque<>();
    }

    public synchronized void test(int id) {
        int left = (id + states.length - 1) % states.length;
        int right = (id + 1) % states.length;

        // Philosopher can eat if they are hungry, both neighbors are not eating, and they are next in the hungry queue
        if (states[id].equals(Events.BLOCKED) &&
                !states[left].equals(Events.EAT) &&
                !states[right].equals(Events.EAT) &&
                hungryQueue.peek() == id) {

            states[id] = Events.EAT; // Set state to Eating
            semaphores[id].release(); // Allow philosopher to eat
            hungryQueue.poll(); // Remove from the queue
        }
    }

    public synchronized void recheckHungryQueue() {
        // Recheck all philosophers in the hungry queue
        for (int id : hungryQueue) {
            test(id);
        }
    }
}
