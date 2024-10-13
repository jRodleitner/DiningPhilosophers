package algorithms.token.singletoken;

public class GlobalToken {

    TokenPhilosopher philosopher;

    public GlobalToken(TokenPhilosopher philosopher){
        this.philosopher = philosopher;
    }


    protected synchronized void passToken(){
        philosopher.rightPhilosopher.acceptToken(this);
        philosopher.token = null;
        philosopher = philosopher.rightPhilosopher;
    }


}
