package parser;

public class Statistic {
    private int totalThinkTime;
    private int totalBlockTime;
    private int totalEatTime;
    private int maxBlockedTime;
    private String id;
    private String last;
    private int eatChances;

    public void setLast(String last){
        this.last = last;
    }


    public String getLast(){
        return last;
    }

    public int getTotalThinkTime() {
        return totalThinkTime;
    }

    public int getTotalBlockTime() {
        return totalBlockTime;
    }

    public int getTotalEatTime() {
        return totalEatTime;
    }

    public int getMaxBlockedTime() {
        return maxBlockedTime;
    }

    public void incrementEatChances(){
        eatChances++;
    }

    public int getEatChances(){
        return eatChances;
    }


    public void setId(String id) {
        this.id = id;
    }


    public void incrementThinkTime() {
        totalThinkTime++;
    }

    public void addAll(int thinkTime, int eatTime, int blockTime, int eatChances) {
        this.totalThinkTime += thinkTime;
        this.totalEatTime += eatTime;
        this.totalBlockTime += blockTime;
        this.eatChances += eatChances;
    }

    public void incrementBlockTime() {
        totalBlockTime++;
    }

    public void incrementEatTime() {
        totalEatTime++;
    }


    public void incrementMaxBlockedTime(int blockedTime) {
        if (blockedTime > maxBlockedTime) maxBlockedTime = blockedTime;
    }


    private int finishLength;
    public void setFinishLength(int length){
        finishLength = length;
    }

    public int getFinishLength(){
        return finishLength;
    }

    @Override
    public String toString() {
        return id + ": {" +
                "totalThinkTime=" + totalThinkTime +
                ", totalBlockTime=" + totalBlockTime +
                ", totalEatTime=" + totalEatTime +
                ", maxBlockedTime=" + maxBlockedTime +
                ", eatChances=" + eatChances +
                '}';
    }
}



