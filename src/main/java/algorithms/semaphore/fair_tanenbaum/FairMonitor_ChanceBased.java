package algorithms.semaphore.fair_tanenbaum;

import parser.Events;
import java.util.Arrays;
import java.util.Comparator;

import java.util.concurrent.Semaphore;

public class FairMonitor_ChanceBased {
    private final String[] states;
    protected Semaphore[] semaphores;
    private final int[] eatChances;
    Semaphore mutex;

    public FairMonitor_ChanceBased(int nrPhilosophers) {
        eatChances = new int[nrPhilosophers];
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

    protected void updateEatTime(int id){
        eatChances[id]++;
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
        EatTimeWithIndex[] sortArray = new EatTimeWithIndex[eatChances.length];
        for (int i = 0; i < eatChances.length; i++) {
            sortArray[i] = new EatTimeWithIndex(eatChances[i], i);
        }

        Arrays.sort(sortArray, Comparator.comparingInt(e -> e.eatChances));

        int[] sortedIndices = new int[eatChances.length];

        for (int i = 0; i < sortArray.length; i++) {
            sortedIndices[i] = sortArray[i].index;
        }
        return sortedIndices;
    }

    private static class EatTimeWithIndex{
        int eatChances;
        int index;
        public EatTimeWithIndex(int eatChances, int index){
            this.eatChances = eatChances;
            this.index = index;
        }
    }
}
