import numpy as np


def r_2c(t9, rho = 1, sc = 1):
    # q = 13.933 MeV
    t9a = t9 / (1 + 0.0396e0 * t9)
    t9a13 = t9a**(1/3)
    t9a56 = t9a**(5/6)
    t932 = t9**(3/2)
    t9m32 = 1/t932
    t9m1 = 1/t9
    t93 = t932**2
    r24 = (4.27e+26 * t9a56 * t9m32 *
           np.exp(-84.165e+0 / t9a13 - 2.12e-03 * t93))
    f = 0.5e0 * rho * r24*sc
    rev = 2.56e10 * t932 * np.exp(-161.6858e+0 * t9m1)
    r = rev * r24
    return f, r
