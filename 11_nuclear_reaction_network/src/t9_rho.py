import numpy as np


class T9Rho(object):
    """Thermodynamics function for free exansion"""

    def __init__(self, tp=1e10, rhop=1e7):
        self.tp = tp
        self.rhop = rhop
        self.tau3i = -1 / (3 * 446 * (self.rhop**(-0.5)))

    def __call__(self, t, y):
        """return time-dependent t9 and rho"""

        f = np.exp(t * self.tau3i)
        return self.tp * f, self.rhop * f ** 3
