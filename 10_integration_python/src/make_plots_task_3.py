# Show plots of approximate and exact solutions to Lane-Emden equation.
import matplotlib.pyplot as plt
from euler_integrator import EulerIntegrator
from plot_utils import save_plot, get_linestyles_cycler
from lane_emden_integrator_limited_x import LaneEmdenIntegratorLimitedX
from exact_solution import exact, exact_derivative
from integrate import integrate, euler_integrator


def plot_lane_emden_task_3(plot_dir, filename,
                            h, n, figsize, title, show):

    """
    Show plots of approximate and exact solutions to Lane-Emden equation.

    Parameters
    -----------

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved

    h : float
        Step size (radius x variable)

    n : float
        Parameter in the Lane-Emden equation.

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

    x, y = integrate(step_size=h,
                     polytropic_index=n,
                     integrator=euler_integrator)

    plt.figure(figsize=figsize)

    label_density = (
        "Scaled density, "
        r'$\theta$'
    )

    cycler = get_linestyles_cycler()
    plt.plot(x, y[:, 0], label=label_density, linestyle=next(cycler))
    plt.plot(x, exact(x, n), label=r"Exact $\theta$", linestyle=next(cycler))

    plt.plot(x, y[:, 1], label=r'$\theta^\prime$',
             linestyle=next(cycler))

    plt.plot(x, exact_derivative(x, n),
             label=r'Exact $\theta^\prime$', linestyle=next(cycler))

    xlabel = (
        'Scaled radius, '
        r'$\xi$'
    )

    plt.xlabel(xlabel)

    ylabel = (
        'Scaled density and its derivative, '
        r'$\theta$,  $\theta^\prime$'
    )

    plt.ylabel(ylabel)
    plt.title(title)
    plt.legend()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()
