package parser;

import java.util.ArrayList;
import java.util.List;
import algorithms.AbstractPhilosopher;
import simulation.SimuType;

public class Parser {

    private static int maxLength = 0;



    public static String parse(List<AbstractPhilosopher> philosophers){
        maxLength = 0;
        List<Statistic> statistics = new ArrayList<>();
        List<List<String>> timelines = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean simulatePickups = SimuType.getSimulatePickups();

        for(AbstractPhilosopher ph: philosophers){
            List<String> timeline = new ArrayList<>();

            Statistic statistic = new Statistic();
            statistic.setId("  PH_" + ph.getPhId());
            statistics.add(statistic);

            timeline.add("PH_" + ph.getPhId() + " ");

            if(simulatePickups){
                timeline.addAll(parsePhilosopherWithPickups(ph.getSB().toString(), statistic));
            } else {
                timeline.addAll(parsePhilosopher(ph.getSB().toString(), statistic));
            }

            timelines.add(timeline);
        }

        fillIn(philosophers, timelines, statistics);
        fillStatistics(timelines, statistics);

        //TODO create Boolean to set parameter
        parseAnimation(timelines);

        for(List<String> timeline: timelines){
            sb.append(String.join("", timeline));
        }

        sb.append("------------------------------------Statistics------------------------------------\n");

        Statistic global = new Statistic();
        global.setId("Global");

        boolean deadlock = true;

        //TODO change deadlock check to last of philosopher
        for(Statistic st: statistics){
            if(!st.getLast().equals(Events.PICKUPLEFT)) deadlock = false;
            global.addAll(st.getTotalThinkTime(), st.getTotalEatTime(), st.getTotalBlockTime());
            global.incrementMaxBlockedTime(st.getMaxBlockedTime());
            sb.append(st);
            sb.append("\n");
        }
        sb.append(global);
        if(deadlock) sb.append("\n\n A deadlock occurred!");
        return sb.toString();
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
                        else if(!left & right) timelines.get(philosopherIndex).set(timelineIndex, Events.BLOCKEDR);
                        break;

                    case Events.EMPTY:
                        if(left & right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYLR);
                        else if (left & !right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYL);
                        else if (!left & right) timelines.get(philosopherIndex).set(timelineIndex, Events.EMPTYR);
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

    private static void fillStatistics( List<List<String>> timelines, List<Statistic> statistics){
        String[] lastSymbol = new String[timelines.size()];
        int[] blockedStreaks = new int[timelines.size()];

        for(int timeLineIndex = 0; timeLineIndex < timelines.getFirst().size(); timeLineIndex++){

            boolean pickupPoint = false;


            for(int philosopherIndex = 0; philosopherIndex < timelines.size(); philosopherIndex++){
                if(Events.PICKUPSET.contains(timelines.get(philosopherIndex).get(timeLineIndex))){
                    lastSymbol[philosopherIndex] = timelines.get(philosopherIndex).get(timeLineIndex);
                    pickupPoint = true;
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


    private static void fillIn(List<AbstractPhilosopher> philosophers, List<List<String>> timelines, List<Statistic> statistics) {
        if(true) {
            for (AbstractPhilosopher ph : philosophers) {
                List<String> modifiedTimeline = new ArrayList<>(timelines.get(ph.getPhId()));

                String last = statistics.get(ph.getPhId()).getLast();
                int finishLength = statistics.get(ph.getPhId()).getFinishLength();

                for (int i = finishLength; i < maxLength; i++) {
                    switch (last) {
                        case Events.PICKUPLEFT, Events.THINK:
                            modifiedTimeline.add(Events.BLOCKED);
                            break;
                        case Events.PICKUPRIGHT, Events.PICKUP:
                            modifiedTimeline.add(Events.EAT);
                            break;
                        case Events.PUTDOWNLEFT, Events.PUTDOWNRIGHT, Events.EAT:
                            modifiedTimeline.add(Events.THINK);
                    }
                }

                modifiedTimeline.add("\n");
                timelines.set(ph.getPhId(), modifiedTimeline);
            }

        }
    }

    private static List<String> parsePhilosopherWithPickups(String timeline, Statistic statistic){
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

        if(parsedTimeline.size() > maxLength) maxLength = parsedTimeline.size(); //determine the maximum length of the timelines
        statistic.setFinishLength(parsedTimeline.size());

        statistic.setLast(parsedTimeline.getLast()); //set Last element for deadlock detection
        return parsedTimeline;
    }


    private static List<String> parsePhilosopher(String timeline, Statistic statistic){
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

        if(parsedTimeline.size() > maxLength) maxLength = parsedTimeline.size(); //determine the maximum length of the timelines
        statistic.setFinishLength(parsedTimeline.size());

        statistic.setLast(parsedTimeline.getLast()); //set Last element
        return parsedTimeline;
    }

}



