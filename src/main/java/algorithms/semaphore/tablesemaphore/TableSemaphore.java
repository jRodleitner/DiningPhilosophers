package algorithms.semaphore.tablesemaphore;

import java.util.concurrent.Semaphore;

public class TableSemaphore {
    protected Semaphore semaphore;

    public TableSemaphore(){
        semaphore = new Semaphore(1);
    }
}
