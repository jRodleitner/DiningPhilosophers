package algorithms.chandymisra;

import algorithms.AbstractChopstick;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ChandyMisraChopstick extends AbstractChopstick {

    volatile ChandyMisraPhilosopher owner;
    volatile boolean isClean = false;

    public ChandyMisraChopstick(int id) {
        super(id);

    }

    public void setOwner(ChandyMisraPhilosopher owner) {
        this.owner = owner;
    }
}

