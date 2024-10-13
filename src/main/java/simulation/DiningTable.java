package simulation;

import algorithms.asymmetric.AsymmetricFork;
import algorithms.asymmetric.AsymmetricPhilosopher;
import algorithms.hierarchy.HierarchyFork;
import algorithms.hierarchy.HierarchyPhilosopher;
import algorithms.naive.NaiveFork;
import algorithms.naive.NaivePhilosopher;
import algorithms.restrict.Restrict;
import algorithms.restrict.RestrictFork;
import algorithms.restrict.RestrictPhilosopher;
import algorithms.semaphore.roundrobin.PhilosopherSemaphores;
import algorithms.semaphore.roundrobin.RoundRobinFork;
import algorithms.semaphore.roundrobin.RoundRobinPhilosopher;
import algorithms.semaphore.dijkstra.DijkstraFork;
import algorithms.semaphore.dijkstra.DijkstraPhilosopher;
import algorithms.semaphore.tanenbaum.Monitor;
import algorithms.semaphore.tanenbaum.TanenbaumFork;
import algorithms.semaphore.tanenbaum.TanenbaumPhilosopher;
import algorithms.semaphore.fair_tanenbaum.FairTanenbaumPhilosopher;
import algorithms.semaphore.fair_tanenbaum.FairTanenbaumFork;
import algorithms.semaphore.fair_tanenbaum.FairGlobals;
import algorithms.semaphore.tablesemaphore.TableSemahoreFork;
import algorithms.semaphore.tablesemaphore.TableSemaphore;
import algorithms.semaphore.tablesemaphore.TableSemaphorePhilosopher;
import algorithms.timeout.TimeoutFork;
import algorithms.timeout.TimeoutPhilosopher;
import algorithms.token.multipletoken.MultipleTokenFork;
import algorithms.token.multipletoken.MultipleTokenPhilosopher;
import algorithms.token.multipletoken.Token;
import algorithms.token.singletoken.GlobalToken;
import algorithms.token.singletoken.TokenFork;
import algorithms.token.singletoken.TokenPhilosopher;
import algorithms.*;
import algorithms.waiter.fairwaiter.FairGuestFork;
import algorithms.waiter.fairwaiter.FairGuestPhilosopher;
import algorithms.waiter.fairwaiter.FairWaiter;
import algorithms.waiter.intelligent.IntelligentGuestFork;
import algorithms.waiter.intelligent.IntelligentPickupGuestPhilosopher;
import algorithms.waiter.intelligent.IntelligentWaiter;
import algorithms.waiter.queuewaiter.GuestFork;
import algorithms.waiter.queuewaiter.AtomicGuestPhilosopher;
import algorithms.waiter.queuewaiter.PickupGuestPhilosopher;
import algorithms.waiter.queuewaiter.Waiter;
import parser.Animation;

import java.util.ArrayList;
import java.util.List;


public class DiningTable {
    protected final List<AbstractPhilosopher> philosophers;
    protected final List<AbstractFork> forks;
    protected final VirtualClock clock = new VirtualClock();

    protected final int numberOfPhilosophers;
    protected final SimuType simuType;
    protected final Animation animation;

    public DiningTable(int nrPhilosophers, String algorithm, Distribution thinkDistr, Distribution eatDistr, int timeout, SimuType simuType, Animation animation) {

        philosophers = new ArrayList<>(nrPhilosophers);
        forks = new ArrayList<>(nrPhilosophers);
        this.numberOfPhilosophers = nrPhilosophers;
        this.simuType = simuType;
        this.animation = animation;

        switch (algorithm) {
            case Algorithm.NAIVE:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new NaiveFork(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    NaivePhilosopher philosopher = new NaivePhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ASYMMETRIC:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new AsymmetricFork(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    AsymmetricPhilosopher philosopher = new AsymmetricPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.RESTRICT:
                Restrict restrict = new Restrict(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new RestrictFork(i, restrict));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    RestrictPhilosopher philosopher = new RestrictPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.HIERARCHY:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new HierarchyFork(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    HierarchyPhilosopher philosopher = new HierarchyPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.GLOBALTOKEN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new TokenFork(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    TokenPhilosopher philosopher = new TokenPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    TokenPhilosopher philosopher = (TokenPhilosopher) philosophers.get(i);
                    int rightIndex = (i + 1) % nrPhilosophers;
                    TokenPhilosopher rightPhilosopher = (TokenPhilosopher) philosophers.get(rightIndex);
                    philosopher.setRightPhilosopher(rightPhilosopher);
                }
                TokenPhilosopher initialPhilosopher = (TokenPhilosopher) philosophers.getFirst();
                GlobalToken token = new GlobalToken( initialPhilosopher);
                initialPhilosopher.setToken(token);
                break;

            case Algorithm.MULTIPLETOKEN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new MultipleTokenFork(i));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    MultipleTokenPhilosopher philosopher = new MultipleTokenPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    MultipleTokenPhilosopher philosopher = (MultipleTokenPhilosopher) philosophers.get(i);
                    int rightIndex = (i + 1) % nrPhilosophers;
                    MultipleTokenPhilosopher rightPhilosopher = (MultipleTokenPhilosopher) philosophers.get(rightIndex);
                    philosopher.setRightPhilosopher(rightPhilosopher);
                }

                for (int i = 0; i < nrPhilosophers - 1; i += 2) {
                    MultipleTokenPhilosopher philosopher = (MultipleTokenPhilosopher) philosophers.get(i);
                    philosopher.setToken(new Token(i, philosopher));
                }
                break;

            case Algorithm.TIMEOUT:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new TimeoutFork(i, timeout));
                }
                for (int i = 0; i < nrPhilosophers; i++) {
                    TimeoutPhilosopher philosopher = new TimeoutPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ATOMICWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new GuestFork(i));
                }

                Waiter atomicWaiter = new Waiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    AtomicGuestPhilosopher philosopher = new AtomicGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, atomicWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TWOWAITERS:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new GuestFork(i));
                }

                Waiter splitWaiter = new Waiter(nrPhilosophers);
                Waiter splitWaiter1 = new Waiter(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    if (nrPhilosophers > 3) {
                        if (i < nrPhilosophers / 2) {
                            AtomicGuestPhilosopher philosopher = new AtomicGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, splitWaiter);
                            philosophers.add(philosopher);
                        } else if (i >= nrPhilosophers / 2) {
                            AtomicGuestPhilosopher philosopher = new AtomicGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, splitWaiter1);
                            philosophers.add(philosopher);
                        }
                    } else {
                        AtomicGuestPhilosopher philosopher = new AtomicGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, splitWaiter);
                        philosophers.add(philosopher);
                    }

                }
                break;

            case Algorithm.PICKUPWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new GuestFork(i));
                }

                Waiter pickupWaiter = new Waiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    PickupGuestPhilosopher philosopher = new PickupGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, pickupWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.INTELLIGENTWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new IntelligentGuestFork(i));
                }

                IntelligentWaiter intelligentWaiter = new IntelligentWaiter(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    IntelligentPickupGuestPhilosopher philosopher = new IntelligentPickupGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, intelligentWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIRWAITER:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new FairGuestFork(i));
                }

                FairWaiter fairWaiter = new FairWaiter();
                for (int i = 0; i < nrPhilosophers; i++) {
                    FairGuestPhilosopher philosopher = new FairGuestPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairWaiter);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TABLESEMAPHORE:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new TableSemahoreFork(i));
                }

                TableSemaphore semaphore = new TableSemaphore();
                for (int i = 0; i < nrPhilosophers; i++) {
                    TableSemaphorePhilosopher philosopher = new TableSemaphorePhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, semaphore);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.ROUNDROBIN:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new RoundRobinFork(i));
                }

                PhilosopherSemaphores semaphores = new PhilosopherSemaphores(nrPhilosophers);
                for (int i = 0; i < nrPhilosophers; i++) {
                    RoundRobinPhilosopher philosopher = new RoundRobinPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, semaphores);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.DIJKSTRA:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new DijkstraFork(i));
                }


                for (int i = 0; i < nrPhilosophers; i++) {
                    DijkstraPhilosopher philosopher = new DijkstraPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.TANENBAUM:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new TanenbaumFork(i));
                }

                Monitor global = new Monitor(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    TanenbaumPhilosopher philosopher = new TanenbaumPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, global);
                    philosophers.add(philosopher);
                }
                break;

            case Algorithm.FAIRTANENBAUM:
                for (int i = 0; i < nrPhilosophers; i++) {
                    forks.add(new FairTanenbaumFork(i));
                }

                FairGlobals fairGlobal = new FairGlobals(nrPhilosophers);

                for (int i = 0; i < nrPhilosophers; i++) {
                    FairTanenbaumPhilosopher philosopher = new FairTanenbaumPhilosopher(i, forks.get(i), forks.get((i + 1) % nrPhilosophers), this, thinkDistr, eatDistr, fairGlobal);
                    philosophers.add(philosopher);
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

