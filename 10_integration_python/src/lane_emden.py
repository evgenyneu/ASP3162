# Solve Lane-Emden equation numerically
import numpy as np
from float_utils import is_zero


def lane_embden_derivatives(x, y_vector, data):
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
        polytropic_index = data["polytropic_index"]
        f0 = z
        f1 = -2 * z / x - y**polytropic_index

    return np.array((f0, f1))


def solve_lane_emden(step_size,
                     polytropic_index,
                     integrator,
                     xmax=10):
    """
    Solves Lane-Emden equation numerically

    Parameters
    ----------

    step_size : float
        Size of the scaled radius step

    polytropic_index : int
        Parameter `n` in Lane-Emden equation

    integrator : function
        An integration method used (i.e. Euler or Runge-Kutta)

    xmax : float
        Maximum value of scaled radius, after which integration is stopped.
    """

    x = 0
    y = np.array([1, 0])
    xi = []
    yi = []
    derivative_data = {"polytropic_index": polytropic_index}

    while not (y[0] <= 0 or x > xmax):
        xi.append(x)
        yi.append(y)
        x, y = integrator(h=step_size,
                          derivative=lane_embden_derivatives,
                          data=derivative_data,
                          x=x, y=y)

    return np.array(xi), np.array(yi)
