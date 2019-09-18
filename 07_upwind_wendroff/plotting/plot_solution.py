#
# Plot solutions of advection equation
#

from plot_utils import create_dir
import matplotlib.pyplot as plt
from itertools import cycle
import os
from solver import solve_equation


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

    plt.figure(figsize=(8, 6))
    line_styles = ["-", "--", "-.", ":"]
    line_style_cycler = cycle(line_styles)

    for method in methods:
        result = solve_equation(x_start=0, x_end=1,
                                nx=nx, t_start=0, t_end=time,
                                method=method.lower(),
                                initial_conditions=initial_conditions,
                                velocity=1, courant_factor=courant_factor)

        if result is None:
            return
        else:
            x, y, z, dx, dt, dt_dx = result
            actual_time = y[-1]
            plt.plot(x, z[-1, :], label=method,
                     linestyle=next(line_style_cycler))

    title = (
        f"Solution of advection equation\n"
        r"for $\Delta x$"
        f"={dx:.3f} m, "
        r"$\Delta t$"
        f"={dt:.3f} s, "
        "$v \\Delta t / \\Delta x$"
        f"={dt_dx:.2f}"
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
    plt.ylabel("Advected quantity")
    plt.legend(loc='upper right')
    plt.tight_layout()

    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, file_name)
    plt.savefig(pdf_file)

    plt.show()


def make_plots():
    """
    Create multiple plots.
    """

    methods = ['Exact', 'Lax-Wendroff', 'Lax', 'Upwind']
    time = 1

    plot_at_time(methods=methods,
                 initial_conditions='sine',
                 courant_factor=0.5,
                 plot_dir="plots", file_name='01_sine_c_0.5.pdf',
                 time=time, nx=100, ylim=(-1.5, 1.5))

    plot_at_time(methods=methods,
                 initial_conditions='square',
                 courant_factor=0.5,
                 plot_dir="plots", file_name='02_square_c_0.5.pdf',
                 time=time, nx=100, ylim=(-0.5, 1.5))

    plot_at_time(methods=methods,
                 initial_conditions='sine',
                 courant_factor=1,
                 plot_dir="plots", file_name='03_sine_c_1.pdf',
                 time=time, nx=100, ylim=(-1.5, 1.5))

    plot_at_time(methods=methods,
                 initial_conditions='square',
                 courant_factor=1,
                 plot_dir="plots", file_name='04_square_c_1.pdf',
                 time=time, nx=100, ylim=(-0.5, 1.5))


if __name__ == '__main__':
    make_plots()