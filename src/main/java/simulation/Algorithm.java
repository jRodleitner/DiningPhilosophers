package simulation;

import java.util.List;

public class Algorithm {
    public static final String NAIVE = "NAIVE";

    public static final String ASYMMETRIC = "ASYMMETRIC";

    public static final String HIERARCHY = "HIERARCHY";

    public static final String GLOBALTOKEN = "GLOBALTOKEN";

    public static final String MULTIPLETOKEN = "MULTIPLETOKEN";

    public static final String TIMEOUT = "TIMEOUT";

    public static final String RESTRICTWAITER = "RESTRICTWAITER";

    public static final String ATOMICWAITER = "ATOMICWAITER";

    public static final String PICKUPWAITER = "PICKUPWAITER";

    public static final String INTELLIGENTWAITER = "INTELLIGENTWAITER";

    public static final String FAIREATTIMEWAITER = "FAIR_EATTIME_WAITER";

    public static final String FAIRCHANCEWAITER = "FAIR_CHANCE_WAITER";

    public static final String TWOWAITERS = "TWOWAITERS";

    public static final String TABLESEMAPHORE = "TABLESEMAPHORE";

    public static final String INSTANTTIMEOUT = "INSTANTTIMEOUT";

    public static final String TANENBAUM = "TANENBAUM";

    public static final String FAIRTIMETANENBAUM = "FAIR_TIME_TANENBAUM";

    public static final String FAIRCHANCETANENBAUM = "FAIR_CHANCE_TANENBAUM";

    public static final String RESTRICT = "RESTRICT";

    public static final String CHANDYMISRA = "CHANDYMISRA";

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
