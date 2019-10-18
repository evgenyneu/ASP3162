import numpy as np
from network import Network


class ThermoNetwork(Network):
    """Netwrok with time-dependent thermodynamics"""

    def __init__(self, *args, t9min, **kwargs):
        self._thermo = kwargs.pop('thermo')
        kwargs['t9'] = np.nan
        kwargs['rho'] = np.nan
        self.t9min = t9min
        super().__init__(*args, **kwargs)

    def thermo(self, t, y):
        """call thermodynamic function and return t9 and tho"""

        return self._thermo(t, y)

    def final(self, t, y):
        """termination for t <= tmax"""
        t9, rho = self.thermo(t, y)
        return t9 < self.t9min
