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
    # print(f'x {len(x)} y {y.shape} z {z.shape}')
    ax.plot_surface(x, y, z, cmap=plt.cm.jet)
    ax.set_xlabel("Length x [m]")
    ax.set_ylabel("Time t [s]")
    ax.set_zlabel("Temperature T [K]")
    ax.set_title("Hi, I'm a title")
    ax.view_init(30, 45)
    plt.tight_layout()
    create_dir(plot_dir)
    pdf_file = os.path.join(plot_dir, plot_file_name)
    plt.savefig(pdf_file)
    plt.show()


if __name__ == '__main__':
    plot(plot_dir="plots", plot_file_name="advection_exact_solution.pdf")