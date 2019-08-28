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


def plot(plot_dir, plot_file_name):
    x, y, z = solve_equation()

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    x = [x]
    y = np.transpose([y])

    print(f'x= {np.array(x).shape}')
    print(f'y= {np.array(y).shape}')
    print(f'z= {np.array(z).shape}')
    print(f'x {len(x)} y {y.shape} z {z.shape}')
    ax.plot_surface(x, y, z, cmap=plt.cm.jet)
    ax.set_xlabel("Position x [m]")
    ax.set_ylabel("Time t [s]")
    ax.set_zlabel("Velocity v [m/s]")

    ax.set_title(("Analytical solution of advection equation\n"
                  "$v_t + vv_x$ with initial condition\n$v(x,0)=\\cos(x)$"))

    ax.view_init(30, 45)
    ax.set_zlim(0, 1)
    ax.invert_xaxis()
    plt.tight_layout()
    # create_dir(plot_dir)
    # pdf_file = os.path.join(plot_dir, plot_file_name)
    # plt.savefig(pdf_file)
    plt.show()


if __name__ == '__main__':
    plot(plot_dir="plots", plot_file_name="advection_exact_solution.pdf")