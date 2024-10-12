package algorithms.restrict;

public class Restrict {
    private int restrict;
    private final int numberOfPhilosophers;

    public Restrict(int numberOfPhilosophers){
        restrict = 0;
        this.numberOfPhilosophers = numberOfPhilosophers;
    }

    public synchronized void updateRestricted(){
        restrict = (restrict + 1) % numberOfPhilosophers;
    }

    public synchronized int getRestricted(){
        return restrict;
    }
}
