from step_integrate import StepIntegrate


class EulerIntegrator(StepIntegrate):
    """Perform integration using the Euler method"""

    def __init__(self, f, h=0.001):
        """
        Parameters
        ----------

        f : function
            Calculates derivatives.

            Parameters of f
            --------------

            x : float
                A value of independent variable

            y_vector : list
                Contains a list of dependent variables

        h : float
            Contains the step size for the independent variable.
        """

        self.f = f
        self.h = h

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
