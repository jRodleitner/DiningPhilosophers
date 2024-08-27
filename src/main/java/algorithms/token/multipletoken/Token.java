package algorithms.token.multipletoken;

public class Token {
    int id;
    MultipleTokenPhilosopher philosopher;
    public Token(int id, MultipleTokenPhilosopher philosopher){
        this.id = id;
        this.philosopher = philosopher;
    }


    protected synchronized void passToken() throws InterruptedException {
        while (philosopher.rightPhilosopher.token != null){
            Thread.sleep(10);
        }
        philosopher.rightPhilosopher.acceptToken(this);
        philosopher.token = null;
        philosopher = philosopher.rightPhilosopher;
    }


}
