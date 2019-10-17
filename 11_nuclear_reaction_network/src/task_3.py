from runge_kutta_integrator import RungeKuttaIntegrator
from network import Network


def plot_mass_fractions(plot_dir, figsize, show):
    tmax = 1e12
    number_of_steps = 1000
    h = tmax / number_of_steps  # Step size

    integrator = Network(t9=1, rho=1, tmax=tmax, y0=[0.25, 0, 0])
    x, y = integrator.integrate(method=RungeKuttaIntegrator, h=h)
