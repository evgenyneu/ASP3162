# Show plots of approximate and exact solutions to Lane-Embden equation.
import matplotlib.pyplot as plt
import numpy as np
from plot_utils import save_plot, get_linestyles_cycler
from lane_embden_integrator import LaneEmbdenIntegrator
from exact_solution import exact, exact_derivative
from euler_integrator import EulerIntegrator
from improved_euler_integrator import ImprovedEulerIntegrator
from runge_kutta_integrator import RungeKuttaIntegrator
from plot_utils import find_nearest_index


def plot_errors(plot_dir, filename,
                h, n, figsize, title, show):

    """
    Show plots of errors of solutions of Lane-Embden equation.

    Parameters
    -----------

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved

    h : float
        Step size (radius x variable)

    n : float
        Parameter in the Lane-Embden equation.

    figsize : tuple
        Figure size (width, height)

    filename : str
        Path to the file where the plot will be saved.

    title : str
        Plot title.

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    le = LaneEmbdenIntegrator(n=n)
    plt.figure(figsize=figsize)
    cycler = get_linestyles_cycler()

    # Euler
    # ------------

    for method in [EulerIntegrator,
                   ImprovedEulerIntegrator, RungeKuttaIntegrator]:

        x, y = le.integrate(method=method, h=h)

        x_surface = x[-1]
        density_surface = y[-1, 0]
        density_derivative_surface = y[-1, 1]

        print(f'method={method.name()} x_surface={x_surface} density_derivative_surface={density_derivative_surface}')

    x_values = np.linspace(0, x_surface * 1.1, 100000)
    y_exact = exact(x_values, n)
    index_zero_density = find_nearest_index(y_exact, 0)
    y_exact_derivative = exact_derivative(x_values, n)

    print(f'method=Exact x_surface={x_values[index_zero_density]} density_derivative_surface={y_exact_derivative[index_zero_density]}')

    # x, y = le.integrate(method=EulerIntegrator, h=h)
    # x, y = le.integrate(method=RungeKuttaIntegrator, h=h)
    # y_exact = exact(x, n)
    # error = y[:, 0] - y_exact
    # plt.plot(x, y[:, 0], label="Euler", linestyle=next(cycler))
    # plt.plot(x, error, label="Euler", linestyle=next(cycler))

    # Improved Euler
    # ------------

    # x, y = le.integrate(method=ImprovedEulerIntegrator, h=h)
    # y_exact = exact(x, n)
    # error = y[:, 0] - y_exact
    # plt.plot(x, error, label="Improved Euler", linestyle=next(cycler))
    #
    # # Runge-Kutta
    # # ------------
    #
    # x, y = le.integrate(method=RungeKuttaIntegrator, h=h)
    # y_exact = exact(x, n)
    # error = y[:, 0] - y_exact
    # # print(np.abs(error))
    # plt.plot(x, error, label="Runge-Kutta", linestyle=next(cycler))

    # xlabel = (
    #     'Scaled radius, '
    #     r'$\xi$'
    # )
    #
    # plt.xlabel(xlabel)
    #
    # ylabel = (
    #     'Absolute error, '
    #     r'$\theta - \theta_{exact}$'
    # )
    #
    # plt.ylabel(ylabel)
    # plt.title(title)
    # # plt.yscale('symlog')
    # plt.legend()
    # plt.tight_layout()
    # save_plot(plt=plt, plot_dir=plot_dir, filename=filename)
    #
    # if show:
    #     plt.show()
