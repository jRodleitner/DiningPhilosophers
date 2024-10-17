package algorithms;

import java.util.Random;
public class Distribution {

    public final String distributionType;
    private final double firstPar;
    private final double secondPar;

    public Distribution(String distributionType, double firstPar, double secondPar) {
        this.distributionType = distributionType;
        this.firstPar = firstPar;
        this.secondPar = secondPar;
    }

    public static final String DETERMINISTIC = "DETERMINISTIC";
    public static final String NORMAL = "NORMAL";

    public static final String EXP = "EXP";

    public static final String INTERVAL  = "INTERVAL";


    public long calculateDuration(){
        long duration = 0;
        switch(distributionType){
            case DETERMINISTIC:
                duration = (long) firstPar;
                break;
            case NORMAL:
                duration = normalDistributionDuration(firstPar, secondPar);
                break;
            case EXP:
                duration = exponentialDistributionDuration(firstPar);
                break;
            case INTERVAL:
                duration = intervalDistributionDuration(firstPar, secondPar);
                break;
        }

        return duration;
    }

    private static Random random = new Random();

    public static long normalDistributionDuration(double mu, double sigma) {
        long result = (long) (mu + sigma * random.nextGaussian());
        if(result > 400) result = 400;
        if(result < 30) result = 30;
        return result;
    }

    public static long exponentialDistributionDuration(double lambda) {

        double u = random.nextDouble();
        long result = (long) (-Math.log(u) / lambda * 1000);
        if(result > 400) result = 400;
        if(result < 30) result = 30;
        return result;
    }

    public static long intervalDistributionDuration(double lowerBound, double upperBound) {
        return (long) (lowerBound + (upperBound - lowerBound) * random.nextDouble());
    }
}
