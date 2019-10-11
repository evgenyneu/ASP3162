import numpy as np
from float_utils import is_zero


def lane_embden_derivatives(x, y_vector, polytropic_index):
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
        # Ooooooooooooooo, y is negative, how wonderful....
        # What should we do?
        # Answer: absolutely nothing!
        pass

    if is_zero(x):
        # Use initial condition dy/dx = 0 at x = 0.
        # This means derivative of density is zero at the center.
        f0 = 0
        f1 = 0
    else:
        f0 = z
        f1 = -2 * z / x - y**polytropic_index

    return np.array((f0, f1))


def euler_advance(h, derivative, polytropic_index, x, y):
    """
    Calcualte one step of integration using the Euler method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives

    x : float
        Value of independent variable

    y : numpy.ndarray
        A 1D array containing dependent variable

    Returns
    -------

    tuple

    (x, y)

    """

    y = y + h * derivative(x=x, y_vector=y, polytropic_index=polytropic_index)
    x += h

    return x, y


def integrate(step_size,
              polytropic_index,
              derivative,
              advance,
              xmax=10):

    x = 0
    y = np.array([1, 0])
    xi = []
    yi = []

    while not (y[0] <= 0 or x > xmax):
        xi.append(x)
        yi.append(y)
        x, y = advance(h=step_size,
                       derivative=derivative,
                       polytropic_index=polytropic_index,
                       x=x, y=y)

    return np.array(xi), np.array(yi)


class Integrate(object):
    """
    Do all integration steps
    """

    def __init__(self, f, initial, final):
        """
        Parameters
        ----------

        f : function
            Calculates derivatives.

            Parameters of `f`
            --------------

            x : float
                A value of independent variable

            y_vector : list
                Contains a list of dependent variables

            Returns (`f` function)
            ---------

            numpy.ndarray

            List containing two elements, which are derivatives:
                1. dy/dx.
                2. dz/dx.

        initial : function
            Calculates initial conditions.

            Returns (`initial` function)
            --------------

            tuple (x, y)

                x : float
                    Independent variable

                y : list
                    Dependent variables

        final : function
            Checks if integration should be ended.

            Parameters of `final`
            ----------

            x : float
                Independent variable

            y : list
                Dependent variables

            Returns (`final` function)
            --------

            bool

            True if integration needs to be finished.
        """
        self.f = f
        self.initial = initial
        self.final = final

    def run(self):
        """
        Start the integration
        """

        x, y = self.initial()
        xi = []
        yi = []

        while not self.final(x, y):
            xi.append(x)
            yi.append(y)
            x, y = self.advance(x, y)

        return np.array(xi), np.array(yi)
