package algorithms.restrict;

import algorithms.AbstractFork;
import algorithms.AbstractPhilosopher;
import simulation.DiningTable;

public class RestrictFork extends AbstractFork {

    private Restrict restrict;


    public RestrictFork(int id, Restrict restrict) {
        super(id);
        this.restrict = restrict;
    }

    @Override
    public synchronized boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {
        while (!isAvailable || philosopher.getPhId() == restrict.getRestricted() ) {
            //if(philosopher.getPhId() == restrict.getRestricted()) System.out.println("gotRestricted:" + philosopher.getPhId());
            wait();
        }
        if(this.equals( philosopher.getRightFork())){
            restrict.updateRestricted();
            //System.out.println("Restrict updated to:" + restrict.getRestricted());
        }
        isAvailable = false;

        return true;
    }


}
