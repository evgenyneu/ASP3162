"""
Modified integrator for Lane_Emden equation that fixes
infinite loop for n=5 by creating a modified termination condition.
"""

from lane_emden_integrator import LaneEmdenIntegrator


class LaneEmdenIntegratorLimitedX(LaneEmdenIntegrator):
    def __init__(self, n, xmax=10):
        self.xmax = xmax
        super().__init__(n)

    def final(self, x, y):
        """
        Checks if integration should be ended.

        Parameters
        ----------

        x : float
            Independent variable

        y : list
            Dependent variables

        Returns
        --------

        bool

        True if integration needs to be finished.

        """

        if self.xmax is None:
            return y[0] <= 0

        return y[0] <= 0 or x > self.xmax
