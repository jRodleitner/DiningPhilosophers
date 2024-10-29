package algorithms;


public abstract class AbstractChopstick {

    protected final int id;
    protected boolean isAvailable = true;


    public AbstractChopstick(int id) {
        this.id = id;
    }

    public int getId(){
        return id;
    }

    public synchronized boolean pickUp(AbstractPhilosopher philosopher) throws InterruptedException {
        while (!isAvailable) {
            wait();
        }
        isAvailable = false;
        return true;
    }

    public synchronized void putDown(AbstractPhilosopher philosopher) {
        isAvailable = true;
        notify();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AbstractChopstick that = (AbstractChopstick) o;
        return id == that.id;
    }

}
