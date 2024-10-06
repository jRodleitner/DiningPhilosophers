package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import simulation.Execute;

@WebServlet(name = "AnimationServlet", value = "/animation")
public class AnimationServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the form
        String algorithm = request.getParameter("algorithm");
        int simulationTime = Integer.parseInt(request.getParameter("simulationTime"));
        boolean simulationType = Boolean.parseBoolean(request.getParameter("simulationType"));
        String thinkDistribution = request.getParameter("thinkDistribution");
        double thinkPar1 = Double.parseDouble(request.getParameter("thinkparam1"));
        double thinkPar2 = Double.parseDouble(request.getParameter("thinkparam2"));
        String eatDistribution = request.getParameter("eatDistribution");
        double eatPar1 = Double.parseDouble(request.getParameter("eatparam1"));
        double eatPar2 = Double.parseDouble(request.getParameter("eatparam2"));
        int timeout = Integer.parseInt(request.getParameter("timeout"));

        System.out.println(5 + " " + simulationTime);
        // Call the execute function with the given parameters
        String result = null;
        try {
            result = Execute.execute(5, simulationTime, algorithm, simulationType, eatDistribution, eatPar1, eatPar2, thinkDistribution, thinkPar1, thinkPar2, timeout, true);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        // Set the result and parameters as request attributes
        request.setAttribute("result", result);

        request.setAttribute("algorithm", algorithm);
        request.setAttribute("simulationTime", simulationTime);
        request.setAttribute("simulationType", simulationType);
        request.setAttribute("thinkDistribution", thinkDistribution);
        request.setAttribute("eatDistribution", eatDistribution);
        request.setAttribute("timeout", timeout);


        // Forward the request back to index.jsp
        request.getRequestDispatcher("/animation/index.jsp").forward(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to the index.jsp page
        request.getRequestDispatcher("/animation/index.jsp").forward(request, response);
    }
}
