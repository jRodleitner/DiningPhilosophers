package algorithms.semaphore.fair_tanenbaum;

import parser.Events;

import java.util.Arrays;
import java.util.Comparator;
import java.util.concurrent.Semaphore;


public class FairMonitor_TimeBased {
    private final String[] states;
    protected Semaphore[] semaphores;
    private final long[] eatTimes;
    Semaphore mutex;

    public FairMonitor_TimeBased(int nrPhilosophers) {
        eatTimes = new long[nrPhilosophers];
        states = new String[nrPhilosophers];
        semaphores = new Semaphore[nrPhilosophers];
        for (int i = 0; i < nrPhilosophers; i++) {
            states[i] = Events.THINK;
            semaphores[i] = new Semaphore(0, true);
        }
        mutex = new Semaphore(1, true);
    }

    public void test(int id) {
        int left = (id + states.length - 1) % states.length;
        int right = (id + 1) % states.length;

        if (states[id].equals(Events.HUNGRY) &&
                !states[left].equals(Events.EAT) &&
                !states[right].equals(Events.EAT)) {

            states[id] = Events.EAT;
            semaphores[id].release();
        }
    }

    protected void updateEatTime(int id, long eatTime){
        eatTimes[id]+= eatTime;
    }

    protected void updateState(int id, String state){
        states[id] = state;
    }

    protected void checkAll(){
        int[] sortedIndices = sortByEatingTimes();
        for (int j : sortedIndices) {
            test(j);
        }
    }

    private int[] sortByEatingTimes(){
        EatTimeWithIndex[] sortArray = new EatTimeWithIndex[eatTimes.length];
        for (int i = 0; i < eatTimes.length; i++) {
            sortArray[i] = new EatTimeWithIndex(eatTimes[i], i);
        }

        Arrays.sort(sortArray, Comparator.comparingLong(e -> e.eatTime));

        int[] sortedIndices = new int[eatTimes.length];

        for (int i = 0; i < sortArray.length; i++) {
            sortedIndices[i] = sortArray[i].index;
        }
        return sortedIndices;
    }

    private static class EatTimeWithIndex{
        long eatTime;
        int index;
        public EatTimeWithIndex(long eatTime, int index){
            this.eatTime = eatTime;
            this.index = index;
        }
    }
}
