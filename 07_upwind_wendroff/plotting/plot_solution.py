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
                       solution, dx, dt, dt_dx):

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

    plt.ylim(-0.5, 1.5)
    plt.tight_layout()

    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)

    plt.show()


def plot_timesteps(plot_dir, method, initial_conditions, t_values):
    """
    Makes a 2D plot of the velocity at different time values
    and saves it to a file.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot file is saved

    plot_file_name : str
        Plot file name

    nx : int
        The number of x points in the grid

    nt : int
        The number of t points in the grid

    method : str
        Numerical method to be used: ftcs, lax

    initial_conditions : str
        Type of initial conditions: square, sine

    plot_timesteps : int
        number of timesteps to plot
    """

    result = solve_equation(x_start=0, x_end=1,
                            nx=100, t_start=0, t_end=1, method=method,
                            initial_conditions=initial_conditions)

    if result is None:
        return
    else:
        x, y, z, dx, dt, dt_dx = result

    for t in t_values:
        it = find_nearest_index(y, t)

        file_name = f"{method}_{t:.2f}.pdf"

        plot_at_time_index(plot_dir=plot_dir,
                           plot_file_name=file_name,
                           method=method,
                           time=t,
                           it=it,
                           x_values=x,
                           solution=z,
                           dx=dx,
                           dt=dt,
                           dt_dx=dt_dx)


if __name__ == '__main__':
    # times = [0, 0.2, 0.5, 1]
    times = [0]

    # plot_timesteps(plot_dir="plots", initial_conditions="square",
    #                method='ftcs', t_values=times)

    plot_timesteps(plot_dir="plots", initial_conditions="square",
                   method='lax', t_values=times)
