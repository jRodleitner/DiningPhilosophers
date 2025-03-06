package servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import simulation.Execute;

@WebServlet(name = "SimulationServlet", value = "/simulation")
public class SimulationServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String algorithm = request.getParameter("algorithm");
        int nrPhilosophers = Integer.parseInt(request.getParameter("nrPhil"));
        int simulationTime = Integer.parseInt(request.getParameter("simulationTime"));
        boolean simulationType = Boolean.parseBoolean(request.getParameter("simulationType"));
        String thinkDistribution = request.getParameter("thinkDistribution");
        double thinkPar1 = Double.parseDouble(request.getParameter("thinkparam1"));
        double thinkPar2 = Double.parseDouble(request.getParameter("thinkparam2"));
        String eatDistribution = request.getParameter("eatDistribution");
        double eatPar1 = Double.parseDouble(request.getParameter("eatparam1"));
        double eatPar2 = Double.parseDouble(request.getParameter("eatparam2"));
        int timeout = Integer.parseInt(request.getParameter("timeout"));


        List<String> result= null;
        if(RequestCheck.checkSimulationRequestValidity(nrPhilosophers, simulationTime, algorithm, eatDistribution, eatPar1, eatPar2, thinkDistribution, thinkPar1, thinkPar2, timeout)){
            try {
                result = Execute.execute(nrPhilosophers, simulationTime, algorithm, simulationType, eatDistribution, eatPar1, eatPar2, thinkDistribution, thinkPar1, thinkPar2, timeout, false);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

            request.setAttribute("result", result.getFirst());
        } else {
            request.setAttribute("result", "[Invalid Request ERROR]:  Invalid Simulation Parameters");
        }


        request.setAttribute("algorithm", algorithm);
        request.setAttribute("nrPhil", nrPhilosophers);
        request.setAttribute("simulationTime", simulationTime);
        request.setAttribute("simulationType", simulationType);
        request.setAttribute("thinkDistribution", thinkDistribution);
        request.setAttribute("eatDistribution", eatDistribution);
        request.setAttribute("timeout", timeout);


        request.getRequestDispatcher("/simulation/index.jsp").forward(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/simulation/index.jsp").forward(request, response);
    }
}
