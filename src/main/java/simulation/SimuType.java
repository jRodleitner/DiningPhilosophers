package simulation;

public class SimuType {
    private static boolean simulatePickups;

    public static String Simulationtype;

    public static void setSimulatePickups(boolean simulatePickups) {
        SimuType.simulatePickups = simulatePickups;
        if(simulatePickups){
            Simulationtype = "Simulate Pickups";
        } else {
            Simulationtype = "Simple";
        }
    }

    public static  boolean getSimulatePickups() {
        return simulatePickups;
    }
}
