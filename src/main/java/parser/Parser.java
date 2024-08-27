package parser;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import algorithms.AbstractPhilosopher;

import simulation.*;

public class Parser {

    private static int maxLength = 0;



    public static String parse(List<AbstractPhilosopher> philosophers){
        maxLength = 0;
        List<Statistic> statistics = new ArrayList<>();
        List<String> timelines = new ArrayList<>();
        StringBuilder sb = new StringBuilder();

        for(AbstractPhilosopher ph: philosophers){
            StringBuilder strb = new StringBuilder();

            Statistic statistic = new Statistic();
            statistic.setId("  PH_" + ph.getPhId());
            statistics.add(statistic);
            strb.append("PH_" + ph.getPhId() + " ");
            strb.append(parsePhilosopher(ph.getSB().toString(), statistic));
            timelines.add(strb.toString());
            //sb.append("\n");
        }

        for(AbstractPhilosopher ph: philosophers){
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(timelines.get(ph.getPhId()));

            for(int i = statistics.get(ph.getPhId()).getFinishLength() ; i < maxLength; i++) {
                switch(statistics.get(ph.getPhId()).getLast()){
                    case Events.EAT, Events.PICKUPLEFT, Events.THINK:
                        stringBuilder.append(Events.BLOCKED);
                        statistics.get(ph.getPhId()).incrementBlockTime();
                        break;
                    case Events.PICKUPRIGHT:
                        stringBuilder.append(Events.EAT);
                        statistics.get(ph.getPhId()).incrementEatTime();
                        break;
                    case Events.PUTDOWNLEFT, Events.PUTDOWNRIGHT:
                        stringBuilder.append(Events.THINK);
                        statistics.get(ph.getPhId()).incrementThinkTime();

                }

            }
            stringBuilder.append("\n");
            timelines.set(ph.getPhId(), stringBuilder.toString());
        }

        for(String timeline: timelines){
            sb.append(timeline);
        }



        sb.append("------------------------------------Statistics------------------------------------\n");

        Statistic global = new Statistic();
        global.setId("Global");

        boolean deadlock = true;

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

    private static String parsePhilosopher(String timeline, Statistic statistic){
        String id;
        List<String> sb = new ArrayList<>();

        String[] events = timeline.split("\n");
        int time = 0;

        for (String event : events) {
            if (!event.trim().isEmpty()) {
                String[] parts = event.split(":");
                String idPart = parts[0].trim();
                String action = parts[1].trim();
                int endTime = Integer.parseInt(parts[2].trim());

                switch (action) {
                    case Events.THINK:
                        while (time <= endTime) {
                            sb.add(Events.THINK);
                            time++;

                            statistic.incrementThinkTime();

                        }
                        break;

                    case Events.PICKUPLEFT:
                        int blockedpul = 0;
                        while (time < endTime) {
                            time++;
                            sb.add(Events.BLOCKED);

                            statistic.incrementBlockTime();

                            blockedpul++;
                        }

                        statistic.incrementMaxBlockedTime(blockedpul);

                        sb.add(Events.PICKUPLEFT);
                        time++;
                        break;

                    case Events.PICKUPRIGHT:
                        int blockedpur = 0;
                        while (time < endTime) {
                            time++;
                            sb.add(Events.BLOCKED);

                            statistic.incrementBlockTime();

                            blockedpur++;
                        }

                        statistic.incrementMaxBlockedTime(blockedpur);

                        sb.add(Events.PICKUPRIGHT);
                        time++;
                        break;

                    case Events.EAT:
                        while (time <= endTime) {
                            sb.add(Events.EAT);
                            time++;

                            statistic.incrementEatTime();

                        }
                        break;

                    case Events.PUTDOWNLEFT:
                        int blockedpdl = 0;
                        while (time < endTime) {
                            time++;
                            sb.add(Events.BLOCKED);
                            statistic.incrementBlockTime();
                        }
                        statistic.incrementMaxBlockedTime(blockedpdl);
                        sb.add(Events.PUTDOWNLEFT);
                        time++;
                        break;

                    case Events.PUTDOWNRIGHT:
                        int blockedpdr = 0;

                        while (time < endTime) {
                            sb.add(Events.BLOCKED);
                            time++;

                            statistic.incrementBlockTime();

                            blockedpdr++;
                        }
                        statistic.incrementMaxBlockedTime(blockedpdr);

                        sb.add(Events.PUTDOWNRIGHT);
                        time++;
                        break;

                    default:
                        sb.add("[ERR]");
                        break;
                }



            }
        }

        if(sb.size() > maxLength) maxLength = sb.size(); //determine the maximum length of the timelines
        statistic.setFinishLength(sb.size());

        statistic.setLast(sb.get(sb.size() - 1)); //set Last element for deadlock detection

        String result = sb.stream().collect(Collectors.joining(""));
        return result;
    }
}



