import numpy as np


def exact(x, n):
    """
    Calculate exact solution of Lane-Emden equation.

    Parameters
    ----------

    x : float or ndarray
        Value or values of independent variable

    n : integer
        Parameter 'n' of the Lane-Emden equation

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


def exact_derivative(x, n):
    """
    Calculate exact values for the derivatives of the solutions
    of Lane-Emden equation.

    Parameters
    ----------

    x : float or ndarray
        Value or values of independent variable

    n : integer
        Parameter 'n' of the Lane-Emden equation

    Returns : float or ndarray
    -------

    Value or values of the exact solution
    """

    if n == 0:
        return -x/3
    elif n == 1:
        a = np.cos(x)
        b = np.array(x)
        # Assign value 0 to terms that have division by zero
        term1 = np.divide(a, b, out=np.zeros_like(a), where=b != 0)

        a = np.sin(x)
        b = np.power(x, 2)
        # Assign value 0 to terms that have division by zero
        term2 = np.divide(a, b, out=np.zeros_like(a), where=b != 0)

        return term1 - term2
    elif n == 5:
        return -x / (3 * np.power(1 + np.power(x, 2) / 3, 3/2))
    else:
        raise ValueError(f"Incorrect n value: {n}")
