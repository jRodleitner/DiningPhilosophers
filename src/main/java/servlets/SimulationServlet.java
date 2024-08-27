package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import simulation.Execute;

@WebServlet(name = "SimulationServlet", value = "/simulation")
public class SimulationServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the form
        int nrPhilosophers = Integer.parseInt(request.getParameter("nrPhil"));
        int simulationTime = Integer.parseInt(request.getParameter("simulationTime"));
        System.out.println(nrPhilosophers + " " + simulationTime);
        // Call the execute function with the given parameters
        String result = null;
        try {
            result = Execute.execute(nrPhilosophers, simulationTime, "NAIVE", "INTERVAL", 50, 100, "INTERVAL", 50, 100, 200);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        // Set the result and parameters as request attributes
        request.setAttribute("result", result);
        request.setAttribute("nrPhil", nrPhilosophers);
        request.setAttribute("simulationTime", simulationTime);

        // Forward the request back to index.jsp
        request.getRequestDispatcher("/simulation/index.jsp").forward(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to the index.jsp page
        request.getRequestDispatcher("/simulation/index.jsp").forward(request, response);
    }
}
