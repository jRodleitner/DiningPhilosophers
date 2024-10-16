package algorithms.waiter.classic;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ClassicWaiter {

    private int forksOnTable;
    private final Lock lock = new ReentrantLock(true); // Fair lock (enabled by true flag)
    private final Condition enoughForks = lock.newCondition();

    public ClassicWaiter(int nrPhilosophers) {
        forksOnTable = nrPhilosophers;
    }

    protected void requestPermission() throws InterruptedException {
        lock.lock();
        try {
            while (forksOnTable < 2) {
                enoughForks.await(); // Wait for enough forks
            }
            forksOnTable -= 2;
        } finally {
            lock.unlock();
        }
    }

    protected void returnForks() {
        lock.lock();
        try {
            forksOnTable += 2;
        } finally {
            enoughForks.signalAll();
            lock.unlock();
        }
    }
}
