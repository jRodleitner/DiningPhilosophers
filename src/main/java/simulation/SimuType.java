package simulation;

public class SimuType {
    private static boolean simulatePickups;

    public static void setSimulatePickups(boolean simulatePickups) {
        SimuType.simulatePickups = simulatePickups;
    }

    public static  boolean getSimulatePickups() {
        return simulatePickups;
    }
}
