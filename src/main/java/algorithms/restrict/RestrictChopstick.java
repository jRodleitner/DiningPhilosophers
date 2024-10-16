package algorithms.restrict;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;

public class RestrictChopstick extends AbstractChopstick {

    private Restrict restrict;


    public RestrictChopstick(int id, Restrict restrict) {
        super(id);
        this.restrict = restrict;
    }

    @Override
    public synchronized boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {
        while (!isAvailable || philosopher.getPhId() == restrict.getRestricted() ) {
            //if(philosopher.getPhId() == restrict.getRestricted()) System.out.println("gotRestricted:" + philosopher.getPhId());
            wait();
        }
        if(this.equals( philosopher.getRightChopstick())){
            restrict.updateRestricted();
            //System.out.println("Restrict updated to:" + restrict.getRestricted());
        }
        isAvailable = false;

        return true;
    }


}
