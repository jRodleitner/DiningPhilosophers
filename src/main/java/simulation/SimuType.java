package simulation;

public class SimuType {
    private static boolean simulatePickups;
    private static boolean animate;

    public static String Simulationtype;

    protected static void setSimulatePickups(boolean simulatePickups, boolean animate) {
        SimuType.simulatePickups = simulatePickups;
        SimuType.animate = animate;
        if(simulatePickups){
            Simulationtype = "Simulate Pickups";
        } else {
            Simulationtype = "Simple";
        }
    }

    public static  boolean getSimulatePickups() {
        return simulatePickups;
    }

    public static boolean getAnimate() {
        return animate;
    }
}
