import numpy as np


class Adaptive(object):
    """Adaptive driver template"""

    def __init__(self, *args, rmax=1e-3, thres=1e-4, **kwargs):
        super().__init__(*args, **kwargs)
        self.rmax = rmax
        self.thres = thres

    def advance(self, x, y):
        """adaptive advancing"""

        yp = self.f(x, y)

        # Estimate the time step
        hnew = np.min((y + self.thres) / (np.abs(yp) + 1e-99)) * self.rmax

        # Prevent step size from increasing too fast
        self.h = np.minimum(hnew, 2 * self.h)

        while True:
            xn, yn = super().advance(x, y)

            if np.all(yn >= 0):
                break

            # Abundances are negative, repeat with a smaller time step
            self.h *= 0.5

        return xn, yn
