"""Integration of Lane-Emden equation"""

import numpy as np
from float_utils import is_zero
from integrand import Integrand


class LaneEmbdenIntegrator(Integrand):
    """
    Integrate Lane Emden Equation

    Variables used here
    -------------------

        x - scaled radius, alias for ξ (xi)

        y - scaled density, alias for θ (theta)

        z = dy/dx

    """

    def __init__(self, n):
        self.n = n

    def __call__(self, x, y_vector):
        """
        Compute derivatives of Lane Emden Equation (Eq. 30)

        Parameters
        ----------

        x : float
            A value of x variable

        y_vector : tuple
            Contains two elements: (y, z)

        Returns
        -------

        numpy.ndarray

        List containing two elements, which are derivatives:
            1. dy/dx.
            2. dz/dx.

        """
        y = y_vector[0]
        z = y_vector[1]

        if y < 0:
            message = "ERROR: can not calculate derivative: y is negative"
            raise Exception(message)

        if is_zero(x):
            # Use initial condition dy/dx = 0 at x = 0.
            # This means derivative of density is zero at the center.
            f0 = 0
            f1 = 0
        else:
            f0 = z
            f1 = -2 * z / x - y**self.n

        return np.array((f0, f1))

    def initial(self):
        """
        Calculates initial conditions.

        Returns
        --------

        tuple (x, y)

            x : float
                Independent variable

            y : list
                Dependent variables
        """

        x = 0
        y = np.array([1, 0])

        return x, y

    def final(self, x, y):
        """
        Checks if integration should be ended.

        Parameters
        ----------

        x : float
            Independent variable

        y : list
            Dependent variables

        Returns
        --------

        bool

        True if integration needs to be finished.

        """

        return y[0] <= 0
