#
# Plot solutions of advectino equation
#

from plot_utils import create_dir
import matplotlib.pyplot as plt
import numpy as np
import os
from solver import solve_equation


def find_nearest_index(array, value):
    """
    Returns the index of an array element that is closes to the supplied `value`.

    Parameters
    ----------

    array : list
        An array of numbers

    value : int or float
        A value.

    Returns
    -------

    int

    Index of the `array` element.
    """

    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx


def plot_at_time_index(plot_dir, plot_file_name, method,
                       time, it, x_values,
                       solution, dx, dt, dt_dx,
                       ylim):

    y = solution[it, :]
    plt.plot(x_values, y)

    title = (
        "Solution of advection equation "
        f"made with {method} method\n"
        f"for dx={dx:.3f} m, dt={dt:.3f} s, "
        "$v \\Delta t / \\Delta x$"
        f"={dt_dx:.2f}"
    )

    plt.title(title)
    plt.xlabel("Position x [m]")
    plt.ylabel("Density $\\rho$ [$kg \\ m^{-3}$]")
    ax = plt.gca()

    plt.text(
        0.05, 0.89,
        f't = {time:.2f} s',
        horizontalalignment='left',
        verticalalignment='center',
        transform=ax.transAxes,
        bbox=dict(facecolor='white', alpha=0.8, edgecolor='0.7'))

    plt.ylim(ylim)
    plt.tight_layout()

    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)

    plt.show()


def plot_at_time(methods, initial_conditions, courant_factor, nx,
                 plot_dir, file_name, time, ylim):
    """
    Makes a 2D plot of advection equation solution at specified `time`.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used: ftcs, lax, upwind, lax-wendroff

    initial_conditions : str
        Type of initial conditions: square, sine

    courant_factor : float
        Parameter used in the numerical methods

    nx : integer

        Number of x points.

    plot_dir : str
        Directory where the plot file is saved

    file_name : str
        Plot file name

    time : float
        Time of the solution to be plotted.

    ylim : tuple
        Minimum and maximum values of the y-axis.
    """

    x_values = []
    y_values = []
    z_values = []

    for method in methods:
        result = solve_equation(x_start=0, x_end=1,
                                nx=nx, t_start=0, t_end=time,
                                method=method.lower(),
                                initial_conditions=initial_conditions,
                                velocity=1, courant_factor=courant_factor)

        x, y, z, dx, dt, dt_dx = result

        if result is None:
            return
        else:
            x, y, z, dx, dt, dt_dx = result
            x_values.append(x)
            y_values.append(y)
            z_values.append(z)

    # for t in t_values:
    #     it = find_nearest_index(y, t)

    #     file_name = f"{method}_{t:.2f}.pdf"

    #     plot_at_time_index(plot_dir=plot_dir,
    #                        plot_file_name=file_name,
    #                        method=method,
    #                        time=t,
    #                        it=it,
    #                        x_values=x,
    #                        solution=z,
    #                        dx=dx,
    #                        dt=dt,
    #                        dt_dx=dt_dx,
    #                        ylim=ylim)


if __name__ == '__main__':
    # times = [0, 0.2, 0.5, 1]

    # plot_timesteps(plot_dir="plots", initial_conditions="square",
    #                method='ftcs', t_values=times)

    plot_at_time(plot_dir="plots", file_name='plot.pdf',
                 initial_conditions="sine",
                   method='exact', time=1, ylim=(-1.5, 1.5))
