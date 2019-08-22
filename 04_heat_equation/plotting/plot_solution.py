# Plotting solution of the heat equation
import numpy as np
import matplotlib.pyplot as plt
import os
from io import StringIO
import pandas as pd
from plot_utils import create_dir
from solve_pde import solve_pde
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm


def plot_solution(plot_dir):
    create_dir(plot_dir)

    result = solve_pde(nx=20, nt=300, alpha=0.25, k=2.28e-5)

    if result is None:
        return

    data = result["data"]
    x_values = data["x_values"]
    t_values = data["t_values"]
    temperatures = data["temperatures"]

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x_values, t_values, temperatures, cmap=plt.cm.jet)
    ax.set_xlabel("Length x [m]")
    ax.set_ylabel("Time t [s]")
    ax.set_zlabel("Temperature T [K]")
    ax.set_title("Z-component of curl of velocity")
    pdf_file = os.path.join(plot_dir, "plot_solution.pdf")
    plt.savefig(pdf_file)
    plt.show()


if __name__ == '__main__':
    plot_solution(plot_dir="plots")