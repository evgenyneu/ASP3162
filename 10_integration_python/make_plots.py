"""Make plots for the lab"""

import matplotlib.pyplot as plt
from lane_embden_integrator import LaneEmbdenIntegrator
from euler_integrator import EulerIntegrator
from plot_utils import save_plot
from make_plots_task_2 import plot_lane_embden_task_2
from make_plots_task_3 import plot_lane_embden_task_3
from plot_lane_embden_task_6 import plot_errors


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
        f"Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
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

    h = 0.1
    n = 3

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_2(
        plot_dir=plot_dir,
        filename="02a_density_vs_radius_h_0.1.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 2 (a)\n{subtitle}",
        show=show)

    h = 0.01

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_2(
        plot_dir=plot_dir,
        filename="02b_density_vs_radius_h_0.01.pdf",
        h=0.01,
        n=3,
        figsize=figsize,
        title=f"Task 2 (b)\n{subtitle}",
        show=show)

    h = 0.001

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_2(
        plot_dir=plot_dir,
        filename="02c_density_vs_radius_h_0.001.pdf",
        h=0.001,
        n=3,
        figsize=figsize,
        title=f"Task 2 (c)\n{subtitle}",
        show=show)


def task3(plot_dir, figsize, show):
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

    h = 0.1
    n = 0

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_3(
        plot_dir=plot_dir,
        filename="03a_density_vs_radius_n_0.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (a)\n{subtitle}",
        show=show)

    n = 1

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_3(
        plot_dir=plot_dir,
        filename="03b_density_vs_radius_n_1.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (b)\n{subtitle}",
        show=show)

    n = 5

    subtitle = (
        "Solution to Lane-Embden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_embden_task_3(
        plot_dir=plot_dir,
        filename="03c_density_vs_radius_n_5.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (c)\n{subtitle}",
        show=show)


def task6(plot_dir, figsize, show):
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

    n = 1

    # Plot with Improved Euler method
    # ------------------

    h = 0.01

    subtitle = (
        f"Errors of solutions to Lane-Embden equation, h={h}, n={n}"
    )

    plot_errors(
        plot_dir=plot_dir,
        filename="06a_errors_h_0.1.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 6 (a)\n{subtitle}",
        show=show)

    # ------------------

    # h = 0.01
    #
    # subtitle = (
    #     f"Errors of solutions to Lane-Embden equation, h={h}, n={n}"
    # )
    #
    # plot_errors(
    #     plot_dir=plot_dir,
    #     filename="06b_errors_h_0.01.pdf",
    #     h=h,
    #     n=n,
    #     figsize=figsize,
    #     title=f"Task 6 (a)\n{subtitle}",
    #     show=show)
    #
    # # ------------------
    #
    # h = 0.001
    #
    # subtitle = (
    #     f"Errors of solutions to Lane-Embden equation, h={h}, n={n}"
    # )
    #
    # plot_errors(
    #     plot_dir=plot_dir,
    #     filename="06c_errors_h_0.001.pdf",
    #     h=h,
    #     n=n,
    #     figsize=figsize,
    #     title=f"Task 6 (a)\n{subtitle}",
    #     show=show)


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

    # task1(plot_dir=plot_dir, figsize=figsize, show=show)
    # task2(plot_dir=plot_dir, figsize=figsize, show=show)
    # task3(plot_dir=plot_dir, figsize=figsize, show=show)
    task6(plot_dir=plot_dir, figsize=figsize, show=show)


if __name__ == '__main__':
    make_plots(plot_dir="plots", show=True)
