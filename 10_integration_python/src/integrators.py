# Integrators for solving ODEs


def euler_integrator(h, derivative, data, x, y):
    """
    Calculate one step of integration using the Euler method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives

    data : anything
        Additional data that is passed to the derivative function

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
    Calculate one step of integration using the Emproved Euler method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives

    data : anything
        Additional data that is passed to the derivative function

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
    Calculate one step of integration using the Emproved Euler method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives

    data : anything
        Additional data that is passed to the derivative function

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
