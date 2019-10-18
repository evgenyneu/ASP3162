import numpy as np


class AdaptiveNetworkImplicit(object):
    """Adaptive Implicit solver"""

    def __init__(self, *args, rmax=1e-2, thres=1e-12, **kwargs):
        kwargs.setdefault('h', 1.)
        super().__init__(*args, **kwargs)
        self.rmax = rmax
        self.thres = thres

    def advance(self, x, y):
        """adaptive advancing"""

        h = self.h

        while True:
            dy = self.solver(x, y, h)
            yn = y + dy
            hn = h * np.min(self.rmax * (yn + self.thres)/(np.abs(dy) + 1.e-99))

            if np.all(yn >= 0) and (hn > 0.5 * h):
                break

            h *= 0.5
            hn = np.minimum(hn, 2 * h)
            self.h = hn
            return x + h, yn
