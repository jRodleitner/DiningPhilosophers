package simulation;

public class SimuType {
    private final boolean simulatePickups;
    private final boolean animate;

    public final String simulationType;

    public SimuType(boolean simulatePickups, boolean animate) {
        this.simulatePickups = simulatePickups;
        this.animate = animate;
        if (simulatePickups) {
            simulationType = "Simulate Pickups";
        } else {
            simulationType = "Simple";
        }
    }


    public boolean getSimulatePickups() {
        return simulatePickups;
    }

    public boolean getAnimate() {
        return animate;
    }
}
