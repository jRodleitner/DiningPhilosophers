package algorithms.waiter.classic;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class RestrictWaiter {

    private int chopsticksOnTable;
    private final Lock lock = new ReentrantLock(true); // Fair lock (enabled by true flag)
    private final Condition enoughChopsticks = lock.newCondition();

    public RestrictWaiter(int nrPhilosophers) {
        chopsticksOnTable = nrPhilosophers;
    }

    protected void requestPermission() throws InterruptedException {
        lock.lock();
        try {
            while (chopsticksOnTable < 2) {
                enoughChopsticks.await();
            }
            chopsticksOnTable -= 2;
        } finally {
            lock.unlock();
        }
    }


    protected void returnForks() {
        lock.lock();
        try {
            chopsticksOnTable += 2;
        } finally {
            enoughChopsticks.signalAll();
            lock.unlock();
        }
    }
}
