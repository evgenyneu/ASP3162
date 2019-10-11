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


def euler_integrator(h, derivative, data, x, y):
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

    y = y + h * derivative(x, y, data)
    x += h

    return x, y


def improved_euler_integrator(h, derivative, data, x, y):
    """
    Calcualte one step of integration using the Emproved Euler method.

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

    f = derivative

    y_bar = y + h * f(x, y, data)
    y = y + h * (f(x, y, data) + f(x + h, y_bar, data)) / 2
    x += h

    return x, y


def runge_kutta_integrator(h, derivative, data, x, y):
    """
    Calcualte one step of integration using the Emproved Euler method.

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

    f = derivative
    k1 = f(x, y, data)
    k2 = f(x + h / 2, y + h * k1 / 2, data)
    k3 = f(x + h / 2, y + h * k2 / 2, data)
    k4 = f(x + h, y + h * k3, data)
    phi = 1 / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
    y = y + h * phi
    x += h

    return x, y


def integrate(step_size,
              polytropic_index,
              integrator,
              xmax=10):

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
