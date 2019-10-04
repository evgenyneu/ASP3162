def is_zero(number):
    """
    Check if the `number` almost zero.

    Parameters
    ---------

    number: float
        A number.

    Returns
    --------

    True if the `number` is small.
    """

    return number < 1e-50
