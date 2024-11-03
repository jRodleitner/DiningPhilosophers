package simulation;

import java.util.List;

public class Algorithm {
    public static final String NAIVE = "NAIVE"; //0
    public static final String ASYMMETRIC = "ASYMMETRIC"; //1
    public static final String HIERARCHY = "HIERARCHY";  //2

    public static final String GLOBALTOKEN = "GLOBALTOKEN";  //3

    public static final String MULTIPLETOKEN = "MULTIPLETOKEN"; //4

    public static final String TIMEOUT = "TIMEOUT";  //5

    public static final String RESTRICTWAITER = "RESTRICTWAITER";

    public static final String ATOMICWAITER = "ATOMICWAITER";  //6

    public static final String PICKUPWAITER = "PICKUPWAITER";//7

    public static final String INTELLIGENTWAITER = "INTELLIGENTWAITER";

    public static final String FAIREATTIMEWAITER = "FAIR_EATTIME_WAITER";

    public static final String FAIRCHANCEWAITER = "FAIR_CHANCE_WAITER";//8

    public static final String TWOWAITERS = "TWOWAITERS"; //9

    public static final String TABLESEMAPHORE = "TABLESEMAPHORE";   //10

    public static final String INSTANTTIMEOUT = "INSTANTTIMEOUT";//12

    public static final String TANENBAUM = "TANENBAUM"; //13

    public static final String FAIRTIMETANENBAUM = "FAIR_TIME_TANENBAUM"; //14

    public static final String FAIRCHANCETANENBAUM = "FAIR_CHANCE_TANENBAUM";

    public static final String RESTRICT = "RESTRICT"; //15

    public static final String CHANDYMISRA = "CHANDYMISRA"; //16

    public static final String RESTRICTTOKENCHANCE = "CHANCE_RESTRICT_TOKEN";

    public static final String RESTRICTTOKENTIME = "TIME_RESTRICT_TOKEN";


    public static final List<String> ALL_ALGORITHMS = List.of(
            NAIVE,
            ASYMMETRIC,
            HIERARCHY,
            GLOBALTOKEN,
            MULTIPLETOKEN,
            TIMEOUT,
            RESTRICTWAITER,
            ATOMICWAITER,
            PICKUPWAITER,
            INTELLIGENTWAITER,
            FAIREATTIMEWAITER,
            FAIRCHANCEWAITER,
            TWOWAITERS,
            TABLESEMAPHORE,
            INSTANTTIMEOUT,
            TANENBAUM,
            FAIRTIMETANENBAUM,
            FAIRCHANCETANENBAUM,
            RESTRICT,
            CHANDYMISRA,
            RESTRICTTOKENCHANCE,
            RESTRICTTOKENTIME
    );




}
