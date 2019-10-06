from euler_integrator import EulerIntegrator
from lane_embden_integrator import LaneEmbdenIntegrator
import matplotlib.pyplot as plt
from plot_utils import save_plot


def plot_density_and_its_derivative_lane_embden(plot_dir,
                                                filename, h, n, figsize,
                                                show):

    """
    Show plot of solution to Lane-Embden equation.

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

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    le = LaneEmbdenIntegrator(n=n)
    x, y = le.integrate(method=EulerIntegrator, h=h)
    plt.figure(figsize=figsize)

    label_radius = (
        "Scaled density, "
        r'$\theta$'
    )

    plt.plot(x, y[:, 0], label=label_radius, color='r')
    plt.plot(x, y[:, 1], label=r'$\theta^\prime$', color='g')

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

    title = (
        "Task 2\n"
        f"Solution to Lane-Embden equation, h={h}, n={n}"
    )

    plt.title(title)
    plt.legend()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()
