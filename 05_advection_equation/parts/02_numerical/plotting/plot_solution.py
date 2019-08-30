#
# Plot solutions of
#
#   v_t + v v_x = 0
#
# for various values of x and t.
#

from mpl_toolkits.mplot3d import Axes3D
from plot_utils import create_dir
import matplotlib.pyplot as plt
import numpy as np
import os
import math
from solver import solve_equation
from matplotlib.ticker import FuncFormatter, MultipleLocator


def plot_3d(plot_dir, plot_file_name, nx, nt, method):
    """
    Makes a surface 3D plot of the velocity and saves it to a file.

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
        Numerical method to be used: centered, upwind
    """

    result = solve_equation(x_start=-np.pi/2, x_end=np.pi/2,
                            nx=nx, t_start=0, t_end=1.4, nt=nt, method=method)

    if result is None:
        return
    else:
        x, y, z, dx, dt, dt_dx = result

    z = np.clip(z, 0, 1.1)
    x = [x]
    y = np.transpose([y])

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x, y, z, cmap=plt.cm.jet)
    plt.xlabel("Position x [m]")
    plt.ylabel("Time t [s]")
    ax.set_zlabel("Velocity v [m/s]")

    title_method = method
    if title_method == 'centered':
        title_method = 'centered-difference'

    title = (
        "Numerical solution of advection equation\n"
        f"using {title_method} method\n"
        f"for dx={dx:.3f}, dt={dt:.3f}, dt/dx={dt_dx:.2f}"
    )

    plt.title(title)
    ax.view_init(40, 100)
    ax.set_zlim(0, 1)
    ax.invert_xaxis()
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def plot_2d(plot_dir, plot_file_name, nx, nt, method, plot_timesteps):
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
        Numerical method to be used: centered, upwind

    plot_timesteps : int
        number of timesteps to plot
    """

    result = solve_equation(x_start=-np.pi/2, x_end=np.pi/2,
                            nx=nx, t_start=0, t_end=1.4, nt=nt, method=method)

    if result is None:
        return
    else:
        x, y, z, dx, dt, dt_dx = result

    plot_every_k_timestep = math.floor(float(len(y)) / plot_timesteps)

    for iy, t in enumerate(y):
        if iy % plot_every_k_timestep != 0:
            continue
        velocities = z[iy, :]
        plt.plot(x, velocities, label=f't={t:.1f} s')

    plt.xlabel("Position x [m]")
    plt.ylabel("Velocity v [m/s]")

    title_method = method
    if title_method == 'centered':
        title_method = 'centered-difference'

    title = (
        "Numerical solution of advection equation\n"
        f"using {title_method} method\n"
        f"for dx={dx:.3f}, dt={dt:.3f}, dt/dx={dt_dx:.2f}"
    )

    # Use pi units for the x-axis
    ax = plt.gca()
    ax.xaxis.set_major_formatter(FuncFormatter(
       lambda val, pos: '{:.2g}$\pi$'.format(val/np.pi) if val !=0 else '0'
    ))
    ax.xaxis.set_major_locator(MultipleLocator(base=np.pi/4))

    plt.title(title)
    plt.ylim(0, 1.1)
    plt.legend(loc='upper left')
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def make_plots():
    """
    Make plots of velocity.
    """

    # centered
    # ----------

    plot_3d(plot_dir="plots",
            plot_file_name="centred_nx_100_nt_281_3d.pdf",
            nx=100, nt=281, method='centered')

    plot_2d(plot_dir="plots",
            plot_file_name="centred_nx_100_nt_281_2d.pdf",
            nx=100, nt=281, method='centered', plot_timesteps=10)

    plot_3d(plot_dir="plots",
            plot_file_name="centred_nx_629_nt_281_3d.pdf",
            nx=629, nt=281, method='centered')

    plot_2d(plot_dir="plots",
            plot_file_name="centred_nx_629_nt_281_2d.pdf",
            nx=629, nt=281, method='centered', plot_timesteps=10)

    # upwind
    # ----------

    plot_3d(plot_dir="plots",
            plot_file_name="upwind_nx_100_nt_281_3d.pdf",
            nx=100, nt=281, method='upwind')

    plot_2d(plot_dir="plots",
            plot_file_name="upwind_nx_100_nt_281_2d.pdf",
            nx=100, nt=281, method='upwind', plot_timesteps=10)

    plot_3d(plot_dir="plots",
            plot_file_name="upwind_nx_629_nt_281_3d.pdf",
            nx=629, nt=281, method='upwind')

    plot_2d(plot_dir="plots",
            plot_file_name="upwind_nx_629_nt_281_2d.pdf",
            nx=629, nt=281, method='upwind', plot_timesteps=10)

    plot_3d(plot_dir="plots",
            plot_file_name="upwind_nx_629_nt_259_3d.pdf",
            nx=629, nt=259, method='upwind')

    plot_2d(plot_dir="plots",
            plot_file_name="upwind_nx_629_nt_259_2d.pdf",
            nx=629, nt=259, method='upwind', plot_timesteps=10)


if __name__ == '__main__':
    make_plots()