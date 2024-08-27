package algorithms.token.singletoken;

public class GlobalToken {

    public GlobalToken(int id, TokenPhilosopher philosopher){
        this.id = id;
        this.philosopher = philosopher;
    }


    protected synchronized void passToken(){
        philosopher.rightPhilosopher.acceptToken(this);
        philosopher.token = null;
        philosopher = philosopher.rightPhilosopher;
    }

    int id;
    TokenPhilosopher philosopher;

}
