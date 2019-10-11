# Solve Lane-Emden equation:
#
#     d(x^2 dy/dx)
#     ----------- = -x^2 * y^n,               (1)
#          dx
#
# where
#           x : scaled radius, from the center of the stellar
#           y : scaled density
#           n : polytropic index, a constant.
#
import numpy as np
from float_utils import is_zero


def lane_embden_derivatives(x, dependent_variables, data):
    """
    Eq. 1 is rearranged into two first-order differential equations:

        dy/dx = z                           (2)

        dz/dx = -2 z/x - y^n.               (3)

    This function computes derivatives dy/dx and dz/dx using Eq. 2 and 3.

    Parameters
    ----------

    x : float
        A value of x variable

    dependent_variables : tuple
        Contains two elements: (y, z)

    Returns : numpy.ndarray
    -------

    List containing two elements:
        1. dy/dx (Eq. 2)
        2. dz/dx (Eq. 3)

    """
    y = dependent_variables[0]
    z = dependent_variables[1]

    if is_zero(x):
        # Avoid division by zero by using initial condition dy/dx = 0 at x = 0
        dy_dx = 0
        dz_dx = 0
    else:
        n = data["polytropic_index"]
        dy_dx = z  # Use Eq. 2
        dz_dx = -2 * z / x - y**n  # Use Eq. 3

    return np.array([dy_dx, dz_dx])


def solve_lane_emden(step_size,
                     polytropic_index,
                     integrator,
                     xmax=10):
    """
    Solves Lane-Emden equation (Eq. 1) numerically.

    Parameters
    ----------

    step_size : float
        Size of the scaled radius step (variable x from Eq. 1).

    polytropic_index : int
        Parameter `n` in Lane-Emden equation (Eq. 1)

    integrator : function
        An integration method used (i.e. Euler or Runge-Kutta).
        Here we pass one of the functions defined in `integrators` module.

    xmax : float
        Maximum value of scaled radius, after which integration is stopped.


    Returns : tuple (all_x, all_dependent_variables)
    ---------

    all_x : numpy.ndarray
        Values of scaled radius.

    all_dependent_variables : numpy.ndarray
        The list of [y, dy/dx] pairs - values of scaled density and its
        derivative.
    """

    # Initial conditions
    # -----------

    x = 0  # Variable x (radius). We start from the center of the star.

    dependent_variables = [
        1,  # Variable y in Eq. 1, density at the center is set to be 1
        0   # Variable z = dy/dx is zero at the center (Eq. 2)
    ]

    # Store variables from integration
    all_x = []
    all_dependent_variables = []

    derivative_data = {"polytropic_index": polytropic_index}

    # Integrate
    while not (
            dependent_variables[0] <= 0  # Stop when density becomes negative
            or x > xmax  # Stop if exceed maximum radius
        ):

        all_x.append(x)
        all_dependent_variables.append(dependent_variables)

        x, dependent_variables = integrator(
            h=step_size,
            derivative=lane_embden_derivatives,
            data=derivative_data,
            x=x, y=dependent_variables)

    return np.array(all_x), np.array(all_dependent_variables)
