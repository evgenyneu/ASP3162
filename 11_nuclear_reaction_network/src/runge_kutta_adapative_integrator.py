import numpy as np
from runge_kutta_integrator import RungeKuttaIntegrator


class RungeKuttaAdaptiveIntegrator(RungeKuttaIntegrator):
    """Adaptive RK4 solver"""

    def __init__(self, *args, rmax=1e-3, thres=1e-4, **kwargs):
        super().__init__(*args, **kwargs)
        self.rmax = rmax
        self.thres = thres

    def advance(self, x, y):
        """adaptive advancing"""

        yp = self.f(x, y)
        hnew = np.min((y + self.thres) / (np.abs(yp) + 1e-99)) * self.rmax
        self.h = hnew
        xn, yn = super().advance(x, y)

        # while True:
        #     xn, yn = super().advance(x, y)
        #     if np.all(yn >= 0):
        #         break
        #
        #     self.h *= 0.5
        return xn, yn
