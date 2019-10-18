from runge_kutta_integrator import RungeKuttaIntegrator
from adaptive_integrator import Adaptive


class RungeKuttaAdaptiveIntegrator(Adaptive, RungeKuttaIntegrator):
    """Adaptive RK4 solver"""
