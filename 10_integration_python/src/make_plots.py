"""Show all plots"""

import matplotlib.pyplot as plt
from astropy import units as u
from astropy import constants
from lane_emden_integrator import LaneEmdenIntegrator
from euler_integrator import EulerIntegrator
from plot_utils import save_plot
from make_plots_task_2 import plot_lane_emden_task_2
from make_plots_task_3 import plot_lane_emden_task_3
from surface import calculate_surface_values, save_surface_values_to_csv
from stellar_structure import plot_density, plot_temperature, plot_pressure
from integrate import integrate, euler_integrator


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

    x, y = integrate(step_size=h,
                     polytropic_index=n,
                     integrator=euler_integrator)

    plt.figure(figsize=figsize)
    plt.xlabel(r'Scaled radius, $\xi$')
    plt.ylabel(r'Scaled density, $\theta$')

    title = (
        "Task 1\n"
        f"Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plt.title(title)
    plt.plot(x, y[:, 0], label="Density")
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename="01_lane_emden.pdf")

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
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_2(
        plot_dir=plot_dir,
        filename="02a_density_vs_radius_h_0.1.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 2 (a)\n{subtitle}",
        show=show)

    h = 0.01

    subtitle = (
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_2(
        plot_dir=plot_dir,
        filename="02b_density_vs_radius_h_0.01.pdf",
        h=0.01,
        n=3,
        figsize=figsize,
        title=f"Task 2 (b)\n{subtitle}",
        show=show)

    h = 0.001

    subtitle = (
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_2(
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
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_3(
        plot_dir=plot_dir,
        filename="03a_density_vs_radius_n_0.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (a)\n{subtitle}",
        show=show)

    n = 1

    subtitle = (
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_3(
        plot_dir=plot_dir,
        filename="03b_density_vs_radius_n_1.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (b)\n{subtitle}",
        show=show)

    n = 5

    subtitle = (
        "Solution to Lane-Emden equation\n"
        f"Euler method, h={h}, n={n}"
    )

    plot_lane_emden_task_3(
        plot_dir=plot_dir,
        filename="03c_density_vs_radius_n_5.pdf",
        h=h,
        n=n,
        figsize=figsize,
        title=f"Task 3 (c)\n{subtitle}",
        show=show)


def task6(data_dir, figsize, show):
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

    df = calculate_surface_values(n=1)

    save_surface_values_to_csv(df=df, data_dir=data_dir,
                               filename="06_surface_values.csv")


def task7(plot_dir, figsize, show):
    stellar_mass = 2 * constants.M_sun
    central_density = 1e5 * u.kg / u.meter**3
    step_size = 0.001
    polytropic_index = 3
    mean_molecular_weight = 1.4

    plot_density(plot_dir=plot_dir,
                 filename="07a_density.pdf",
                 figsize=figsize,
                 stellar_mass=stellar_mass,
                 central_density=central_density,
                 step_size=step_size,
                 polytropic_index=polytropic_index,
                 mean_molecular_weight=mean_molecular_weight,
                 title_prefix="Task 7 (a)\n",
                 show=show)

    plot_temperature(plot_dir=plot_dir,
                     filename="07b_temperature.pdf",
                     figsize=figsize,
                     stellar_mass=stellar_mass,
                     central_density=central_density,
                     step_size=step_size,
                     polytropic_index=polytropic_index,
                     mean_molecular_weight=mean_molecular_weight,
                     title_prefix="Task 7 (b)\n",
                     show=show)

    plot_pressure(plot_dir=plot_dir,
                  filename="07c_pressure.pdf",
                  figsize=figsize,
                  stellar_mass=stellar_mass,
                  central_density=central_density,
                  step_size=step_size,
                  polytropic_index=polytropic_index,
                  mean_molecular_weight=mean_molecular_weight,
                  title_prefix="Task 7 (c)\n",
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

    # task1(plot_dir=plot_dir, figsize=figsize, show=show)
    # task2(plot_dir=plot_dir, figsize=figsize, show=show)
    task3(plot_dir=plot_dir, figsize=figsize, show=show)
    # task6(data_dir=plot_dir, figsize=figsize, show=show)
    # task7(plot_dir=plot_dir, figsize=figsize, show=show)


if __name__ == '__main__':
    make_plots(plot_dir="plots", show=True)
