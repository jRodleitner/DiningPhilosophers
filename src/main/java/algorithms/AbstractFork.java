package algorithms;


public abstract class AbstractFork {

    protected final int id;
    protected boolean isAvailable = true;


    public AbstractFork(int id) {
        this.id = id;
    }

    public Integer getId(){
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
        AbstractFork that = (AbstractFork) o;
        return id == that.id;
    }

}
