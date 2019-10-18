import numpy as np


def r_3a(t9, rho = 1, sc = 1):
    """Compute lambda for 3a rate and its reverse"""
    # q = 7.275 MeV
    t9m1 = 1/t9
    t9log = np.log(t9)
    t913 = np.exp(t9log * 1/3)
    t9m13 = 1/t913
    t953 = t913**5
    t93 = t9**3
    rho2 = rho**2
    ra3 = (
        + np.exp(
        -9.710520e-01
        -3.706000e+01*t9m13
        +2.934930e+01*t913
        -1.155070e+02*t9
        -1.000000e+01*t953
        -1.333330e+00*t9log)
        + np.exp(
        -2.435050e+01
        -4.126560e+00*t9m1
        -1.349000e+01*t9m13
        +2.142590e+01*t913
        -1.347690e+00*t9
        +8.798160e-02*t953
        -1.316530e+01*t9log)
        + np.exp(
        -1.178840e+01
        -1.024460e+00*t9m1
        -2.357000e+01*t9m13
        +2.048860e+01*t913
        -1.298820e+01*t9
        -2.000000e+01*t953
        -2.166670e+00*t9log))
    f = ra3 * rho2 * sc / 6
    rev = 2.00e+20 * t93 * np.exp(-84.424e+0 * t9m1)
    r = rev * ra3
    return f, r
