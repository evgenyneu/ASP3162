"""Make plots for the lab"""

import matplotlib.pyplot as plt
from lane_embden_integrator import LaneEmbdenIntegrator
from euler_integrator import EulerIntegrator
from plot_utils import save_plot
from plotter import plot_density_and_its_derivative_lane_embden


def task1(plot_dir, figsize, show):
    """
    Make plots first task

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    figsize : tuple
        Figure size (width, height)

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    n = 3
    h = 0.01

    lane_embden = LaneEmbdenIntegrator(n=n)
    x, y = lane_embden.integrate(method=EulerIntegrator, h=h)
    plt.rc('font', size=14)
    plt.figure(figsize=figsize)
    plt.xlabel(r'Scaled radius, $\xi$')
    plt.ylabel(r'Scaled density, $\theta$')

    title = (
        "Task 1\n"
        f"Solution to Lane-Embden equation, h={h}, n={n}"
    )

    plt.title(title)
    plt.plot(x, y[:, 0], label="Density")
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename="01_lane_embden.pdf")

    if show:
        plt.show()


def task2(plot_dir, figsize, show):
    """
    Make plots second task

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    figsize : tuple
        Figure size (width, height)

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    plot_density_and_its_derivative_lane_embden(
        plot_dir=plot_dir,
        filename="02a_density_vs_radius_h_0.1.pdf",
        h=0.1,
        n=3,
        figsize=figsize,
        show=show)

    plot_density_and_its_derivative_lane_embden(
        plot_dir=plot_dir,
        filename="02a_density_vs_radius_h_0.01.pdf",
        h=0.01,
        n=3,
        figsize=figsize,
        show=show)

    plot_density_and_its_derivative_lane_embden(
        plot_dir=plot_dir,
        filename="02a_density_vs_radius_h_0.001.pdf",
        h=0.001,
        n=3,
        figsize=figsize,
        show=show)


def make_plots(plot_dir, show):
    """
    Make plots for all the tasks in the lab.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    figsize = (8, 6)

    task1(plot_dir=plot_dir, figsize=figsize, show=show)
    task2(plot_dir=plot_dir, figsize=figsize, show=show)


if __name__ == '__main__':
    make_plots(plot_dir="plots", show=True)
