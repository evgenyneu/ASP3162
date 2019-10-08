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
        return 1 - 1/6 * np.power(x, 2)
    elif n == 1:
        # We need to calculate sin(x)/x
        # when x=0, this is equal to 1
        a = np.sin(x)
        b = np.array(x)
        return np.divide(a, b, out=np.ones_like(a), where=b != 0)
    elif n == 5:
        return np.power(1 + 1/3 * np.power(x, 2), -0.5)
    else:
        raise ValueError(f"Incorrect n value: {n}")
