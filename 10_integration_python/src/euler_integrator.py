from step_integrate import StepIntegrate


class EulerIntegrator(StepIntegrate):
    """Perform integration using the Euler method"""

    def advance(self, x, y):
        """
        Calcualte one step of integration using the Euler method.

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
        y = y + h * f(x, y)
        x += h

        return x, y

    def name():
        """
        Returns human-readable name of the integrator.
        """

        return "Euler"
