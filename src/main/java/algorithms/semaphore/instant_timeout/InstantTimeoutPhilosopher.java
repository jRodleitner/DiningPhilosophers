package algorithms.semaphore.instant_timeout;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;
import algorithms.Distribution;
import parser.Events;
import simulation.DiningTable;

public class InstantTimeoutPhilosopher extends AbstractPhilosopher {
    public InstantTimeoutPhilosopher(int id, AbstractChopstick leftChopstick, AbstractChopstick rightChopstick, DiningTable table, Distribution thinkistr, Distribution eatDistr) {
        super(id, leftChopstick, rightChopstick, table, thinkistr, eatDistr);
    }

    @Override
    public void run() {
        try {
            while (!isInterrupted()) {
                think();
                boolean bothSuccessful = false;
                while (!bothSuccessful) {
                    boolean firstSuccessful = pickUpLeftChopstickDijkstra();
                    //System.out.println("id:" + id +" first: " + firstSuccessful + " " + table.getCurrentTime());
                    if (firstSuccessful) {
                        boolean secondSuccessful = pickUpRightChopstickDijkstra();
                        //System.out.println("id:" + id +" second:  " + secondSuccsessful + " " + table.getCurrentTime());
                        if (secondSuccessful) {
                            bothSuccessful = true;
                            eat();
                        } else {
                            putDownLeftChopstick();
                            int random = (int) (Math.random() * 25) + 1;
                            Thread.sleep(random);
                        }
                    } else {
                        int random = (int) (Math.random() * 25) + 1;
                        Thread.sleep(random);
                    }
                }

                putDownLeftChopstick();
                putDownRightChopstick();
            }
        } catch (InterruptedException e) {
            table.unlockClock();
            Thread.currentThread().interrupt();
        }
    }

    protected boolean pickUpLeftChopstickDijkstra() throws InterruptedException {
        boolean successful = leftChopstick.pickUp(this);
        if (successful) {
            if (simulatePickups) {
                table.lockClock();
                table.advanceTime();
                sbLog(id, Events.PICKUPLEFT, table.getCurrentTime());
                table.unlockClock();
            }
            pickedUp++;
            lastAction = Events.PICKUPLEFT;
            return true;
        } else return false;
    }

    protected boolean pickUpRightChopstickDijkstra() throws InterruptedException {
        boolean successful = rightChopstick.pickUp(this);
        if (successful) {
            if (simulatePickups) {
                table.lockClock();
                table.advanceTime();
                sbLog(id, Events.PICKUPRIGHT, table.getCurrentTime());
                table.unlockClock();
            }
            pickedUp++;
            lastAction = Events.PICKUPRIGHT;
            return true;
        } else return false;
    }


}
