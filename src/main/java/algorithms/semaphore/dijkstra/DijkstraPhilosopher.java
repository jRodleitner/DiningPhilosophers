package algorithms.semaphore.dijkstra;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class DijkstraPhilosopher extends AbstractPhilosopher {
    public DijkstraPhilosopher(int id, AbstractFork leftFork, AbstractFork rightFork, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftFork, rightFork, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                boolean bothSuccessful = false;
                while(!bothSuccessful){
                    boolean firstSuccessful = pickUpLeftForkDijkstra();
                    //System.out.println("id:" + id +" first: " + firstSuccessful + " " + table.getCurrentTime());
                    if(firstSuccessful){
                        boolean secondSuccsessful = pickUpRightForkDijkstra();
                        //System.out.println("id:" + id +" second:  " + secondSuccsessful + " " + table.getCurrentTime());
                        if(secondSuccsessful){
                            bothSuccessful = true;
                            eat();
                        } else {
                            putDownLeftFork();
                            int random = (int) (Math.random() * 100) + 1;
                            Thread.sleep(random);
                        }
                    } else {
                        int random = (int) (Math.random() * 100) + 1;
                        Thread.sleep(random);
                    }
                }

                putDownLeftFork();
                putDownRightFork();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    protected boolean pickUpLeftForkDijkstra() throws InterruptedException {
        boolean successful = leftFork.pickUp(this);
        if(successful) {
            table.advanceTime();
            sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
            return true;
        } else return false;
    }

    protected boolean pickUpRightForkDijkstra() throws InterruptedException {
        boolean successful = rightFork.pickUp(this);
        if(successful) {
            table.advanceTime();
            sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
            return true;
        } else return false;
    }




}
