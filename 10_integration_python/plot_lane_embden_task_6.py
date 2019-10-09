# Show plots of approximate and exact solutions to Lane-Embden equation.
import matplotlib.pyplot as plt
from plot_utils import save_plot, get_linestyles_cycler
from lane_embden_integrator_limited_x import LaneEmbdenIntegratorLimitedX
from exact_solution import exact, exact_derivative


def plot_with_integrator(integrator, plot_dir, filename,
                         h, n, figsize, title, show):

    """
    Show plots of approximate and exact solutions to Lane-Embden equation.

    Parameters
    -----------

    integrator : Integrate
        Integrator that will be used to calculate the solution.

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

    le = LaneEmbdenIntegratorLimitedX(n=n)
    x, y = le.integrate(method=integrator, h=h)

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
