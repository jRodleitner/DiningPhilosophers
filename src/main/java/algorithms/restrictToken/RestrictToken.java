package algorithms.restrictToken;

public class RestrictToken {
    private int restrictId;


    public RestrictToken(){
        restrictId = 0;

    }



    public synchronized void waitIfRestricted(int id) throws InterruptedException {
        while(restrictId == id){
            wait();
        }

    }

    public synchronized void updateRestricted(int id){
        restrictId = id;
        notifyAll();
    }
}
