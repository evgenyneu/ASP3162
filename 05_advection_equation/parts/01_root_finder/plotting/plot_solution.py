#
# Plot solutions of
#
#   cos(x - v * t) - v = 0
#
# for various values of x and t.
#

from mpl_toolkits.mplot3d import Axes3D
from plot_utils import create_dir
import matplotlib.pyplot as plt
import numpy as np
import os
from solver import solve_equation
from matplotlib.ticker import FuncFormatter, MultipleLocator


def plot_3d(plot_dir, plot_file_name):
    """
    Makes a surface 3D plot of the velocity and saves it to a file.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot file is saved

    plot_file_name : str
        Plot file name
    """

    result = solve_equation(x_start=-1.6, x_end=1.6, nx=200,
                            t_start=0, t_end=1.4, nt=50,
                            v_start=0.8, tolerance=1e-5, max_iterations=1000)

    if result is None:
        return
    else:
        x, y, z = result
        z = np.clip(z, 0, 1.1)

    x = [x]
    y = np.transpose([y])

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x, y, z, cmap=plt.cm.jet)
    plt.xlabel("Position x [m]")
    plt.ylabel("Time t [s]")
    ax.set_zlabel("Velocity v [m/s]")

    plt.title(("Analytical solution of advection equation\n"
               "$v_t + vv_x=0$ with initial condition\n$v(x,0)=\\cos(x)$"))

    ax.view_init(40, 110)
    ax.set_zlim(0, 1)
    ax.invert_xaxis()
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def plot_2d(plot_dir, plot_file_name, v_start):
    """
    Makes a 2D plot of the velocity at different time values
    and saves it to a file.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot file is saved

    plot_file_name : str
        Plot file name

    v_start : float
        The starting value for v for the root finding algorithm.
    """

    result = solve_equation(x_start=-1.6, x_end=1.6, nx=100,
                            t_start=0, t_end=1.4, nt=8,
                            v_start=v_start, tolerance=1e-5, max_iterations=5000)

    if result is None:
        return
    else:
        x, y, z = result
        z = np.clip(z, 0, 1.1)

    for iy, t in enumerate(y):
        velocities = z[iy, :]
        plt.plot(x, velocities, label=f't={t:.1f} s')

    # Use pi units for the x-axis
    ax = plt.gca()
    ax.xaxis.set_major_formatter(FuncFormatter(
       lambda val, pos: '{:.2g}$\pi$'.format(val/np.pi) if val !=0 else '0'
    ))
    ax.xaxis.set_major_locator(MultipleLocator(base=np.pi/4))

    plt.xlabel("Position x [m]")
    plt.ylabel("Velocity v [m/s]")
    plt.title(("Analytical solution of advection equation\n"
               "$v_t + vv_x=0$ with initial condition\n$v(x,0)=\\cos(x)$"
               f", v_start={v_start} m/s"))

    plt.ylim(0, 1.1)
    plt.legend()
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def make_plots():
    """
    Make plots of velocity.
    """

    plot_3d(plot_dir="plots",
            plot_file_name="advection_analytical_solution_3d.pdf")

    plot_2d(plot_dir="plots",
            plot_file_name="advection_analytical_solution_2d_vstart_0_62.pdf",
            v_start=0.62)

    plot_2d(plot_dir="plots",
            plot_file_name="advection_analytical_solution_2d_vstart_0_15.pdf",
            v_start=0.15)


if __name__ == '__main__':
    make_plots()