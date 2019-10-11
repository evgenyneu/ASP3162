# Show plot of solution to Lane-Emden equation
from integrate import integrate, euler_integrator

import matplotlib.pyplot as plt
from plot_utils import save_plot, get_linestyles_cycler


def plot_lane_emden_task_2(plot_dir,
                           filename, h, n, figsize,
                           title, show):

    """
    Show plot of solution to Lane-Emden equation.

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

    label_radius = (
        "Scaled density, "
        r'$\theta$'
    )

    cycler = get_linestyles_cycler()
    plt.plot(x, y[:, 0], label=label_radius, color='r', linestyle=next(cycler))

    plt.plot(x, y[:, 1], label=r'$\theta^\prime$', color='g',
             linestyle=next(cycler))

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
