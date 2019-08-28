#
# Plot solution of
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


def plot_3d(x, y, z, plot_dir, plot_file_name):
    x = [x]
    y = np.transpose([y])

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x, y, z, cmap=plt.cm.jet)
    plt.xlabel("Position x [m]")
    plt.ylabel("Time t [s]")
    ax.set_zlabel("Velocity v [m/s]")

    plt.title(("Analytical solution of advection equation\n"
               "$v_t + vv_x=0$ with initial condition\n$v(x,0)=\\cos(x)$ at different times"))

    ax.view_init(30, 45)
    ax.set_zlim(0, 1)
    ax.invert_xaxis()
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def plot_2d(x, y, z, plot_dir, plot_file_name):
    for iy, t in enumerate(y):
        velocities = z[iy, :]
        plt.plot(x, velocities, label=f't={t:.1f} s')

    plt.xlabel("Position x [m]")
    plt.ylabel("Velocity v [m/s]")
    plt.title(("Analytical solution of advection equation\n"
               "$v_t + vv_x=0$ with initial condition\n$v(x,0)=\\cos(x)$"))

    plt.ylim(0, 1.1)
    plt.legend()
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


def make_plots():
    result = solve_equation(x_start=-1.6, x_end=1.6, nx=100)

    if result is None:
        return
    else:
        x, y, z = result

    # plot_3d(x=x, y=y, z=z, plot_dir="plots",
            # plot_file_name="advection_analytical_solution_3d.pdf")

    plot_2d(x=x, y=y, z=z, plot_dir="plots",
            plot_file_name="advection_analytical_solution_2d.pdf")


if __name__ == '__main__':
    make_plots()