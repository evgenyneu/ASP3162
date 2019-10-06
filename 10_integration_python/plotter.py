from euler_integrator import EulerIntegrator
from lane_embden_integrator import LaneEmbdenIntegrator
import matplotlib.pyplot as plt
from plot_utils import create_dir_for_path


def plot_density_and_its_derivative_lane_embden(h, n, figsize, filename):
    """
    Show plot of solution to Lane-Embden equation.

    Parameters
    -----------

    h : float
        Step size (radius x variable)

    n : float
        Parameter in the Lane-Embden equation.

    figsize : tuple
        Figure size (width, height)

    filename : str
        Path to the file where the plot will be saved.
    """

    le = LaneEmbdenIntegrator(n=n)
    x, y = le.integrate(method=EulerIntegrator, h=h)
    fig = plt.figure(figsize=figsize)
    ax = fig.add_subplot(111)

    label_radius = (
        "Scaled density, "
        r'$\theta$'
    )

    ax.plot(x, y[:, 0], label=label_radius, color='r')
    ax.plot(x, y[:, 1], label=r'$\theta^\prime$', color='g')

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
        f"Solution to Lane-Embden equation, h={h}, n={n}"
    )

    plt.title(title)

    ax.legend(loc='best')
    fig.tight_layout()
    create_dir_for_path(filename)
    fig.savefig(filename)
    fig.show()
