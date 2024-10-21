package algorithms.restrict;

import algorithms.AbstractChopstick;
import algorithms.AbstractPhilosopher;

public class RestrictChopstick extends AbstractChopstick {

    private final Restrict restrict;


    public RestrictChopstick(int id, Restrict restrict) {
        super(id);
        this.restrict = restrict;
    }

    @Override
    public synchronized boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {
        while (!isAvailable || philosopher.getPhId() == restrict.getRestricted() ) {
            wait();
        }
        if(this.equals( philosopher.getRightChopstick())){
            restrict.updateRestricted();
        }
        isAvailable = false;

        return true;
    }


}
