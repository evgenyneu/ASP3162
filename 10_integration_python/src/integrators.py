# Integrators for solving ODEs


def euler_integrator(h, derivative, data, x, y):
    """
    Calculate one step of integration using the Euler method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives. See description
        in `runge_kutta_integrator` function.

    data : anything
        Additional data that is passed to the derivative function

    x : float
        Value of independent variable

    y : numpy.ndarray
        A 1D array containing dependent variables

    Returns : tuple (x, y)
    -------

    Updated variables

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
        Function that calculates derivatives. See description
        in `runge_kutta_integrator` function.

    data : anything
        Additional data that is passed to the derivative function

    x : float
        Value of independent variable

    y : numpy.ndarray
        A 1D array containing dependent variables

    Returns : tuple (x, y)
    -------

    Updated variables

    """

    f = derivative
    y_bar = y + h * f(x, y, data)
    y = y + h * (f(x, y, data) + f(x + h, y_bar, data)) / 2
    x += h

    return x, y


def runge_kutta_integrator(h, derivative, data, x, y):
    """
    Calculate one step of integration using Runge-Kutta method.

    Parameters
    ----------

    h : float
        Step size

    derivative : function
        Function that calculates derivatives for the system of
        differential equation.

        For example, suppose we have a system

            dy/dx = f(x, y, z)              (1)

            dz/dx = g(x, y, z),             (2)

        where
                x : independent variable
                y, z : dependent variables.

        The `derivative` function calculates and returns [dy/dx, dz/dx].

        `derivative` parameters
        ------------------------

            x : float
                Value of the independent variable

            dependent_variables : list of float
                List of values for dependent variables. In Eq. 1 and 2,
                it will be [y, z]

            data : any type (optional)

                Additional data that may be needed to calcualte derivatives.

        `derivative` returns : np.array of float
        ---------------------

            Values of derivatives of all variables.
            For example from Eq. 2 and 3, it will return [dy/dx, dz/dx].

    data : anything
        Additional data that is passed to the derivative function

    x : float
        Value of independent variable

    y : numpy.ndarray
        A 1D array containing dependent variables

    Returns : tuple (x, y)
    -------

    Updated variables

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
