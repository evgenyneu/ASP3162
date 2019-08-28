# Plotting solution of the heat equation
import matplotlib.pyplot as plt
import os
from plot_utils import create_dir
from solve_pde import solve_pde
import numpy as np
from mpl_toolkits.mplot3d import Axes3D


def make_plot(data, title, plot_dir, plot_file_name):
    """
    Makes a surface 3D plot of the temperatures and saves it to a file.

    Parameters
    ----------
    data : dict
        Contains x, t values and temperatures for plotting.

    title : str
        Title of the plot

    plot_dir : str
        Directory where the plot file is saved

    plot_file_name : str
        Plot file name
    """

    x_values = data["x_values"]
    t_values = data["t_values"]
    temperatures = data["temperatures"]

    print(f'x= {np.array(x_values).shape}')
    print(f'y= {np.array(t_values).shape}')
    print(f'z= {np.array(temperatures).shape}')

    # fig = plt.figure()
    # ax = fig.gca(projection='3d')
    # ax.plot_surface(x_values, t_values, temperatures, cmap=plt.cm.jet)
    # ax.set_xlabel("Length x [m]")
    # ax.set_ylabel("Time t [s]")
    # ax.set_zlabel("Temperature T [K]")
    # ax.set_title(title)
    # ax.view_init(30, 45)
    # plt.tight_layout()
    # pdf_file = os.path.join(plot_dir, plot_file_name)
    # plt.savefig(pdf_file)
    # plt.show()


def plot_solution(plot_dir, nx, nt, alpha, k):
    """
    Calculates solution to the heat equation, plots the solution and the errors

    Parameters
    ----------
    nx : int
        Number of x points in the grid, including the points on the edges

    nt : int
        Number of t points in the grid

    alpha : float
        The alpha parameter of the numerical solution of the heat equation.
        Values larger than 0.5 results in unstable solutions.

    k : float
        Thermal diffusivity of the rod in m^2 s^{-1}
    """

    create_dir(plot_dir)

    result = solve_pde(nx=nx, nt=nt, alpha=alpha, k=k)

    if result is None:
        return

    # Calculate the steps

    dx = 1. / (nx - 1)
    dt = alpha * dx**2 / k

    # Plot solution
    # -------------

    data = result["data"]

    title = ("Solution of heat equation\n"
             f"nx={nx}, $\\alpha$={alpha:.2f}, dx={dx:.3f} m, dt={dt:.2f} s")

    plot_file_name = f"nx_{nx}_alpha_{alpha:.2f}_solution.pdf"

    make_plot(data=data, title=title, plot_dir=plot_dir,
              plot_file_name=plot_file_name)

    # Plot errors
    # -------------

    data = result["errors"]

    # Calculate max error
    errors = data["temperatures"]
    max_error = np.max(errors)

    title = ("Errors of the solution to the heat equation\n"
             f"nx={nx}, $\\alpha$={alpha:.2f}, dx={dx:.3f} m, dt={dt:.2f} s\n"
             f"Max error: {max_error:.3f} K")

    plot_file_name = f"nx_{nx}_alpha_{alpha:.2f}_errors.pdf"

    make_plot(data=data, title=title, plot_dir=plot_dir,
              plot_file_name=plot_file_name)


if __name__ == '__main__':
    plot_solution(plot_dir="plots", nx=5, alpha=0.1, k=2.28e-5, nt=35)
    # plot_solution(plot_dir="plots", nx=21, alpha=0.25, k=2.28e-5, nt=300)
    # plot_solution(plot_dir="plots", nx=31, alpha=0.5625, k=2.28e-5, nt=180)
