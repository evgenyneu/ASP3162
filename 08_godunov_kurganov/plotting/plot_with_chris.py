#
# Plot solutions of advection equation
#

from plot_utils import create_dir
import matplotlib.pyplot as plt
from itertools import cycle
import os
from solver import solve_equation
import numpy as np


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


def plot_at_time(methods, initial_conditions, courant_factor, nx,
                 plot_dir, file_name, time, ylim, show_plot,
                 chris_data_path, chris_data_path_v2,
                 chris_data_title, chris_data_title_v2):
    """
    Makes a 2D plot of advection equation solution at specified `time`.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used.

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

    show_plot : bool
        If False the plot will not be shown on screen (only saved to a file).
        False value is used in unit tests.
    """

    plt.figure(figsize=(8, 6))
    line_styles = ["-", "--", "-.", ":"]
    line_style_cycler = cycle(line_styles)

    plot_at_time = time

    # If we want to plot at time 0, we still need to evolve solution a little bit
    if time == 0:
        time += 0.1

    for method in methods:
        result = solve_equation(x_start=0, x_end=1,
                                nx=nx, t_start=0, t_end=time,
                                method=method.lower(),
                                initial_conditions=initial_conditions,
                                courant_factor=courant_factor)

        if result is None:
            return
        else:
            x, y, z, dx = result
            time_index = find_nearest_index(y, value=plot_at_time)
            actual_time = y[time_index]

            plt.plot(x, z[time_index, :, 0], label=f'{method} Evgenii',
                     linestyle=next(line_style_cycler))

    # Plot Chris's data
    chris_data = np.loadtxt(chris_data_path_v2)
    plt.plot(chris_data[:, 0], chris_data[:, 1],
             label=chris_data_title_v2, linestyle=next(line_style_cycler))

    chris_data = np.loadtxt(chris_data_path)
    plt.plot(chris_data[:, 0], chris_data[:, 1],
             label=chris_data_title, linestyle=next(line_style_cycler))

    title = (
        f"Solutions of Burgers' equation for"
        f" {initial_conditions} in©itial conditions"
    )

    plt.xlim([0, 1])
    plt.ylim(ylim)
    ax = plt.gca()
    plt.text(
        0.05, 0.93,
        f't = {actual_time:.2G} s',
        horizontalalignment='left',
        verticalalignment='center',
        transform=ax.transAxes,
        bbox=dict(facecolor='white', alpha=0.8, edgecolor='0.7'))

    plt.title(title)
    plt.xlabel("Position x [m]")
    plt.ylabel("Speed u [m/s]")
    plt.legend(loc='upper right')
    plt.grid()
    plt.tight_layout()

    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, file_name)
    plt.savefig(pdf_file)

    if show_plot:
        plt.show()


def make_plots(plot_dir, show_plot):
    """
    Create multiple plots.

    Parameters
    ----------
    plot_dir : str
        Directory where the plot file will be saved.

    show_plot : bool
        If False the plot will not be shown on screen (only saved to a file).
        False value is used in unit tests.
    """

    methods = ['Godunov']

    plot_at_time(methods=methods,
                 initial_conditions='sine',
                 courant_factor=0.5,
                 plot_dir=plot_dir, file_name='chris_godunov.pdf',
                 time=1, nx=100, ylim=(-0.5, 0.5), show_plot=show_plot,
                 chris_data_path='plotting/chris/dogunov_1s.dat',
                 chris_data_title='Chris Godunov Original',
                 chris_data_path_v2='plotting/chris/godunov_1s_v2.dat',
                 chris_data_title_v2='Chris Godunov Updated')

    plot_at_time(methods=['Kurganov'],
                 initial_conditions='sine',
                 courant_factor=0.5,
                 plot_dir=plot_dir, file_name='chris_kurganov.pdf',
                 time=1, nx=100, ylim=(-0.5, 0.5), show_plot=show_plot,
                 chris_data_path='plotting/chris/kurganov_1s.dat',
                 chris_data_title='Chris Kurganov Original',
                 chris_data_path_v2='plotting/chris/kurganov_1s_v2.dat',
                 chris_data_title_v2='Chris Godunov Updated')


if __name__ == '__main__':
    make_plots(plot_dir="plots", show_plot=True)
