package algorithms.chandymisra;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import simulation.DiningTable;

public class ChandyMisraPhilosopher extends AbstractPhilosopher {
    public ChandyMisraPhilosopher(int id, AbstractChopstick leftFork, AbstractChopstick rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }
}
