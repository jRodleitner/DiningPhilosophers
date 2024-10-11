package parser;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import algorithms.AbstractPhilosopher;
import simulation.DiningTable;

public class Parser {

    //private static int maxLength = 0;



    public static String parse(List<AbstractPhilosopher> philosophers, DiningTable table){
        AtomicInteger maxLength = new AtomicInteger(0);
        AtomicInteger nrPickups = new AtomicInteger(0);
        List<Statistic> statistics = new ArrayList<>();
        List<List<String>> timelines = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean simulatePickups = table.getSimuType().getSimulatePickups();
        boolean animate = table.getSimuType().getAnimate();

        for(AbstractPhilosopher ph: philosophers){
            List<String> timeline = new ArrayList<>();

            Statistic statistic = new Statistic();
            statistic.setId("  PH_" + ph.getPhId());
            statistics.add(statistic);

            timeline.add("PH_" + ph.getPhId() + " ");

            if(simulatePickups){
                timeline.addAll(parsePhilosopherWithPickups(ph.getSB().toString(), statistic, maxLength));
            } else {
                timeline.addAll(parsePhilosopher(ph.getSB().toString(), statistic, maxLength));
            }

            timelines.add(timeline);
        }

        fillIn(philosophers, timelines, statistics, maxLength, simulatePickups);
        fillStatistics(timelines, statistics, nrPickups);
        timelines.add(generateTimeIndices(maxLength.get()));
        //TODO explain

        for(List<String> timeline: timelines){
            sb.append(String.join("", timeline));
        }

        if(animate) {
            StringBuilder animationSB = new StringBuilder();
            parseAnimation(timelines);
            for(List<String> timeline: timelines){
                animationSB.append(String.join("", timeline));
            }
            table.getAnimation().setAnimationString(animationSB.toString());
        }

        sb.append("\n------------------------------------Statistics------------------------------------\n");

        Statistic global = new Statistic();
        global.setId("Global");

        boolean deadlock = true;
        for(AbstractPhilosopher ph: philosophers){
            if (!ph.getLastAction().equals(Events.PICKUPLEFT)) {
                deadlock = false;
                break;
            }
        }

        //TODO change deadlock check to last of philosopher
        ArrayList<Integer> phEatTimes = new ArrayList<>();
        ArrayList<Integer> phEatChances = new ArrayList<>();
        for(Statistic st: statistics){
            global.addAll(st.getTotalThinkTime(), st.getTotalEatTime(), st.getTotalBlockTime(), st.getEatChances());
            phEatTimes.add(st.getTotalEatTime());
            phEatChances.add(st.getEatChances());
            global.incrementMaxBlockedTime(st.getMaxBlockedTime());
            sb.append(st);
            sb.append("\n");
        }
        sb.append("\n").append(global).append("\n").append("\n");

        double denominator = simulatePickups ? (maxLength.get() - nrPickups.get()) : maxLength.get();
        sb.append("Concurrency: ").append(String.format("%.3f", ((double) global.getTotalEatTime() / denominator))).append(" (Values < 1 mean no concurrency)").append("\n");
        sb.append("Chance Fairness: ").append(String.format("%.5f", calculateStandardDeviation(phEatChances))).append(" (standard deviation of eat chances, the lower the better)").append("\n");
        sb.append("Eat Time Fairness: ").append(String.format("%.5f", calculateStandardDeviation(phEatTimes))).append(" (standard deviation of eat times, the lower the better)");


        if(deadlock) sb.append("\n\n A deadlock occurred!");
        return sb.toString();
    }

    private static double calculateStandardDeviation(List<Integer> values) {
        // Step 1: Calculate the mean
        double mean = calculateMean(values);

        // Step 2: Calculate the variance
        double variance = 0.0;
        for (int value : values) {
            variance += Math.pow(value - mean, 2);
        }
        variance /= values.size();

        // Step 3: Return the standard deviation
        return Math.sqrt(variance);
    }

    private static double calculateMean(List<Integer> values) {
        double sum = 0.0;
        for (int value : values) {
            sum += value;
        }
        return sum / values.size();
    }

    private static List<String> generateTimeIndices(int maxLength) {
        List<String> strings = new ArrayList<>();
        strings.add("TIME:");
        for (int i = 1; i <= maxLength; i++) {
            String numStr = Integer.toString(i);
            int paddingTotal = 5 - numStr.length(); // Calculate total padding needed
            int paddingLeft = paddingTotal / 2; // Left padding for centering
            int paddingRight = paddingTotal - paddingLeft; // Right padding

            // Add spaces on both sides to center the number
            String centeredStr = " ".repeat(paddingLeft) + numStr + " ".repeat(paddingRight);
            strings.add(centeredStr); // Add the centered string to the list
        }
        strings.add("\n");

        return strings;
    }

    private static void parseAnimation(List<List<String>> timelines){

        for(int philosopherIndex = 0; philosopherIndex < timelines.size(); philosopherIndex++){
            boolean left = false;
            boolean right = false;
            for(int timelineIndex = 0; timelineIndex < timelines.get(philosopherIndex).size(); timelineIndex++){
                String current = timelines.get(philosopherIndex).get(timelineIndex);
                switch(current){
                    case Events.PICKUPLEFT:
                        left = true;
                        break;

                    case Events.PICKUPRIGHT:
                        right = true;
                        break;

                    case Events.BLOCKED:
                        if(left & right) timelines.get(philosopherIndex).set(timelineIndex, Events.BLOCKEDLR);
                        else if(left & !right) timelines.get(philosopherIndex).set(timelineIndex, Events.BLOCKEDL);
                        else if(right) timelines.get(philosopherIndex).set(timelineIndex, Events.BLOCKEDR);
                        break;

                    case Events.EMPTY:
                        if(left & right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYLR);
                        else if (left & !right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYL);
                        else if (right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYR);
                        break;

                    case Events.PUTDOWNLEFT:
                        left = false;
                        break;

                    case Events.PUTDOWNRIGHT:
                        right = false;
                        break;

                }
            }

        }
    }

    private static void fillStatistics( List<List<String>> timelines, List<Statistic> statistics, AtomicInteger nrPickups){
        String[] lastSymbol = new String[timelines.size()];
        int[] blockedStreaks = new int[timelines.size()];

        for(int timeLineIndex = 0; timeLineIndex < timelines.getFirst().size(); timeLineIndex++){

            boolean pickupPoint = false;


            for(int philosopherIndex = 0; philosopherIndex < timelines.size(); philosopherIndex++){
                if(Events.PICKUPSET.contains(timelines.get(philosopherIndex).get(timeLineIndex))){
                    lastSymbol[philosopherIndex] = timelines.get(philosopherIndex).get(timeLineIndex);
                    pickupPoint = true;
                    nrPickups.incrementAndGet();
                }
            }

            if(pickupPoint){
                for(int philosopherIndex = 0; philosopherIndex < timelines.size(); philosopherIndex++){
                    if(Events.REMOVESET.contains(timelines.get(philosopherIndex).get(timeLineIndex))){
                        timelines.get(philosopherIndex).set(timeLineIndex, Events.EMPTY);
                    }
                }
            } else {
                for(int philosopherIndex = 0; philosopherIndex < timelines.size(); philosopherIndex++){
                    switch(timelines.get(philosopherIndex).get(timeLineIndex)){
                        case Events.THINK:
                            lastSymbol[philosopherIndex] = Events.THINK;
                            statistics.get(philosopherIndex).incrementThinkTime();
                            break;
                        case Events.EAT:
                            lastSymbol[philosopherIndex] = Events.EAT;
                            statistics.get(philosopherIndex).incrementEatTime();
                            break;

                        case Events.BLOCKED:
                            if(lastSymbol[philosopherIndex].equals(Events.BLOCKED)){
                                blockedStreaks[philosopherIndex]++;
                            } else {
                                blockedStreaks[philosopherIndex] = 1;
                            }
                            statistics.get(philosopherIndex).incrementMaxBlockedTime(blockedStreaks[philosopherIndex]);
                            lastSymbol[philosopherIndex] = Events.BLOCKED;
                            statistics.get(philosopherIndex).incrementBlockTime();
                            break;
                    }
                }
            }
        }

    }


    private static void fillIn(List<AbstractPhilosopher> philosophers, List<List<String>> timelines, List<Statistic> statistics, AtomicInteger maxLength, boolean simulatePickups) {
        for (AbstractPhilosopher ph : philosophers) {
            List<String> modifiedTimeline = new ArrayList<>(timelines.get(ph.getPhId()));

            String last = ph.getLastAction();
            int finishLength = statistics.get(ph.getPhId()).getFinishLength();
            String fillString = "";

            switch (last) {
                case Events.THINK:
                    fillString = Events.BLOCKED;
                    break;
                case Events.PICKUPLEFT, Events.PICKUPRIGHT:
                    if(ph.getPickedUp() == 2) fillString = Events.EAT;
                    else fillString = Events.BLOCKED;
                    break;

                    //TODO Events.Pickup removable????
                case Events.PICKUP:
                    fillString = Events.EAT;
                    break;

                case Events.PUTDOWNLEFT, Events.PUTDOWNRIGHT:
                    //TODO what if putdown not finished
                    fillString = Events.THINK;
                    break;
                case Events.EAT:
                    if(simulatePickups){
                        //TODO Events.Empty???
                        fillString = Events.BLOCKED;
                        ph.setPickedUp(0);
                    } else {
                        fillString = Events.THINK;
                    }
                    break;
            }
            for (int i = finishLength; i < maxLength.get(); i++) {
                modifiedTimeline.add(fillString);
            }

            modifiedTimeline.add("\n");
            timelines.set(ph.getPhId(), modifiedTimeline);
        }

    }

    private static List<String> parsePhilosopherWithPickups(String timeline, Statistic statistic, AtomicInteger maxLength){
        List<String> parsedTimeline = new ArrayList<>();

        String[] events = timeline.split("\n");
        int time = 0;

        for (String event : events) {
            if (!event.trim().isEmpty()) {
                String[] parts = event.split(":");
                String action = parts[1].trim();
                int endTime = Integer.parseInt(parts[2].trim());

                switch (action) {
                    case Events.THINK:
                        while (time <= endTime) {
                            parsedTimeline.add(Events.THINK);
                            time++;
                        }
                        break;

                    case Events.PICKUPLEFT:
                        while (time < endTime) {
                            time++;
                            parsedTimeline.add(Events.BLOCKED);
                        }
                        parsedTimeline.add(Events.PICKUPLEFT);
                        time++;
                        break;

                    case Events.PICKUPRIGHT:
                        while (time < endTime) {
                            time++;
                            parsedTimeline.add(Events.BLOCKED);
                        }
                        parsedTimeline.add(Events.PICKUPRIGHT);
                        time++;
                        break;

                    case Events.EAT:
                        statistic.incrementEatChances();
                        while (time <= endTime) {
                            parsedTimeline.add(Events.EAT);
                            time++;
                        }
                        break;

                    case Events.PUTDOWNLEFT:
                        while (time < endTime) {
                            time++;
                            parsedTimeline.add(Events.BLOCKED);
                        }
                        parsedTimeline.add(Events.PUTDOWNLEFT);
                        time++;
                        break;

                    case Events.PUTDOWNRIGHT:

                        while (time < endTime) {
                            parsedTimeline.add(Events.BLOCKED);
                            time++;

                        }
                        parsedTimeline.add(Events.PUTDOWNRIGHT);
                        time++;
                        break;

                    default:
                        parsedTimeline.add("[ERR]");
                        break;
                }
            }
        }

        if(parsedTimeline.size() > maxLength.get()) maxLength.set(parsedTimeline.size());  //determine the maximum length of the timelines
        statistic.setFinishLength(parsedTimeline.size());

        statistic.setLast(parsedTimeline.getLast()); //set Last element for deadlock detection
        return parsedTimeline;
    }


    private static List<String> parsePhilosopher(String timeline, Statistic statistic, AtomicInteger maxLength){
        List<String> parsedTimeline = new ArrayList<>();

        String[] events = timeline.split("\n");
        int time = 0;

        for (String event : events) {
            if (!event.trim().isEmpty()) {
                String[] parts = event.split(":");
                String action = parts[1].trim();
                int endTime = Integer.parseInt(parts[2].trim());

                switch (action) {
                    case Events.THINK:
                        while (time <= endTime) {
                            parsedTimeline.add(Events.THINK);
                            time++;
                        }
                        break;

                    case Events.PICKUP:
                        while (time < endTime) {
                            time++;
                            parsedTimeline.add(Events.BLOCKED);
                        }

                        parsedTimeline.add(Events.EAT);
                        time++;
                        break;


                    case Events.EAT:
                        statistic.incrementEatChances();
                        while (time <= endTime) {
                            parsedTimeline.add(Events.EAT);
                            time++;

                        }
                        break;


                    default:
                        parsedTimeline.add("[ERR]");
                        break;
                }



            }
        }

        if(parsedTimeline.size() > maxLength.get()) maxLength.set(parsedTimeline.size());  //determine the maximum length of the timelines
        statistic.setFinishLength(parsedTimeline.size());

        statistic.setLast(parsedTimeline.getLast()); //set Last element
        return parsedTimeline;
    }

}



