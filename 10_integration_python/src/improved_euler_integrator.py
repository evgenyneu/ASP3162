from step_integrate import StepIntegrate


class ImprovedEulerIntegrator(StepIntegrate):
    """Perform integration using improved Euler method"""

    def advance(self, x, y):
        """
        Calcualte one step of integration using improved Euler method.

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
        y_bar = y + h * f(x, y)
        y = y + h * (f(x, y) + f(x + h, y_bar)) / 2
        x += h

        return x, y

    def name():
        """
        Returns human-readable name of the integrator.
        """

        return "Improved Euler"
