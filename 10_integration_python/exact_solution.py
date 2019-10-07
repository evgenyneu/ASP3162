import numpy as np


def exact(x, n):
    """
    Calculate exact solution of Lane-Embden equation.

    Parameters
    ----------

    x : float or ndarray
        Value or values of independent variable

    n : integer
        Parameter 'n' of the Lane-Embden equation

    Returns : float or ndarray
    -------

    Value or values of the exact solution
    """

    if n == 0:
        return 1 - 1/6 * x**2
    elif n == 1:
        return np.sin(x) / x
    elif n == 5:
        return (1 + 1/3 * x**2)**(-0.5)
    else:
        raise ValueError(f"Incorrect n value: {n}")
