package algorithms.semaphore.tanenbaum;

import parser.Events;

import java.util.concurrent.Semaphore;

public class Monitor {
    protected String[] states;
    protected Semaphore[] semaphores;
    Semaphore mutex;

    public Monitor(int nrPhilosophers) {
        states = new String[nrPhilosophers];
        semaphores = new Semaphore[nrPhilosophers];
        for (int i = 0; i < nrPhilosophers; i++) {
            states[i] = Events.THINK;
            semaphores[i] = new Semaphore(0);
        }
        mutex = new Semaphore(1);
    }

    public void test(int id) {
        int left = (id + states.length - 1) % states.length;
        int right = (id + 1) % states.length;

        if (states[id].equals(Events.BLOCKED) &&
                !states[left].equals(Events.EAT) &&
                !states[right].equals(Events.EAT)) {

            states[id] = Events.EAT;
            semaphores[id].release();
        }
    }
}

