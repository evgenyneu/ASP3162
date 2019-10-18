import numpy as np
from step_integrate import StepIntegrate


class NetworkImplicitIntegrator(StepIntegrate):
    """implicit integrator for network"""

    def solver(self, x, y, h):
        """return solution vector for dy"""

        b, jacobian = self.f(x, y, return_jacobian=True)
        m = np.diag(np.tile(1 / h, 3)) - jacobian
        dy = np.linalg.solve(m, b)
        return dy

    def advance(self, x, y):
        """implicit advancing time step"""
        h = self.h
        dy = self.solver(x, y, h)
        return x+h, y+dy
