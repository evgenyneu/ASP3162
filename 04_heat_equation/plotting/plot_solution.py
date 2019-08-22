# Plotting solution of x''(t) + x(t) = 0 equation
import numpy as np
import matplotlib.pyplot as plt
import os
from io import StringIO
import pandas as pd
from plot_utils import create_dir
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm


def plot_solution(plot_dir):
    # data = find_solution(t_end=t_end, delta_t=delta_t, print_last=False)

    create_dir(plot_dir)

    # if data is None:
    #     return

    df = pd.read_table("../heat_eqn_output.txt", sep='\s+', header=None)
    x_values = [df.values[0, 1:]]
    t_values = np.transpose([df.values[1:, 0]])
    temperatures = df.values[1:,1:]
    print(x_values)

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x_values, t_values, temperatures, cmap=cm.bone)
    ax.set_xlabel("Length x [m]")
    ax.set_ylabel("Time t [s]")
    ax.set_zlabel("Temperature [T]")
    ax.set_title("Z-component of curl of velocity")
    # plt.savefig(filename)
    plt.show()



if __name__ == '__main__':
    plot_solution(plot_dir="plots")