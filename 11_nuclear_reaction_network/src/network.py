import numpy as np
from integrand import Integrand
from r_2c import r_2c
from r_3a import r_3a

default_tmax = 1e12

# Contains molar fractions of He, C and Mg
default_composition = np.array([0.25, 0, 0])


class Network(Integrand):
    """Class to integrate Reaction Network"""

    def __init__(self,
                 t9=1,
                 rho=1,
                 tmax=default_tmax,
                 y0=default_composition):
        """obtain and store parameters"""

        self.t9 = t9
        self.rho = rho
        self.tmax = tmax
        self.y0 = y0

    def __call__(self, t, y):
        """Compute derivatives of the reaction network"""
        t9 = self.t9
        rho = self.rho
        fa, ra = r_3a(t9, rho)
        fc, rc = r_2c(t9, rho)

        # Shortcut variables to keep us sane
        y_a = y[0]
        y_c = y[1]
        y_mg = y[2]

        # Equations for reaction rates from Task 1
        da = -0.5 * fa * y_a**3 + 3 * ra * y_c
        dc = 1/6 * fa * y_a**3 - fc * y_c**2 - ra * y_c + 2 * rc * y_mg
        dm = 0.5 * fc * y_c**2 - rc * y_mg

        b = np.array([da, dc, dm])
        return b

    def initial(self):
        """provide initial values for integration"""
        t = 0
        y = self.y0
        return t, y

    def final(self, t, y):
        """termination for t <= tmax"""
        return t > self.tmax
