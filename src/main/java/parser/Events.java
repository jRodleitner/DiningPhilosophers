package parser;

import java.util.ArrayList;
import java.util.Arrays;

public class Events {

    public static final String THINK = "[ T ]";
    public static final String EAT = "[ E ]";

    public static final String HUNGRY = "[ H ]";

    public static final String BLOCKED = "[ B ]";
    public static final String PICKUPRIGHT = "[PUR]";
    public static final String PICKUPLEFT = "[PUL]";

    public static final String PUTDOWNLEFT = "[PDL]";

    public static final String PUTDOWNRIGHT = "[PDR]";

    public static final  String PICKUP = "[PUB]";

    public static final String EMPTY = "[   ]";

    public static final String BLOCKEDLR = "[BLR]";
    public static final String BLOCKEDL = "[BL ]";
    public static final String BLOCKEDR = "[BR ]";
    public static final String EMPTYLR = "[LR ]";
    public static final String EMPTYL = "[L  ]";
    public static final String EMPTYR = "[R  ]";

    public static final ArrayList<String> PICKUPSET = new ArrayList<>(Arrays.asList("[PUR]", "[PUL]", "[PDL]", "[PDR]"));
    public static final ArrayList<String> REMOVESET = new ArrayList<>(Arrays.asList("[ E ]", "[ B ]", "[ T ]" ));
}
