package simulation;

import algorithms.asymmetric.AsymmetricPhilosopher;
import algorithms.chandymisra.ChandyMisraChopstick;
import algorithms.chandymisra.ChandyMisraPhilosopher;
import algorithms.hierarchy.HierarchyPhilosopher;
import algorithms.SimpleChopstick;
import algorithms.naive.NaivePhilosopher;
import algorithms.restrict.Restrict;
import algorithms.restrict.RestrictChopstick;
import algorithms.restrict.RestrictPhilosopher;
import algorithms.semaphore.fair_tanenbaum.FairTimeMonitor;
import algorithms.semaphore.fair_tanenbaum.FairTimeTanenbaumPhilosopher;
import algorithms.semaphore.roundrobin.RoundRobinScheduler;
import algorithms.semaphore.roundrobin.RoundRobinChopstick;
import algorithms.semaphore.roundrobin.RoundRobinPhilosopher;
import algorithms.semaphore.dijkstra.DijkstraChopstick;
import algorithms.semaphore.dijkstra.DijkstraPhilosopher;
import algorithms.semaphore.tanenbaum.Monitor;
import algorithms.semaphore.tanenbaum.TanenbaumPhilosopher;
import algorithms.semaphore.fair_tanenbaum.FairChanceTanenbaumPhilosopher;
import algorithms.semaphore.fair_tanenbaum.FairChanceMonitor;
import algorithms.semaphore.tablesemaphore.TableSemaphore;
import algorithms.semaphore.tablesemaphore.TableSemaphorePhilosopher;
import algorithms.timeout.TimeoutChopstick;
import algorithms.timeout.TimeoutPhilosopher;
import algorithms.token.multipletoken.MultipleTokenPhilosopher;
import algorithms.token.multipletoken.Token;
import algorithms.token.singletoken.GlobalToken;
import algorithms.token.singletoken.TokenPhilosopher;
import algorithms.*;
import algorithms.waiter.classic.ClassicWaiter;
import algorithms.waiter.classic.GuestPhilosopher;
import algorithms.waiter.fairwaiter.FairChanceGuestPhilosopher;
import algorithms.waiter.fairwaiter.FairChanceWaiter;
import algorithms.waiter.fairwaiter.FairEatTimeGuestPhilosopher;
import algorithms.waiter.fairwaiter.FairEatTimeWaiter;
import algorithms.waiter.intelligent.IntelligentPickupGuestPhilosopher;
import algorithms.waiter.intelligent.IntelligentWaiter;
import algorithms.waiter.queuewaiter.AtomicGuestPhilosopher;
import algorithms.waiter.queuewaiter.PickupGuestPhilosopher;
import algorithms.waiter.queuewaiter.Waiter;
import parser.Animation;

import java.util.ArrayList;
import java.util.List;


public class DiningTable {
    protected final List<AbstractPhilosopher> philosophers;
    protected final List<AbstractChopstick> chopsticks;
    protected final VirtualClock clock = new VirtualClock();

    protected final int numberOfPhilosophers;
    protected final SimuType simuType;
    protected final Animation animation;

    public DiningTable(int nrPhilosophers, String algorithm, Distribution thinkDistr, Distribution eatDistr, int timeout, SimuType simuType, Animation animation) {

        philosophers = new ArrayList<>(nrPhilosophers);
        chopsticks = new ArrayList<>(nrPhilosophers);
        this.numberOfPhilosophers = nrPhilosophers;
        this.simuType = simuType;
        this.animation = animation;

        switch (algorithm) {
            case Algorithm.NAIVE:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    NaivePhilosopher philosopher = new NaivePhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ASYMMETRIC:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    AsymmetricPhilosopher philosopher = new AsymmetricPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.RESTRICT:
                Restrict restrict = new Restrict(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new RestrictChopstick(i, restrict));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    RestrictPhilosopher philosopher = new RestrictPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.HIERARCHY:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    HierarchyPhilosopher philosopher = new HierarchyPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.GLOBALTOKEN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    TokenPhilosopher philosopher = new TokenPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }

                for (int i = 0; i < nrPhilosophers; i++) {
                    TokenPhilosopher philosopher = (TokenPhilosopher) philosophers.get(i);
                    philosopher.setRightPhilosopher((TokenPhilosopher) philosophers.get((i + 1) % nrPhilosophers));
                }

                TokenPhilosopher initialPhilosopher = (TokenPhilosopher) philosophers.getFirst();
                GlobalToken token = new GlobalToken( initialPhilosopher);
                initialPhilosopher.setToken(token);
                break;

            case Algorithm.MULTIPLETOKEN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    MultipleTokenPhilosopher philosopher = new MultipleTokenPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }

                for (int i = 0; i < nrPhilosophers; i++) {
                    MultipleTokenPhilosopher philosopher = (MultipleTokenPhilosopher) philosophers.get(i);
                    philosopher.setRightPhilosopher((MultipleTokenPhilosopher) philosophers.get((i + 1) % nrPhilosophers));
                }
                for (int i = 0; i < nrPhilosophers - 1; i += 2) {
                    MultipleTokenPhilosopher philosopher = (MultipleTokenPhilosopher) philosophers.get(i);
                    philosopher.setToken(new Token(i, philosopher));
                }
                break;

            case Algorithm.TIMEOUT:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new TimeoutChopstick(i, timeout));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    TimeoutPhilosopher philosopher = new TimeoutPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.CLASSICWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                ClassicWaiter classicWaiter = new ClassicWaiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    GuestPhilosopher philosopher = new GuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, classicWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ATOMICWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                Waiter atomicWaiter = new Waiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    AtomicGuestPhilosopher philosopher = new AtomicGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, atomicWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.PICKUPWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                Waiter pickupWaiter = new Waiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    PickupGuestPhilosopher philosopher = new PickupGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, pickupWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.INTELLIGENTWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                IntelligentWaiter intelligentWaiter = new IntelligentWaiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    IntelligentPickupGuestPhilosopher philosopher = new IntelligentPickupGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, intelligentWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIREATTIMEWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                FairEatTimeWaiter fairEatTimeWaiter = new FairEatTimeWaiter();
                for (int i = 0; i < nrPhilosophers; i++) {
                    FairEatTimeGuestPhilosopher philosopher = new FairEatTimeGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairEatTimeWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIRCHANCEWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                FairChanceWaiter fairChanceWaiter = new FairChanceWaiter();
                for (int i = 0; i < nrPhilosophers; i++) {
                    FairChanceGuestPhilosopher philosopher = new FairChanceGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairChanceWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TWOWAITERS:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                Waiter splitWaiter = new Waiter(nrPhilosophers);
                Waiter splitWaiter1 = new Waiter(nrPhilosophers);

                Waiter selectedWaiter;
                boolean assignToTwo = nrPhilosophers > 3;
                for (int i = 0; i < nrPhilosophers; i++) {
                    selectedWaiter = (assignToTwo && i >= nrPhilosophers / 2) ? splitWaiter1 : splitWaiter;

                    // Create and add philosopher
                    PickupGuestPhilosopher philosopher = new PickupGuestPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, selectedWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TABLESEMAPHORE:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                TableSemaphore semaphore = new TableSemaphore();
                for (int i = 0; i < nrPhilosophers; i++) {
                    TableSemaphorePhilosopher philosopher = new TableSemaphorePhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, semaphore);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ROUNDROBIN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new RoundRobinChopstick(i));
                }

                RoundRobinScheduler scheduler = new RoundRobinScheduler(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    RoundRobinPhilosopher philosopher = new RoundRobinPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, scheduler);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.DIJKSTRA:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new DijkstraChopstick(i));
                }


                for (int i = 0; i < nrPhilosophers; i++) {
                    DijkstraPhilosopher philosopher = new DijkstraPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TANENBAUM:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                Monitor global = new Monitor(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    TanenbaumPhilosopher philosopher = new TanenbaumPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, global);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIRCHANCETANENBAUM:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                FairChanceMonitor fairChanceMonitor = new FairChanceMonitor(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    FairChanceTanenbaumPhilosopher philosopher = new FairChanceTanenbaumPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairChanceMonitor);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIRTIMETANENBAUM:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new SimpleChopstick(i));
                }

                FairTimeMonitor fairTimeMonitor = new FairTimeMonitor(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    FairTimeTanenbaumPhilosopher philosopher = new FairTimeTanenbaumPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairTimeMonitor);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.CHANDYMISRA:
                for (int i = 0; i < nrPhilosophers; i++) {
                    chopsticks.add(new ChandyMisraChopstick(i));
                }

                for (int i = 0; i < nrPhilosophers; i++) {
                    ChandyMisraPhilosopher philosopher = new ChandyMisraPhilosopher(i, chopsticks.get(i), chopsticks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }

                ChandyMisraPhilosopher philosopher;
                ChandyMisraChopstick chopstick;
                for (int i = 0; i < nrPhilosophers; i++) {
                    philosopher = (ChandyMisraPhilosopher) philosophers.get(i);
                    philosopher.setNeighbors((ChandyMisraPhilosopher) philosophers.get((i - 1 + nrPhilosophers) % nrPhilosophers),(ChandyMisraPhilosopher) philosophers.get((i + 1) % nrPhilosophers));

                    int leftPhilosopherId = ((i - 1) + nrPhilosophers) % nrPhilosophers;  // Get the adjacent philosopher's ID
                    int ownerId = Math.min(i, leftPhilosopherId);  // The owner is the philosopher with the lower ID
                    chopstick = (ChandyMisraChopstick) chopsticks.get(i);
                    chopstick.setOwner((ChandyMisraPhilosopher) philosophers.get(ownerId));
                }


                break;

        }
    }


    public SimuType getSimuType() {
        return simuType;
    }

    public Animation getAnimation() {
        return animation;
    }

    public long getCurrentTime() {
        return clock.getCurrentTime();
    }

    public void advanceTime() {
        clock.advanceTime(1);
    }

    public void lockClock() {
        clock.lockClock();
    }
    //TODO Synchronized?!?!?!?
    public synchronized void unlockClock() {
        clock.unlockClock();
    }

    public void startDinner() {
        for (AbstractPhilosopher philosopher : philosophers) {
            philosopher.start();
        }
    }

    public void stopDinner() {
        for (AbstractPhilosopher philosopher : philosophers) {
            philosopher.interrupt();
        }
    }


}

