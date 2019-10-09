from step_integrate import StepIntegrate


class RungeKuttaIntegrator(StepIntegrate):
    """Perform integration using Runge Kutta integrator"""

    def advance(self, x, y):
        """
        Calcualte one step of integration

        Parameters
        ----------

        x : float
            Value of independent variable

        y : numpy.ndarray
            A 1D array containing dependent variable

        Returns
        -------

        tuple

        (x, y)

        """

        f = self.f
        h = self.h

        k1 = f(x, y)
        k2 = f(x + h / 2, y + h * k1 / 2)
        k3 = f(x + h / 2, y + h * k2 / 2)
        k4 = f(x + h, y + h * k3)
        phi = 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        y = y + h * phi
        x += h

        return x, y
